import 'package:chudoctor/utils/utils.dart';
import 'package:chudoctor/service/api.dart';
import 'package:chudoctor/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(); //..text = 'medecin@studi.fr';
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  bool rememberMe = false;

  login(bool rememberMe) async {
    var data = {
      'username': emailController.text,
      'password': passwordController.text,
    };

    var body = await Api().login(data, context);

    if (body['token'] != null) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);

      if (rememberMe) { // Sauvegarder les informations de connexion si "Se souvenir de moi" est coché
        await AuthUtils.saveCredentials(emailController.text, passwordController.text);
      } else {
        localStorage.setBool('rememberMe', false);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }


  @override
  void initState() {
    super.initState();
    checkRememberMe();
  }

  checkRememberMe() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = localStorage.getBool('rememberMe') ?? false;
      if (rememberMe) {
        emailController.text = localStorage.getString('email') ?? '';
        passwordController.text = localStorage.getString('password') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 30,bottom: 10.0),
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
                    fontFamily: 'Georgia',
                    color: Color(0xFF124660),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Espace médecins",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Georgia',
                    color: Color(0xFF124660),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 20, left:10, right:10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF124660),
                      ),
                      hintText: 'exemple@chu.fr',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder( // Style de la bordure lorsque le champ est sélectionné
                        borderSide: BorderSide(color: Color(0xFF124660)), // Couleur de la bordure en bleu
                      ),
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
                  margin: const EdgeInsets.only(bottom: 10, left:10, right:10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      hintText: '******',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder( // Style de la bordure lorsque le champ est sélectionné
                        borderSide: BorderSide(color: Color(0xFF124660)), // Couleur de la bordure en bleu
                      ),
                      labelStyle: TextStyle(fontSize: 18, color: Color(0xFF124660)),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    controller: passwordController,
                    obscureText: isObscure,
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
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                      activeColor: Color(0xFF124660),
                    ),

                    Text("Se souvenir de moi"),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          SnackbarUtils.showMessage(context,'Envoi en cours ... ', backgroundColor: Colors.black);
                          FocusScope.of(context).requestFocus(FocusNode());
                          login(rememberMe);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF124660),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "S'identifier",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
