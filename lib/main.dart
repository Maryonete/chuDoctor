import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:doctor/pages/home.dart';
import 'package:doctor/pages/patients_list.dart';
import 'package:doctor/pages/prescription.dart';
import 'package:doctor/pages/avis.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void login() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoigneMoi Mobile',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            ['Accueil', 'Visites du jour', 'Prescriptions', 'Avis'][_currentIndex],
            style: const TextStyle(color: Colors.white),

          ),
          backgroundColor: Colors.blue,
          actions: _isLoggedIn
              ? [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
          ]
              : null,
        ),
        body: _isLoggedIn
            ? IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(), // Index 0
            PatientsListPage(), // Index 1
            PrescriptionPage(patientId: null), // Index 2
            AvisPage(), // Index 3
          ],
        )
            : LoginPage(onLogin: login),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: setCurrentIndex,
          backgroundColor: Colors.blue, // Couleur de fond de l'AppBar
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
