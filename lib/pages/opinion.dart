import 'package:doctor/pages/addOpinion.dart';
import 'package:flutter/material.dart';
import 'package:doctor/service/opinion.dart';
import 'package:doctor/entity/opinion.dart';
import 'package:doctor/service/patient_api.dart';
import 'package:doctor/utils/utils.dart';

class OpinionPage extends StatefulWidget {
  final int? patientId;

  const OpinionPage({Key? key, this.patientId}) : super(key: key);

  @override
  _OpinionPageState createState() => _OpinionPageState();
}

class _OpinionPageState extends State<OpinionPage> {
  List<Map<String, dynamic>>? opinions ;
  Map<String, dynamic>? patientInfo;

  @override
  void initState() {
    super.initState();
    fetchOpinions();
    fetchPatientInfo();
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

  Future<void> fetchOpinions() async {
    try {
      Map<String, dynamic> opinionData = {
        'patient_id': widget.patientId,
        'medecin_id': await AuthUtils().checkMedecinID(),
      };
      List<Map<String, dynamic>>? result = await OpinionApi.getOpinionsPatient(context, opinionData);
      result!.sort((a, b) => b['date'].compareTo(a['date'])); // Tri des opinions par date du plus récent au plus ancien

      setState(() {
        opinions = result;
      });
    } catch (e) {
      print('Error fetching opinions: $e');
    }
  }

  void _showDescriptionDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
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
            Expanded(
              child: Text(
                patientInfo != null
                    ? '${patientInfo!["firstName"]} ${patientInfo!["lastName"]}'
                    : 'Avis sur le patient',
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthUtils.logout(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white, // Couleur de l'icône
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOpinionPage(patientId: widget.patientId)),
          );
        },
        child: Icon(Icons.add),
      ),
      body: opinions != null
          ? ListView.builder(
        itemCount: opinions!.length,
        itemBuilder: (context, index) {
          var opinion = opinions![index];
          return Card(
            child: ListTile(
              title: Text(opinion['title']),
              subtitle: Text(AuthUtils().formatDate(opinion['date'])),
              trailing: IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  _showDescriptionDialog(opinion['title'], opinion['description']);
                },
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
