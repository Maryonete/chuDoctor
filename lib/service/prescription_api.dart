import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:doctor/utils/constants.dart';


class PrescriptionApi {

  // Retourne la liste des prescriptions d un patient
  static Future<List<Map<String, dynamic>>?> getPrescriptionsPatient(BuildContext context,  Map<String, dynamic> prescriptionData) async {
    print('[API] getPrescriptionsPatient');

    final url = Uri.parse(urlApi + 'getPrescriptionPatients');
    
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
        body: jsonEncode(prescriptionData),
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
  // création  d'une prescription
  Future<void> addPrescription(Map<String, dynamic> prescriptionData) async {
    print("[API addPrescription]");
    final url = Uri.parse(urlApi + 'addPrescription');
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    try {
      var clientWithBadCert = IOClient(httpClient);

      var response = await clientWithBadCert.post(
        url,
        body: jsonEncode(prescriptionData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(jsonEncode(prescriptionData));

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


}