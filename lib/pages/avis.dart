import 'package:flutter/material.dart';

class AvisPage extends StatefulWidget {
  const AvisPage({Key? key}) : super(key: key);

  @override
  State<AvisPage> createState() => _AvisPageState();
}

class _AvisPageState extends State<AvisPage> {
  final _formKey = GlobalKey<FormState>();

  final libelleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    libelleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avis sur le patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Votre avis sur le patient',
                  hintText: '...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ce champ ne peut être vide";
                  }
                  return null;
                },
                controller: libelleController,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: '...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ce champ ne peut être vide";
                  }
                  return null;
                },
                controller: descriptionController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final libelle = libelleController.text;
                    final description = descriptionController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoi en cours ... ")),
                    );
                    FocusScope.of(context).requestFocus(FocusNode());
                    print("Ajout de l'avis $libelle avec la description $description");
                  }
                },
                child: const Text("Enregistrer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
