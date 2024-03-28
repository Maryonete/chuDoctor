import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:chudoctor/utils/constants.dart';
import 'package:chudoctor/utils/utils.dart';
import 'package:http/http.dart' as http;


class PatientApi {

  // Retourne la liste des patients du médecin connecté.
  //
  // Cette fonction envoie une requête POST à l'API pour obtenir la liste des patients
  // associés au médecin connecté. Elle utilise l'ID du médecin pour construire l'URL
  // de la requête. Si l'authentification du médecin échoue, une exception est levée.
  // Si la requête réussit avec un code de statut 200, elle décode la réponse JSON en
  // une liste dynamique d'objets Dart représentant les données des patients. Ensuite,
  // elle parcourt chaque élément de la liste, vérifie l'existence des clés nécessaires,
  // et ajoute les données de chaque patient à une liste. En cas d'échec du décodage JSON
  // ou d'une erreur de requête HTTP, une exception est levée avec un message approprié.
  Future<List<Map<String, dynamic>>?> getPatients(BuildContext context) async {
    print('[API] getPatients');

    // Récupère l'ID du médecin connecté
    String? userId = await AppUsersUtils().checkMedecinID();
    print(userId);
    // Vérifie si l'authentification du médecin a réussi
    if (userId == null) {
      throw Exception('Erreur d\'authentification');
    }

    // Construit l'URL de la requête pour obtenir la liste des patients du médecin
    final url = Uri.parse(urlApi + 'getPatients/$userId');

    try {
      // Envoie une requête POST pour obtenir la liste des patients
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Vérifie si la requête a réussi (code de statut 200)
      if (response.statusCode == 200) {
        try {
          // Décodage de la réponse JSON en une liste dynamique d'objets Dart
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> patientDataList = [];

          // Parcours chaque élément de la liste des patients
          for (var item in jsonData) {
            // Vérifie si toutes les clés nécessaires existent dans l'objet
            if (item.containsKey('id')) {
              // Construit les données du patient à partir de l'élément actuel
              Map<String, dynamic> patientData = {
                'title': item['title'],
                'start': item['start'],
                'end': item['end'],
                'description': item['description'],
                'speciality': item['speciality'],
                'reason': item['reason'],
                'patient_id': item['patient_id'],
              };

              // Ajoute les données du patient à la liste
              patientDataList.add(patientData);
            } else {
              print('Les données du rdv sont incomplètes  : $item');
            }
          }
          // Retourne la liste des données des patients
          return patientDataList;
        } catch (e) {
          // Gère les exceptions lors du décodage de la réponse JSON
          print('Erreur lors du décodage de la réponse JSON: $e');
          throw Exception('Erreur lors du décodage de la réponse JSON');
        }
      } else {
        // Gère les erreurs de requête HTTP
        print('Erreur de requête: ${response.reasonPhrase}');
        throw Exception('Erreur de requête: ${response.reasonPhrase}');
      }
    } catch (e) {
      SnackbarUtils.showMessage(context,'Error : $e',duration: Duration(seconds: 2));
      rethrow;
    }
  }

  // Récupère les informations d'un patient à partir de son identifiant.
  //
  // [idPatient]: L'identifiant du patient dont on souhaite récupérer les informations.
  //
  // Cette fonction envoie une requête POST pour récupérer les informations d'un patient
  // à partir de son identifiant. Elle utilise l'URL de l'API appropriée pour cette opération.
  // Si la requête réussit avec un code de statut 200, elle retourne les données du patient
  // sous forme de Map<String, dynamic>. Si la requête échoue ou si une exception est levée,
  // elle affiche un message d'erreur dans la console et relance l'exception.
  static Future<Map<String, dynamic>?> getInfoPatient(BuildContext context, int idPatient) async {
    // Définit l'URL pour la requête d'obtention des informations du patient
    final url = Uri.parse(urlApi + 'getInfoPatient/$idPatient');

    try {
      // Envoie une requête POST pour obtenir les informations du patient
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Vérifie si la requête a réussi (code de statut 200)
      if (response.statusCode == 200) {
        // Décodage de la réponse JSON en une Map<String, dynamic>
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        // Retourne les données du patient
        return jsonData;
      }
    } catch (e) {
      SnackbarUtils.showMessage(context,'Error  fetching patient info : $e',duration: Duration(seconds: 2));
    }
    // Si la requête échoue ou si une exception est levée, retourne null
    return null;
  }



}
