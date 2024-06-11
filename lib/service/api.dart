import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/utils.dart';
import 'package:http/http.dart' as http;


class Api {
  /// Effectue une demande de connexion à l'API pour obtenir un token JWT.
  ///
  /// [data]: Les données de connexion à envoyer à l'API.
  /// [context]: Le contexte de l'application.
  ///
  /// Retourne un objet [Map<String, dynamic>] contenant la réponse de l'API.
  /// Si la connexion est réussie, l'objet contiendra le token JWT.
  /// En cas d'erreur, une exception est levée avec un message d'erreur.
  Future<Map<String, dynamic>> login(data, context) async {
    print('API LOGIN');

    try {
      var response = await http.post(
        Uri.parse(urlApi + 'login_check'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

    print(response.statusCode );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var jwtToken = jsonResponse['token'];
        var decodedToken = _decodeJwt(jwtToken);

        if (!decodedToken['roles'].contains('ROLE_MEDECIN')) {
          throw Exception('Cette page n\'est pas autorisée');
        }

        // enregistre info medecin dans localstorage
        await setInfoDoctor(decodedToken['username'], context);

        return jsonResponse;
      } else {
        throw Exception('Erreur de connexion: ${response.statusCode}');
      }
    } catch (e) {
      SnackbarUtils.showMessage(context, e.toString());
      // l'erreur est également signalée à l'appelant de la fonction login
      throw e;
    }
  }


  /// Enregistre les informations du médecin connecté dans le stockage local.
  ///
  /// [email]: L'email du médecin connecté.
  /// [context]: Le contexte de l'application.
  ///
  /// Cette fonction envoie une requête à l'API pour obtenir les informations
  /// du médecin correspondant à l'email spécifié, puis enregistre ces informations
  /// dans le stockage local de l'application.
  Future<void> setInfoDoctor(String email, context) async {
    // Récupérer l'instance de SharedPreferences pour le stockage local
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final url = Uri.parse(urlApi + 'getInfoMedecin');


    try {
      var response = await http.post(
        url,
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      try {
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          // Enregistrer les informations du médecin dans le stockage local
          localStorage.setString('user_id', jsonResponse['user_id'].toString());
          localStorage.setString('firstName', jsonResponse['firstName']);
          localStorage.setString('lastName', jsonResponse['lastName']);
          localStorage.setString('email', email);


          // Afficher un message de confirmation
          print('Informations du médecin enregistrées avec succès.');
        }
      } catch (e) {
        // Gérer les erreurs de traitement de la réponse de l'API
        print(e.toString());
        SnackbarUtils.showMessage(context, e.toString());
      }
    } catch (e) {

      // Gérer les erreurs de connexion à l'API
      print(e.toString());
      rethrow;
    }
  }



  Map<String, dynamic> _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _urlBase64Decode(parts[1]);
    final payloadMap = jsonDecode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid payload');
    }
    return payloadMap;
  }

  String _urlBase64Decode(String encoded) {
    String output = encoded.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
