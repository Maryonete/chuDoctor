<<<<<<< HEAD
import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:doctor/utils/constants.dart';

class OpinionApi {

  // Retourne la liste des avis sur un patient
  static Future<List<Map<String, dynamic>>?> getOpinionsPatient(BuildContext context, Map<String, dynamic> opinionData) async {
=======
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:doctor/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:doctor/utils/utils.dart';
class OpinionApi {

  /**
   * Cette fonction effectue une requête HTTP POST pour récupérer la liste des avis sur un patient.
   * Elle prend en paramètres le contexte de l'application et les données de l'avis à envoyer.
   * La fonction retourne une liste de maps contenant les données des avis sur le patient.
   * Si la requête réussit, la liste des avis est retournée.
   * Si une erreur se produit lors de la récupération des avis, un message d'erreur est imprimé dans la console
   * et une exception est levée pour gérer l'erreur à un niveau supérieur.
   */

  static Future<List<Map<String, dynamic>>?> getOpinionsPatient(BuildContext context, Map<String, dynamic> opinionData) async {
    // Afficher un message dans la console
>>>>>>> d0db740 (add icon)
    print('[API] getOpinionsPatient');

    final url = Uri.parse(urlApi + 'getOpinionsPatient');

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

      // Effectuer une requête POST
      var response = await http.post(
>>>>>>> d0db740 (add icon)
        url,
        body: jsonEncode(opinionData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
<<<<<<< HEAD


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
=======
      // Vérifier si la réponse est OK
      if (response.statusCode == 200) {
        try {
          // Décoder la réponse JSON en une liste dynamique d'objets Dart
          List<dynamic> jsonData = jsonDecode(response.body);
          List<Map<String, dynamic>> opinionList = [];

          // Parcourir chaque élément de la liste
          for (var item in jsonData) {
            // Vérifier si toutes les clés nécessaires existent dans l'objet
            if (item.containsKey('id')) {
              // Extraire les données de l'avis de l'élément actuel
              Map<String, dynamic> opinionData = {
>>>>>>> d0db740 (add icon)
                'id': item['id'],
                'title': item['title'],
                'date': item['date'],
                'description': item['description'],
              };

<<<<<<< HEAD
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
=======
              // Ajouter les données de l'avis à la liste
              opinionList.add(opinionData);
            } else {
              // Afficher un message si les données de l'avis sont incomplètes
              print('Les données de l\'avis sont incomplets : $item');
            }
          }
          // Retourner la liste des avis sur le patient
          return opinionList;
        } catch (e) {
          // Gérer les erreurs lors du décodage de la réponse JSON
>>>>>>> d0db740 (add icon)
          print('Erreur lors du décodage de la réponse JSON: $e');
          throw Exception('Erreur lors du décodage de la réponse JSON');
        }
      } else {
        // Gérer les erreurs de réponse HTTP
        print('Erreur de requête: ${response.reasonPhrase}');
        throw Exception('Erreur de requête: ${response.reasonPhrase}');
      }
    } catch (e) {
<<<<<<< HEAD
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
=======
      SnackbarUtils.showMessage(context,'Error: $e',duration: Duration(seconds: 2));
      rethrow;
    }
  }

  // Ajoute un avis sur un patient.
  //
  // [context]: Le contexte de l'application.
  // [opinionData]: Les données de l'avis à ajouter, sous forme de Map<String, dynamic>.
  //
  // Cette fonction envoie une requête POST pour ajouter un avis sur un patient.
  // Si la requête réussit avec un code de statut 200, l'avis est ajouté avec succès.
  // Si la requête échoue avec un code de statut différent de 200, une exception est lancée.
  // En cas d'erreur lors de l'envoi de la requête, un message d'erreur est affiché.
  static Future<void> addOpinion(BuildContext context, Map<String, dynamic> opinionData) async {
    // Définit l'URL pour la requête d'ajout d'avis
    final url = Uri.parse(urlApi + 'addOpinion');

    try {
      // Envoie une requête POST pour ajouter l'avis
      var response = await http.post(
>>>>>>> d0db740 (add icon)
        url,
        body: jsonEncode(opinionData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
<<<<<<< HEAD
      print(jsonEncode(opinionData));

      if (response.statusCode != 200) {
        throw Exception('Failed to add avis - status : ' + response.statusCode.toString());
      }
      print('Avis ajouté avec succès');
      // Si la mise à jour s'est déroulée avec succès, retourner true
    } catch (e) {
      // En cas d'erreur, retourner false
      print('Error updating avis date: $e');
    }
  }

=======

      // Vérifie si la requête a réussi (code de statut 200)
      if (response.statusCode != 200) {
        // Lance une exception si l'ajout de l'avis a échoué
        throw Exception('Failed to add avis - status : ' + response.statusCode.toString());
      }
      SnackbarUtils.showMessage(context,'Avis ajouté avec succès',backgroundColor: Colors.green, duration: Duration(seconds: 2));

    } catch (e) {
       SnackbarUtils.showMessage(context,'Error adding avis: $e',duration: Duration(seconds: 2));
    }
  }


>>>>>>> d0db740 (add icon)
}