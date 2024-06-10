import 'dart:convert';
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'package:doctor/utils/constants.dart';
import 'package:doctor/utils/utils.dart';
import 'package:doctor/utils/snackbar_utils.dart';

class Api {

  Future<Map<String, dynamic>> login(data, context) async {
    print('[API] login');

    // Créer un client HTTP avec désactivation de la vérification du certificat SSL
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      // Utiliser IOClient à la place de http.IOClient
      var clientWithBadCert = IOClient(
        httpClient,
      );

      var response = await clientWithBadCert.post(
=======
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
>>>>>>> d0db740 (add icon)
        Uri.parse(urlApi + 'login_check'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );
<<<<<<< HEAD
      try {

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
        }
        else {
          throw Exception('Erreur de connexion: ${response.statusCode}');
        }
      } catch (e) {
        SnackbarUtils.showMessage(context, e.toString());
        throw e;
      }
    }  catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // info docteur connecté
  Future<void> setInfoDoctor(String email, context) async {
    print('[API] setInfoDoctor : $email');
=======
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
>>>>>>> d0db740 (add icon)
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final url = Uri.parse(urlApi + 'getInfoMedecin');

<<<<<<< HEAD
    // Créer un client HTTP avec désactivation de la vérification du certificat SSL
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      // Utiliser IOClient à la place de http.IOClient
      var clientWithBadCert = IOClient(
        httpClient,
      );

      var response = await clientWithBadCert.post(
=======
    try {
      var response = await http.post(
>>>>>>> d0db740 (add icon)
        url,
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
<<<<<<< HEAD

      try {

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
=======
      try {
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);

          // Enregistrer les informations du médecin dans le stockage local
>>>>>>> d0db740 (add icon)
          localStorage.setString('user_id', jsonResponse['user_id'].toString());
          localStorage.setString('firstName', jsonResponse['firstName']);
          localStorage.setString('lastName', jsonResponse['lastName']);
          localStorage.setString('email', email);
<<<<<<< HEAD
        }
      } catch (e) {
=======

          // Afficher un message de confirmation
          print('Informations du médecin enregistrées avec succès.');
        }
      } catch (e) {
        // Gérer les erreurs de traitement de la réponse de l'API
>>>>>>> d0db740 (add icon)
        print(e.toString());
        SnackbarUtils.showMessage(context, e.toString());
      }
    } catch (e) {
<<<<<<< HEAD
=======
      // Gérer les erreurs de connexion à l'API
>>>>>>> d0db740 (add icon)
      print(e.toString());
      rethrow;
    }
  }

<<<<<<< HEAD
// Retourne la liste des medicaments
  Future<List<Map<String, dynamic>>?> getDrugs(BuildContext context) async {
    print('[API] getDrugs');
    final url = Uri.parse(urlApi + 'getDrugs');

    // Créer un client HTTP avec désactivation de la vérification du certificat SSL
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      // Utiliser IOClient à la place de http.IOClient
      var clientWithBadCert = IOClient(
        httpClient,
      );

      var response = await clientWithBadCert.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );


      if (response.statusCode == 200) {
        try {
          // Décoder la chaîne JSON en une liste dynamique d'objets Dart
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> drugDataList = [];

          for (var item in jsonData) {
                Map<String, dynamic> drugData = {
                'id': item['id'],
                'name': item['name'],
              };
              drugDataList.add(drugData);
          }
          // Retourner la liste de données des patients
          return drugDataList;
        } catch (e) {
          // Gérer les exceptions
          print('Erreur lors du décodage de la réponse JSON: $e');
          throw Exception('Erreur lors du décodage de la réponse JSON');
        }
      } else {
        // Gérer les erreurs de réponse HTTP
        print('Erreur de requête: ${response.reasonPhrase}');
        throw Exception('Erreur de requête: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  // Retourne la liste des patients du medecin connecté
  Future<List<Map<String, dynamic>>?> getPatients(BuildContext context) async {
    print('[API] getPatients');

    String? userId = await AuthUtils().checkMedecinID();
    print(userId);
    if (userId == null) {
      throw Exception('Erreur d\'authentification');
    }

    final url = Uri.parse(urlApi + 'getPatients/$userId');

    // Créer un client HTTP avec désactivation de la vérification du certificat SSL
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      // Utiliser IOClient à la place de http.IOClient
      var clientWithBadCert = IOClient(
        httpClient,
      );

      var response = await clientWithBadCert.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );


      if (response.statusCode == 200) {
        try {
          // Décoder la chaîne JSON en une liste dynamique d'objets Dart
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> patientDataList = [];

          // Parcourir chaque élément de la liste
          for (var item in jsonData) {

            // Vérifier si toutes les clés nécessaires existent dans l'objet
            if (item.containsKey('id') ) {
              // Extraire les données du patient de l'élément actuel
              Map<String, dynamic> patientData = {
                'title': item['title'],
                'start': item['start'],
                'end': item['end'],
                'description': item['description'],
                'speciality': item['speciality'],
                'reason': item['reason'],
                'patient_id':item['patient_id'],
              };

              // Ajouter les données du patient à la liste
              patientDataList.add(patientData);
            } else {
              print('Les données du rdv sont incomplètes  : $item');
            }
          }
          // Retourner la liste de données des patients
          return patientDataList;
        } catch (e) {
          // Gérer les exceptions
          print('Erreur lors du décodage de la réponse JSON: $e');
          throw Exception('Erreur lors du décodage de la réponse JSON');
        }
      } else {
        // Gérer les erreurs de réponse HTTP
        print('Erreur de requête: ${response.reasonPhrase}');
        throw Exception('Erreur de requête: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }





=======
>>>>>>> d0db740 (add icon)

  Map<String, dynamic> _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }
<<<<<<< HEAD

    final payload = _urlBase64Decode(parts[1]); // Utilisation de la méthode ici
=======
    final payload = _urlBase64Decode(parts[1]);
>>>>>>> d0db740 (add icon)
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
