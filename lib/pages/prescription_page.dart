import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPage();

}
class _PrescriptionPage extends State<PrescriptionPage> {

// conserve les données du formulaire
  final _formKey = GlobalKey<FormState>();

  // champs de la pages
  final libelleController = TextEditingController();
  String selectedMedecine  = '';
  DateTime selectedStart = DateTime.now();
  DateTime selectedEnd = DateTime.now().add(const Duration(days: 1));
  // libere memoire
  @override
  void dispose() {
    super.dispose();
    libelleController.dispose();

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
                      labelText: 'prescription',
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
              const SizedBox(height: 16),
              DateTimeField(
                decoration: const InputDecoration(
                    labelText: 'Date de début',
                    helperText: 'JJ/MM/AAAA',
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                ),
                value: selectedStart,
                dateFormat: DateFormat('dd/MM/y'),
                mode: DateTimeFieldPickerMode.date,
                initialPickerDateTime: DateTime.now(),
                firstDate: DateTime.now(),

                onChanged: (DateTime? value) {
                  setState(() {
                    selectedStart = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DateTimeField(
                decoration: const InputDecoration(
                  labelText: 'Date de fin',
                  helperText: 'JJ/MM/AAAA',
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                ),
                value: selectedEnd,
                mode: DateTimeFieldPickerMode.date,
                initialPickerDateTime: DateTime.now(),
                firstDate: DateTime.now(),

                onChanged: (DateTime? value) {
                  setState(() {
                    selectedEnd = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                margin:EdgeInsets.only(bottom: 10),
                child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(value: '', child: Text("Veuillez-selectionner une valeur")),
                    DropdownMenuItem(value: 'doliprane', child: Text("Doliprane")),
                    DropdownMenuItem(value: 'peniciline', child: Text("Péniciline")),
                    DropdownMenuItem(value: 'vitamine', child: Text("Vitamines")),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: '',
                  onChanged: (value){
                    setState(() {
                      selectedMedecine = value!;
                    });
                  },
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
                        final libelle = libelleController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Envoi en cours ... "))
                        );
                        // ferme le clavier
                        FocusScope.of(context).requestFocus(FocusNode());

                        print("Ajout prescription $libelle avec medicament: $selectedMedecine - deb: $selectedStart - fin: $selectedEnd");

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

