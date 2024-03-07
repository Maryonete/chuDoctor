import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importer la bibliothèque shared_preferences
import 'package:intl/intl.dart';

class AuthUtils {

  // Clés pour les préférences partagées
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  // Sauvegarde les informations d'identification de l'utilisateur
  static Future<void> saveCredentials(String email, String password) async {
    print('[saveCredentials]');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_emailKey, email);
    prefs.setString(_passwordKey, password);
    prefs.setBool('rememberMe', true);
  }

  // Récupère les informations d'identification de l'utilisateur
  static Future<Map<String, String?>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_emailKey);
    String? password = prefs.getString(_passwordKey);
    return {'email': email, 'password': password};
  }

  // Efface les informations d'identification de l'utilisateur
  static Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("clearCredential: " + prefs.get('rememberMe').toString());
    if(prefs.get('rememberMe') == false) {
      await prefs.remove(_emailKey);
      await prefs.remove(_passwordKey);
    }
  }

  // déconnexion Appli mobile
  static void logout(BuildContext context) async {
    print('Logout');
    await clearCredentials();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
  // retourne l'ID du medecin connecté
    Future<String?> checkMedecinID() async {
      print('[utils checkMedecinID]');
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      return localStorage.getString('user_id');
    }
}

class AppDateUtils  {
  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);

    return DateFormat('dd-MM-yyyy').format(dateTime);

  }
}


class SnackbarUtils {
  static void showMessage(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 4),
        Color backgroundColor = Colors.red, // Par défaut, la couleur du message est rouge
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
      ),
    );
  }
}