import 'package:flutter/material.dart';
import 'package:doctor/pages/login_page.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/patients_list_page.dart';
import 'package:doctor/pages/prescription_page.dart';
import 'package:doctor/pages/avis_page.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Stocke le numéro de la page où on se trouve
  int _currentIndex = 0;

  // Variable pour vérifier si l'utilisateur est connecté
  bool _isLoggedIn = false;

  // Fonction pour changer le numéro de la page
  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Fonction pour se connecter
  void login() {
    // Ici, vous pouvez implémenter la logique de connexion
    // Une fois la connexion réussie, mettez _isLoggedIn à true
    setState(() {
      _isLoggedIn = true;
    });
  }

  // Fonction pour se déconnecter
  void logout() {
    // Implémentez ici la logique de déconnexion
    // Par exemple, supprimez le jeton d'authentification des préférences partagées
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Vérifie si l'utilisateur est connecté
    if (!_isLoggedIn) {
      // Si l'utilisateur n'est pas connecté, affichez la page de connexion
      return MaterialApp(
        title: 'SoigneMoi Mobile',
        debugShowCheckedModeBanner: false,
        home: LoginPage(
          onLogin: login,
        ),
      );
    } else {
      // Si l'utilisateur est connecté, affichez le menu et les autres pages
      return MaterialApp(
        title: 'SoigneMoi Mobile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: Colors.orange,
          ),
          scaffoldBackgroundColor: Colors.grey[200],
          fontFamily: 'Poppins',
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16),
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.blue,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              ['Accueil', 'Visites du jour', 'Prescriptions', 'Avis'][_currentIndex],
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: logout,
              ),
            ],
          ),
          body: [
            HomePage(),
            PatientsListPage(),
            PrescriptionPage(),
            AvisPage(),
          ][_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: setCurrentIndex,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            iconSize: 32,
            elevation: 10,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Visites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital),
                label: 'Prescription',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Avis',
              ),
            ],
          ),
        ),
      );
    }
  }
}
