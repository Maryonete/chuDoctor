import 'package:doctor/utils/utils.dart';
import 'package:doctor/utils/constants.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/pages/home.dart';
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

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 25,bottom: 10),
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
                    color: AppColors.myColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Espace médecins",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Georgia',
                    color: AppColors.myColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'exemple@chu.fr',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 18, color: AppColors.myColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.myColor),
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
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: '******',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 18, color: AppColors.myColor),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.myColor),
                        ),
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
                          passwordController.clear();
                        });
                      },
                    ),
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
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return AppColors.myColor; // Couleur de fond de la case cochée
                          }
                          return Colors.grey; // Couleur de fond de la case non cochée
                        },
                      ),
                    ),
                    Text("Se souvenir de moi"),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0), // Padding de 10 pixels à droite et à gauche
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          SnackbarUtils.showMessage(context,'Envoi en cours ... ', backgroundColor: Colors.black);
                          FocusScope.of(context).requestFocus(FocusNode());
                          login(rememberMe);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.myColor,
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
