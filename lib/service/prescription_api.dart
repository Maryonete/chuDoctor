
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Modification de l'importation pour utiliser http au lieu de IOClient
import 'package:doctor/utils/constants.dart';

class PrescriptionApi {
  // Retourne la liste des prescriptions d'un patient.
  //
  // Cette fonction envoie une requête POST à l'API pour obtenir la liste des prescriptions
  // associées à un patient. Elle utilise les données de prescription fournies pour
  // construire le corps de la requête. Si la requête réussit avec un code de statut 200,
  // elle décode la réponse JSON en une liste dynamique d'objets Dart représentant les
  // données des prescriptions. Ensuite, elle parcourt chaque élément de la liste, vérifie
  // l'existence des clés nécessaires, et ajoute les données de chaque prescription à une
  // liste. En cas d'échec du décodage JSON ou d'une erreur de requête HTTP, une exception
  // est levée avec un message approprié.
  static Future<List<Map<String, dynamic>>?> getPrescriptionsPatient(BuildContext context, Map<String, dynamic> prescriptionData) async {
    //print('[API] getPrescriptionsPatient');

    final url = Uri.parse(urlApi + 'getPrescriptionPatients');

    try {
      var response = await http.post(
        url,
        body: jsonEncode(prescriptionData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );


      if (response.statusCode == 200) {
        try {
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> patientDataList = [];

          for (var item in jsonData) {
            if (item.containsKey('id')) {
              Map<String, dynamic> patientData = {
                'id': item['id'],
                'start': item['start'],
                'end': item['end'],
                'medications': item['medications'],
              };
              patientDataList.add(patientData);
            }
          }
          return patientDataList;
        } catch (e) {
          //print('Erreur lors du décodage de la réponse JSON: $e');
          throw Exception('Erreur lors du décodage de la réponse JSON');
        }
      } else {
        //print('Erreur de requête: ${response.reasonPhrase}');
        throw Exception('Erreur de requête: ${response.reasonPhrase}');
      }
    } catch (e) {
      //print(e.toString());
      rethrow;
    }
  }

  // Création d'une nouvelle prescription.
  //
  // Cette fonction envoie une requête POST à l'API pour créer une nouvelle prescription
  // en utilisant les données fournies dans le paramètre 'prescriptionData'. Les données
  // de la prescription sont encodées en JSON et incluses dans le corps de la requête.
  // Si la création de la prescription réussit avec un code de statut 200, la fonction
  // affiche un message indiquant que la prescription a été ajoutée avec succès. En cas
  // d'échec de la requête HTTP, une exception est levée avec un message d'erreur
  // approprié, et l'erreur est affichée dans la console.
  Future<void> addPrescription(Map<String, dynamic> prescriptionData) async {
    //print("[API addPrescription]");
    final url = Uri.parse(urlApi + 'addPrescription');

    try {
      var response = await http.post(
        url,
        body: jsonEncode(prescriptionData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update prescription end date - status : ${response.statusCode}');
      }
      // print('Prescription ajoutée avec succès');
    } catch (e) {
      print('Error updating prescription date: $e');
    }
  }

  // Mise à jour de la date de fin d'une prescription.
  //
  // Cette fonction envoie une requête POST à l'API pour mettre à jour la date de fin
  // d'une prescription spécifique identifiée par son ID. Elle utilise l'identifiant de
  // la prescription et la nouvelle date de fin fournie pour construire le corps de la
  // requête. Si la requête réussit avec un code de statut 200, elle retourne true pour
  // indiquer que la mise à jour a été effectuée avec succès. En cas d'échec de la requête
  // HTTP, une exception est levée avec un message d'erreur approprié, et la fonction
  // retourne false. Les erreurs sont affichées dans la console.
  Future<bool> setPrescriptionDateEnd(int prescriptionId, DateTime newDate) async {
    final url = Uri.parse(urlApi + 'setPrescriptionDateEnd');

    try {
      var response = await http.post(
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

        throw Exception('Failed to update prescription end date - status : ${response.statusCode}');
      }

      return true;
    } catch (e) {
      print('Error updating prescription date: $e');
      return false;
    }
  }


  // Retourne la liste des médicaments.
  //
  // Cette fonction envoie une requête POST à l'API pour obtenir la liste des médicaments.
  // Si la requête réussit avec un code de statut 200, elle décode la réponse JSON en une
  // liste dynamique d'objets Dart représentant les données des médicaments. Ensuite, elle
  // parcourt chaque élément de la liste et construit un objet contenant l'identifiant et
  // le nom du médicament, qu'elle ajoute à une liste. En cas d'échec du décodage JSON ou
  // d'une erreur de requête HTTP, une exception est levée avec un message approprié.
  Future<List<Map<String, dynamic>>?> getDrugs(BuildContext context) async {
    print('[API] getDrugs');
    final url = Uri.parse(urlApi + 'getDrugs');

    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        try {
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> drugDataList = [];

          for (var item in jsonData) {
            Map<String, dynamic> drugData = {
              'id': item['id'],
              'name': item['name'],
            };
            drugDataList.add(drugData);
          }
          return drugDataList;
        } catch (e) {
          print('Erreur lors du décodage de la réponse JSON: $e');
          throw Exception('Erreur lors du décodage de la réponse JSON');
        }
      } else {
        print('Erreur de requête: ${response.reasonPhrase}');
        throw Exception('Erreur de requête: ${response.reasonPhrase}');
      }
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
