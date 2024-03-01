import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/pages/addPrescription.dart';
import 'package:doctor/service/patient_api.dart';

class PrescriptionPage extends StatefulWidget {
  final int? patientId; // ID du patient
  const PrescriptionPage({Key? key, this.patientId}) : super(key: key);

  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  List<Map<String, dynamic>>? prescriptions;
  Map<String, dynamic>? patientInfo;
  int? expandedIndex; // Ajouter une variable pour suivre l'index de l'accordéon actuellement ouvert

  @override
  void initState() {
    super.initState();
    fetchPrescriptions();
    fetchPatientInfo();
  }

  // Méthode pour fermer l'accordéon actuellement ouvert
  void closeAccordion() {
    setState(() {
      expandedIndex = null;
    });
  }

  Future<void> fetchPatientInfo() async {
    if (widget.patientId != null) {
      try {
        Map<String, dynamic>? result = await PatientApi.fetchPatientInfo(widget.patientId!);
        setState(() {
          patientInfo = result;
        });
      } catch (e) {
        print('Error fetching patient info: $e');
      }
    }
  }

  Future<void> fetchPrescriptions() async {
    try {
      List<Map<String, dynamic>>? result =
      await Api().getPrescriptionsPatient(context, widget.patientId);
      setState(() {
        prescriptions = result;
      });
    } catch (e) {
      print('Error fetching prescriptions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr', ''),
      ],
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                patientInfo != null
                    ? '${patientInfo!["firstName"]} ${patientInfo!["lastName"]}'
                    : 'Prescriptions du patient',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                logout();
              },
            ),
          ],
        ),
        body: prescriptions != null
            ? ListView.builder(
          itemCount: prescriptions!.length,
          itemBuilder: (context, index) {
            var medications = prescriptions![index]['medications'];
            var medicationsList = <Widget>[]; // Initialiser la liste de widgets

            if (medications != null) {
              medicationsList = medications.map<Widget>((med) {
                return ListTile(
                  title: Text(med['drug']),
                  subtitle: Text(med['dosage']),
                );
              }).toList();
            }

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prescription ${prescriptions![index]['id']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          closeAccordion(); // Fermer l'accordéon actuellement ouvert
                          _showEditPrescriptionDialog(context, prescriptions![index]['id'],
                              prescriptions![index]['end']);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text('Début: ${_formatDate(prescriptions![index]['start'])}'),
                    subtitle: Text('Fin: ${_formatDate(prescriptions![index]['end'])}'),
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.medical_services),
                    title: Text('Médicaments et Dosages'),
                    children: medicationsList,
                    onExpansionChanged: (expanded) {
                      if (expanded) {
                        // Mettre à jour l'index de l'accordéon actuellement ouvert
                        setState(() {
                          expandedIndex = index;
                        });
                      } else {
                        // Fermer l'accordéon lorsqu'il est rétracté
                        closeAccordion();
                      }
                    },
                    initiallyExpanded: expandedIndex == index, // Ouvrir l'accordéon si l'index correspond à l'index de l'accordéon actuellement ouvert
                  ),
                ],
              ),
            );
          },
        )
            : Center(
          child: CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPrescriptionPage(patientId: widget.patientId)),
            );
          },
          child: Icon(Icons.add),
        ),

      ),
    );
  }

  void logout() {
    // Implémentez la logique de déconnexion ici
    print('Logout');
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Future<void> _showEditPrescriptionDialog(BuildContext context, int prescriptionId, String currentEndDate) async {
    DateTime? selectedDate = DateTime.parse(currentEndDate); // Initialisez la date sélectionnée à la date actuelle

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: Locale('fr'), // Définissez la localisation sur français
    );

    if (newDate != null) {
      selectedDate = newDate;
      // Mettez à jour la prescription avec la nouvelle date de fin
      try {
        // Appelez la fonction pour mettre à jour la prescription avec la nouvelle date de fin
        await Api().setPrescriptionDateEnd(prescriptionId, selectedDate);
        // Rafraîchissez la liste des prescriptions
        fetchPrescriptions();
      } catch (e) {
        print('Error updating prescription: $e');
        // Gérer l'erreur
      }
    }
  }
}

void main() {
  runApp(PrescriptionPage());
}
