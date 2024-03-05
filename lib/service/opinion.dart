import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:doctor/utils/constants.dart';

class OpinionApi {

  // Retourne la liste des avis sur un patient
  static Future<List<Map<String, dynamic>>?> getOpinionsPatient(BuildContext context, Map<String, dynamic> opinionData) async {
    print('[API] getOpinionsPatient');

    final url = Uri.parse(urlApi + 'getOpinionsPatient');

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
        body: jsonEncode(opinionData),
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
                'id': item['id'],
                'title': item['title'],
                'date': item['date'],
                'description': item['description'],
              };

              // Ajouter les données du patient à la liste
              patientDataList.add(patientData);
            } else {
              print('Les données de l\'avis sont incomplets  : $item');
            }
          }
          // Retourner la liste des avis sur le patient
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
  // ajout opinion sur un patient
  static Future<void> addOpinion(BuildContext context, Map<String, dynamic> opinionData) async {
    print("[API addOpinion]");
    final url = Uri.parse(urlApi + 'addOpinion');
    print(url);
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      var clientWithBadCert = IOClient(httpClient);

      var response = await clientWithBadCert.post(
        url,
        body: jsonEncode(opinionData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(jsonEncode(opinionData));

      if (response.statusCode != 200) {
        throw Exception('Failed to update prescription end date - status : ' + response.statusCode.toString());
      }
      print('Prescription ajoutée avec succès');
      // Si la mise à jour s'est déroulée avec succès, retourner true
    } catch (e) {
      // En cas d'erreur, retourner false
      print('Error updating prescription date: $e');
    }
  }

}