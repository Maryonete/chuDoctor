import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // conserve les données du formulaire
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom:20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'votre email',
                    hintText: 'exemple@chu.fr',
                    border: OutlineInputBorder()
                  ),
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
                      if(_formKey.currentState!.validate()){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours ... "))
                        );
                        // ferme le clavier
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                    child: Text("Envoyer")
                ),
              )
            ],
          )
      ),
    );
  }
}

