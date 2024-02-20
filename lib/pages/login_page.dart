import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // conserve les données du formulaire
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController()..text= 'aa@fe.fr';
  TextEditingController passwordController = TextEditingController();


  login() async {
    var data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
print(data);
    var res = await Api().getAccessToken(data);


    var body = json.decode(res.body);

    if (body['code'] == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identifiants incorrects')));
    }
    print("Body : token:");
    print(body['token']);
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom:20),
                  child: TextFormField(

                    decoration: const InputDecoration(
                      labelText: 'votre email',
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
                  margin: EdgeInsets.only(bottom:20),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'votre mot de passe',
                      hintText: '******',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontSize: 18),
                    ),
                    controller: passwordController,
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
                  height:50,

                  child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate() ?? false ){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Envoi en cours ... "))
                          );
                          // ferme le clavier
                          FocusScope.of(context).requestFocus(FocusNode());
                          login();
                        }
                      },

                      child: Text("Connexion")
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}

