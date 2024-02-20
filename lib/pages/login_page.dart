import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:doctor/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  final void Function() onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController()..text = 'aa@fe.fr';
  TextEditingController passwordController = TextEditingController();

  login() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    var res = await Api().getAccessToken(data);
    var body = json.decode(res.body);

    if (body['code'] == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Identifiants incorrects',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );

    }

    if (body['token'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      widget.onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView( // Utilisation de SingleChildScrollView pour éviter le débordement
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/images/logo.svg",
                  height: 130,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(height: 10),
                const Text(
                  "SoigneMoi\nCHU",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Poppins',
                    color: Color(0xFF002E6E),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Espace médecins",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF002E6E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'exemple@chu.fr',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ ne peut être vide";
                      } else if (!EmailValidator.validate(value)) {
                        return 'Veuillez saisir un email correct';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: '******',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    controller: passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Ce champ ne peut être vide";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours ... ")),
                        );
                        FocusScope.of(context).requestFocus(FocusNode());
                        login(); // Passer le BuildContext
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: Text("S'identifier", style: TextStyle(fontSize: 20)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
