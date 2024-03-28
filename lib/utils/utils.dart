import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:doctor/service/patient_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


/// ----------------------------------------------------------------------------
///
///
///
///
/// ----------------------------------------------------------------------------

class AuthUtils {

  // Clés pour les préférences partagées
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';

  // Sauvegarde les informations d'identification de l'utilisateur
  static Future<void> saveCredentials(String email, String password) async {
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
    if (prefs.get('rememberMe') == false) {
      await prefs.remove(_emailKey);
      await prefs.remove(_passwordKey);
    }
  }

// Déconnexion de l'application mobile
  static void logout(BuildContext context) async {
    await clearCredentials();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}


/// ----------------------------------------------------------------------------
///
///
///
///
/// ----------------------------------------------------------------------------
class AppUsersUtils  {

  // retourne l'ID du medecin connecté
    Future<String?> checkMedecinID() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      return localStorage.getString('user_id');
    }

  /// Récupère les informations d'un patient à partir de son identifiant.
  ///
  /// [patientId]: L'identifiant du patient dont on souhaite récupérer les informations.
  ///
  /// Cette fonction envoie une requête à une fonction `getInfoPatient` pour obtenir
  /// les informations du patient correspondant à l'identifiant spécifié.
  /// Si la requête réussit, les informations du patient sont retournées.
  /// Si une erreur se produit lors de la récupération des informations du patient,
  /// un message d'erreur est imprimé dans la console et la fonction retourne `null`.
  static Future<Map<String, dynamic>?> fetchPatientInfo(context, int patientId) async {
    try {
      // Appeler la fonction getInfoPatient pour obtenir les informations du patient
      Map<String, dynamic>? result = await PatientApi.getInfoPatient(context, patientId);

      return result;
    } catch (e) {
      // Gérer les erreurs lors de la récupération des informations du patient
      //print('Error fetching patient info: $e');
      return null;
    }
  }
}
/// ----------------------------------------------------------------------------
///
///
///
///
/// ----------------------------------------------------------------------------

class AppDateUtils  {
  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);

    return DateFormat('dd-MM-yyyy').format(dateTime);

  }
}

/// ----------------------------------------------------------------------------
///
///
///
///
/// ----------------------------------------------------------------------------

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