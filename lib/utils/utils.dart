import 'package:flutter/material.dart';

class AuthUtils {
  static void logout(BuildContext context) {
    // Implémentez ici la logique de déconnexion
    print('Logout');
    // Par exemple, vous pouvez naviguer vers la page de connexion
    Navigator.of(context).pushReplacementNamed('/login');
  }
}
