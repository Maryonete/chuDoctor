import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // Ajout de l'importation pour X509Certificate

class Api {
  String urlApi = 'https://127.0.0.1:8000/api/';

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
        Uri.parse(urlApi + 'login_check'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      print(response.statusCode);
      print(jsonEncode(data));
      print(response.headers['location']);
      try {
        print(response.statusCode);

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          var jwtToken = jsonResponse['token'];
          var decodedToken = _decodeJwt(jwtToken);

          if (!decodedToken['roles'].contains('ROLE_MEDECIN')) {
            throw Exception('Cette page n\'est pas autorisée');
          }

          setInfoDoctor(decodedToken['username'], context);

          return jsonResponse;
        }   else if (response.statusCode == 400) {
          throw Exception('Erreur de syntaxe dans la requête: ${response.statusCode}');
        }
        else {
          throw Exception('Erreur de connexion: ${response.statusCode}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        throw e;
      }
    }  catch (e) {
      print(e.toString());
      rethrow;
    }

    // Dans le cas où aucun des chemins ci-dessus n'est suivi, vous pouvez choisir de retourner une valeur par défaut
    return {};
  }

  // info docteur connecté
  Future<void> setInfoDoctor(String email, context) async {
    print('[API] setInfoDoctor : $email');
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    final url = Uri.parse(urlApi + 'getInfoMedecin');

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
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('setInfoDoctor reponse statut : ${response.statusCode}');
      try {
        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          localStorage.setString('user_id', jsonResponse['user_id'].toString());
          localStorage.setString('firstName', jsonResponse['firstName']);
          localStorage.setString('lastName', jsonResponse['lastName']);
          localStorage.setString('email', email);

          var userId = localStorage.getString('user_id');
          print('user_id : ${userId ?? 'null'}');
        }
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  // info patient
  Future<Map<String, dynamic>?> getInfoPatient(int idPatient) async  {
    print('[API] getInfoPatient : $idPatient');

    final url = Uri.parse(urlApi + 'getInfoPatient/$idPatient');

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
      try {
        if (response.statusCode == 200) {
// Décoder la réponse JSON en une carte dynamique de Dart
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          // Retourner les données du patient

          return jsonData;
        }
      } catch (e) {
        print(e.toString());
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
// Retourne la liste des medicaments
  Future<List<Map<String, dynamic>>?> getDrugs(BuildContext context) async {
    print('[API] getDrugs');
    final url = Uri.parse(urlApi + 'getDrugs');
    print(url);
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
      print('réponse statut : ${response.statusCode}');

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
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? userId = localStorage.getString('user_id');
    if (userId == null) {
      throw Exception('Erreur d\'authentification');
    }

    final url = Uri.parse(urlApi + 'getPatients/$userId');
    print(url);
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
      print('réponse statut : ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          // Décoder la chaîne JSON en une liste dynamique d'objets Dart
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> patientDataList = [];

          // Parcourir chaque élément de la liste
          for (var item in jsonData) {
            print(item);
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
  // maj date de fin d'une prescription
  Future<void> addPrescription() async {
    final url = Uri.parse(urlApi + 'addPrescription');

    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      var clientWithBadCert = IOClient(httpClient);

      var response = await clientWithBadCert.post(
        url,

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update prescription end date - status : ' + response.statusCode.toString());
      }

      // Si la mise à jour s'est déroulée avec succès, retourner true
    } catch (e) {
      // En cas d'erreur, retourner false
      print('Error updating prescription date: $e');
    }
  }
  // maj date de fin d'une prescription
  Future<bool> setPrescriptionDateEnd(int prescriptionId, DateTime newDate) async {
    final url = Uri.parse(urlApi + 'setPrescriptionDateEnd');

    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      var clientWithBadCert = IOClient(httpClient);

      var response = await clientWithBadCert.post(
        url,
        body: jsonEncode(<String, dynamic>{
          'prescriptionId': prescriptionId,
          'newEndDate': newDate.toIso8601String(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update prescription end date - status : ' + response.statusCode.toString());
      }

      // Si la mise à jour s'est déroulée avec succès, retourner true
      return true;
    } catch (e) {
      // En cas d'erreur, retourner false
      print('Error updating prescription date: $e');
      return false;
    }
  }



  // Retourne la liste des prescriptions d un patient
  Future<List<Map<String, dynamic>>?> getPrescriptionsPatient(BuildContext context, userId) async {
    print('[API] getPrescriptionsPatient');

    final url = Uri.parse(urlApi + 'getPrescriptionPatients/$userId');
    print(url);
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
      print('réponse statut : ${response.statusCode}');

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
                'id': item['id'],
                'start': item['start'],
                'end': item['end'],
                'medications': item['medications'], // Ajouter la liste des médications à patientData
              };

              // Ajouter les données du patient à la liste
              patientDataList.add(patientData);
            } else {
              print('Les données de la prescription sont incomplètes  : $item');
            }
          }
          // Retourner la liste des prescriptions du patient
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


  Map<String, dynamic> _decodeJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = _urlBase64Decode(parts[1]); // Utilisation de la méthode ici
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
