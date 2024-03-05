import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importer la bibliothèque shared_preferences
import 'package:intl/intl.dart';

class AuthUtils {

  // déconnexion Appli mobile
  static void logout(BuildContext context) async {
    // Implémentez ici la logique de déconnexion
    print('Logout');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Par exemple, vous pouvez naviguer vers la page de connexion
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
  // retourne l'ID du medecin connecté
    Future<String?> checkMedecinID() async {
      print('[utils checkMedecinID]');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      return localStorage.getString('user_id');
    }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);

    return DateFormat('dd-MM-yyyy').format(dateTime);

  }
}