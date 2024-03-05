import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/pages/opinion.dart';
import 'package:doctor/pages/prescription.dart';
import 'package:doctor/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? patients;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      Api api = Api();
      List<Map<String, dynamic>>? patientsData = await api.getPatients(context);
      setState(() {
        patients = patientsData;
      });
    } catch (e) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "Espace médecins",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthUtils.logout(context);
            }, // Ajoutez votre fonction de déconnexion ici
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vistes du jour",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            patients != null && patients!.isNotEmpty
                ? Expanded(
              child: ListView.builder(
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
                                        MaterialPageRoute(builder: (context) => OpinionPage(patientId: event['patient_id'])),
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
              ),
            )
                : const Text("Vous n'avez pas de rendez-vous aujourd'hui"),
          ],
        ),
      ),
    );
  }
}
