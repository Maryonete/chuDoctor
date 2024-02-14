import 'package:doctor/pages/avis_page.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:doctor/pages/login_page.dart';
import 'package:doctor/pages/patients_list_page.dart';
import 'package:doctor/pages/prescription_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // stocke num de la page ou on se trouve
  int _currentIndex = 0;

  // maj num de la page
  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue, // Couleur principale de l'application
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Couleur principale
        ).copyWith(
          secondary: Colors.orange, // Couleur d'accentuation
        ),
        scaffoldBackgroundColor: Colors.grey[200], // Couleur de fond pour tous les Scaffold
        fontFamily: 'Poppins', // Police par défaut de l'application
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Style de texte par défaut
          bodyLarge: TextStyle(fontSize: 16), // Style de texte pour le corps
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.blue, // Couleur de la barre d'applications
          elevation: 0, // Élévation de la barre d'applications

          iconTheme: IconThemeData(color: Colors.white), // Couleur des icônes dans la barre d'applications
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title:<Widget>[
            Text("Accueil",style: TextStyle(color: Colors.white)),
            Text("Visites du jour",style: TextStyle(color: Colors.white)),
            Text("Prescriptions",style: TextStyle(color: Colors.white)),
            Text("Avis",style: TextStyle(color: Colors.white)),
            ][_currentIndex]
        ),
        body: [
          HomePage(),
          PatientsListPage(),
          PrescriptionPage(),
          AvisPage(),
        ][_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setCurrentIndex(index),
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          iconSize: 32,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'Visites'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital),
                label: 'Prescription'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Avis'
            )
          ],
        ),

      ),
    );
  }
}




