import 'package:flutter/material.dart';
import 'package:doctor/service/opinion_api.dart';
import 'package:intl/intl.dart';
import 'package:doctor/service/patient_api.dart';
import 'package:doctor/utils/utils.dart';
import 'package:doctor/pages/opinion.dart';


class AddOpinionPage extends StatefulWidget {
  final int? patientId;

  const AddOpinionPage({Key? key, this.patientId}) : super(key: key);

  @override
  _AddOpinionPageState createState() => _AddOpinionPageState();
}

class _AddOpinionPageState extends State<AddOpinionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Map<String, dynamic>? patientInfo;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // Formater la date du jour
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          patientInfo != null
              ? 'Avis $currentDate\n${patientInfo!["firstName"]} ${patientInfo!["lastName"]}'
              : 'Avis patient',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthUtils.logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Votre avis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                  borderSide: BorderSide(color: Colors.blue), // Couleur de la bordure
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                  borderSide: BorderSide(color: Colors.blue, width: 2.0), // Couleur de la bordure lorsque le champ est en focus
                ),),

            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                  borderSide: BorderSide(color: Colors.blue), // Couleur de la bordure
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Bordure arrondie
                  borderSide: BorderSide(color: Colors.blue, width: 2.0), // Couleur de la bordure lorsque le champ est en focus
                ),),
              maxLines: 5,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitOpinion,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: _isLoading ? CircularProgressIndicator() : Text('Ajouter', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitOpinion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer la date du jour
      final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String? medecinId = await AuthUtils().checkMedecinID();

      // Normaliser les données du formulaire
      final normalizedTitle = AppDateUtils().normalizeString(_titleController.text);
      final normalizedDescription = AppDateUtils().normalizeString(_descriptionController.text);
      if (normalizedTitle.isEmpty || normalizedDescription.isEmpty) {
        SnackbarUtils.showMessage(context, 'Le titre et la description sont obligatoires.');
        setState(() {
          _isLoading = false;
        });
        return;
      }
      // Créer un objet Opinion à partir des données du formulaire
      final opinion = {
        'title': normalizedTitle,
        'description': normalizedDescription,
        'patient_id': widget.patientId,
        'medecin_id': medecinId,
        'date': currentDate,
      };

      // Appeler la méthode pour ajouter l'avis
      await OpinionApi.addOpinion(context, opinion);
      // Naviguer vers PrescriptionPage après l'enregistrement réussi avec widget.patientId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OpinionPage(patientId: widget.patientId),
        ),
      );

    } catch (e) {
      // Gérer les erreurs en cas d'échec de l'ajout de l'avis
      print('Error adding opinion: $e');
      // Afficher éventuellement un message d'erreur à l'utilisateur
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
