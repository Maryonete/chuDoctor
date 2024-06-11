import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:doctor/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? userId = localStorage.getString('user_id');

    if (userId != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  void redirectToLogin() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed('/login');
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
      title: 'SoigneMoi',
      debugShowCheckedModeBanner: false,
      // calendrier en anglais

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      initialRoute: _isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
