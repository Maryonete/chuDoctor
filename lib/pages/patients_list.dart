import 'package:flutter/material.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/pages/avis.dart';
import 'package:doctor/pages/prescription.dart';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({Key? key}) : super(key: key);

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  List<Map<String, dynamic>>? patients;

  @override
  void initState() {
    super.initState();
    fetchData();
    print('PatientsListPage');
  }

  Future<void> fetchData() async {
    try {
      Api api = Api();
      List<Map<String, dynamic>>? patientsData = await api.getPatients(context);
      setState(() {
        patients = patientsData;
      });
    } catch (e) {
      // Gérer les erreurs
      print('Erreur lors de la récupération des patients: $e');
    }
  }

  void _showDescriptionDialog(BuildContext context, String description, String reason) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            reason,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(description + ' ' + reason),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('PatientsListPage');
    return Scaffold(

      body: Center(
        child: patients != null && patients!.isNotEmpty
            ? ListView.builder(
          itemCount: patients!.length,
          itemBuilder: (context, index) {
            final event = patients![index];
            final title = event['title'];
            final description = event['description'];
            String speciality = event['speciality'];
            final start = event['start'];
            final end = event['end'];

            String dateString = event['start'];
            DateTime dateTime = DateTime.parse(dateString);
            final heure = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
            return Card(
              child: ListTile(
                title: Text(
                  "[$heure] $title",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      speciality,
                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.assignment),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PrescriptionPage(patientId: event['patient_id'])),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AvisPage()),
                                );
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () {
                            _showDescriptionDialog(context, description, event['reason']);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : const Text("Vous n'avez pas de rendez-vous aujourd'hui"),
      ),
    );
  }
}
