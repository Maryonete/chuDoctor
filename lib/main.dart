import 'package:flutter/material.dart';
import 'package:doctor/pages/login.dart';
import 'package:doctor/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
<<<<<<< HEAD
  runApp(MyApp());
=======
  runApp(const MyApp());
>>>>>>> d0db740 (add icon)
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

<<<<<<< HEAD
=======

>>>>>>> d0db740 (add icon)
class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    print('appel de checkLoginStatus');
=======
>>>>>>> d0db740 (add icon)
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
<<<<<<< HEAD
    WidgetsBinding.instance?.addPostFrameCallback((_) {
=======
    WidgetsBinding.instance.addPostFrameCallback((_) {
>>>>>>> d0db740 (add icon)
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
<<<<<<< HEAD
      localizationsDelegates: [
=======
      localizationsDelegates: const [
>>>>>>> d0db740 (add icon)
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
<<<<<<< HEAD
      supportedLocales: [
        const Locale('fr', 'FR'),
      ],
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
=======
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      initialRoute: _isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
>>>>>>> d0db740 (add icon)
        '/home': (context) => const HomePage(),
      },
    );
  }
}
