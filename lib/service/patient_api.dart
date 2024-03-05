import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:doctor/utils/constants.dart';


class PatientApi {
  static Future<Map<String, dynamic>?> fetchPatientInfo(int patientId) async {
    try {
      Map<String, dynamic>? result = await getInfoPatient(patientId);
      return result;
    } catch (e) {
      print('Error fetching patient info: $e');
      return null;
    }
  }
  // info patient
  static Future<Map<String, dynamic>?> getInfoPatient(int idPatient) async {
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


}
