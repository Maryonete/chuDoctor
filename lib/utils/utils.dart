import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importer la bibliothèque shared_preferences


class AuthUtils {
  static void logout(BuildContext context) async {
    // Implémentez ici la logique de déconnexion
    print('Logout');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Par exemple, vous pouvez naviguer vers la page de connexion
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }



Future<String?> checkMedecinID() async {

  SharedPreferences localStorage = await SharedPreferences.getInstance();
  return localStorage.getString('user_id');

  }
}