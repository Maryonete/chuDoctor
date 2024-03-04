import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:doctor/pages/home.dart';
import 'package:doctor/pages/patients_list.dart';
import 'package:doctor/pages/prescription.dart';
import 'package:doctor/pages/avis.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      debugShowCheckedModeBanner: false, //masquer la bannière de débogage lors de l'exécution de l'application en mode de production
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', 'FR'),
      ],
      home: _isLoggedIn
          ? Scaffold(
        appBar: AppBar(
          title: Text(
            ['Accueil', 'Visites du jour', 'Prescriptions', 'Avis']
            [_currentIndex],
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          actions: _isLoggedIn
              ? [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white,),
              onPressed: logout,
            ),
          ]
              : null,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(), // Index 0
            PatientsListPage(), // Index 1
            PrescriptionPage(patientId: null), // Index 2
            AvisPage(), // Index 3
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: setCurrentIndex,
          backgroundColor: Colors.blue,
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
      )
          : LoginPage(onLogin: login),
    );
  }
}
