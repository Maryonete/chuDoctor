import 'dart:convert';
import 'package:doctor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:doctor/service/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController()..text = 'medecin@studi.fr';
  TextEditingController passwordController = TextEditingController();

  login() async {
    var data = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    var body = await Api().login(data, context);

    if (body['code'] == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView( // Utilisation de SingleChildScrollView pour éviter le débordement
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                const Text(
                  "Hospital SoigneMoi",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 38,
                    fontFamily: 'Poppins',
                    color: Color(0xFF002E6E),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Espace médecins",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF002E6E),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
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
                  margin: const EdgeInsets.only(bottom: 10),
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
                    onTap: () {
                      setState(() {
                        // Vider le champ de texte du mot de passe
                        passwordController.clear();
                      });
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
                        login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("S'identifier", style: TextStyle(fontSize: 20)),
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
