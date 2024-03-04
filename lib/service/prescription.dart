import 'dart:io'; // Ajout de l'importation pour X509Certificate
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:doctor/utils/constants.dart';


class PrescriptionApi {

  // création  d'une prescription
  Future<void> addPrescription(Map<String, dynamic> prescriptionData) async {
    print("[API addPrescription]");
    final url = Uri.parse(urlApi + 'addPrescription');
    print(url);
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