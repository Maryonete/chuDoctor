import 'package:doctor/pages/addOpinion.dart';
import 'package:flutter/material.dart';
import 'package:doctor/service/opinion_api.dart';
<<<<<<< HEAD
import 'package:doctor/service/patient_api.dart';
import 'package:doctor/utils/utils.dart';
import 'package:doctor/entities/opinion.dart';
=======
import 'package:doctor/utils/utils.dart';
import 'package:doctor/entities/opinion.dart';
import 'package:doctor/utils/constants.dart';
>>>>>>> d0db740 (add icon)

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
<<<<<<< HEAD
        Map<String, dynamic>? result = await PatientApi.fetchPatientInfo(widget.patientId!);
=======

        Map<String, dynamic>? result = await AppUsersUtils.fetchPatientInfo(context,widget.patientId!);


>>>>>>> d0db740 (add icon)
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
<<<<<<< HEAD
        'medecin_id': await AuthUtils().checkMedecinID(),
=======
        'medecin_id': await AppUsersUtils().checkMedecinID(),
>>>>>>> d0db740 (add icon)
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
<<<<<<< HEAD
        backgroundColor: Colors.blue,
=======
        backgroundColor: AppColors.myColor,
>>>>>>> d0db740 (add icon)
        title: Row(
          children: [
            Expanded(
              child: Text(
                patientInfo != null
                    ? '${patientInfo!["firstName"]} ${patientInfo!["lastName"]}'
                    : 'Avis sur le patient',
<<<<<<< HEAD
                style: const TextStyle(color: Colors.white),
=======
                style: const TextStyle(color: Colors.white, fontFamily: 'Georgia'),
>>>>>>> d0db740 (add icon)
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
<<<<<<< HEAD
=======
        iconTheme: IconThemeData(color: Colors.white),
>>>>>>> d0db740 (add icon)
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
<<<<<<< HEAD
        backgroundColor: Colors.blue,
=======
        backgroundColor: AppColors.myColor,
>>>>>>> d0db740 (add icon)
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
          Opinion opinionObject = Opinion.fromJson(opinion); // Conversion de la Map en un objet Opinion

          return Card(
            child: ListTile(
              title: Text(opinionObject.title),
              subtitle: Text(AppDateUtils().formatDate(opinionObject.date.toString())),
              trailing: IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  _showDescriptionDialog(opinionObject.title, opinionObject.description);
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
