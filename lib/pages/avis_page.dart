import 'package:flutter/material.dart';


class AvisPage extends StatefulWidget {
  const AvisPage({super.key});

  @override
  State<AvisPage> createState() => _AvisPageState();
}

class _AvisPageState extends State<AvisPage> {

  // conserve les données du formulaire
  final _formKey = GlobalKey<FormState>();

  // champs de la pages
  final libelleController = TextEditingController();
  final descriptionController = TextEditingController();

  // libere memoire
  @override
  void dispose() {
    super.dispose();
    libelleController.dispose();
    descriptionController.dispose();
  }

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
                      labelText: 'votre avis sur le patient',
                      hintText: '......',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ ne peut être vide";
                    }
                    return null;
                  },
                  controller: libelleController,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom:20),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'description',
                      hintText: '......',
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Ce champ ne peut être vide";
                    }
                    return null;
                  },
                  controller: descriptionController,
                ),
              ),
              SizedBox(
                width: double.infinity,
                height:50,

                child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        final libelle = libelleController.text;
                        final description = descriptionController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Envoi en cours ... "))
                        );
                        // ferme le clavier
                        FocusScope.of(context).requestFocus(FocusNode());

                        print("Ajout de l'avis $libelle avec la description $description");

                      }
                    },
                    child: Text("Enregistrer")
                ),
              )
            ],
          )
      ),
    );
  }
}

