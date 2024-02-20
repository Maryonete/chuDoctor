import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  token() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
     var token = localStorage.getString('token');

    return '?token=$token';
  }
// var fullUrl = 'https://192.168.1.56:8000/73/medecins';


  Future<http.Response> getAccessToken(data) async {
    try {
      var urlApi = 'https://192.168.1.56:8000/api/login_check' + await token();
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      var response = await http.post(
        Uri.parse(urlApi),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print("Response status : ${response.statusCode}");

      return response; // Retourne la réponse de la requête HTTP

    } catch (e) {
      print(e.toString());
      throw e; // Lance à nouveau l'exception pour que l'appelant puisse la gérer
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