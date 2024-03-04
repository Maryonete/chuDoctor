import 'package:flutter/material.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/service/patient_api.dart';
import 'package:doctor/utils/utils.dart';
import 'package:intl/intl.dart'; // Importer le package intl

class AddPrescriptionPage extends StatefulWidget {
  final int? patientId; // ID du patient
  const AddPrescriptionPage({Key? key, this.patientId}) : super(key: key);

  @override
  _AddPrescriptionPageState createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _medicationController;
  late TextEditingController _dosageController;
  Map<String, dynamic>? patientInfo;
  bool _startDateError = false; // Déclaration de l'indicateur d'erreur de la date de début
  bool _endDateError = false; // Déclaration de l'indicateur d'erreur de la date de fin

  @override
  void initState() {
    super.initState();
    fetchPatientInfo();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _medicationController = TextEditingController();
    _dosageController = TextEditingController();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _medicationController.dispose();
    _dosageController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Text(
              patientInfo != null
                  ? 'Nouvelle prescription\n${patientInfo!["firstName"]} ${patientInfo!["lastName"]}'
                  : 'Prescriptions du patient',
              style: const TextStyle(color: Colors.white),
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _startDateController,
              readOnly: true,
              onTap: () {
                _selectDate(context, _startDateController);
              },
              decoration: InputDecoration(
                labelText: 'Date de début',
                suffixIcon: Icon(Icons.calendar_today),
                errorText: _startDateError ? 'Date invalide' : null, // Afficher un texte d'erreur si _startDateError est vrai
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _endDateController,
              readOnly: true,
              onTap: () {
                _selectDate(context, _endDateController);
              },
              decoration: InputDecoration(
                labelText: 'Date de fin',
                suffixIcon: Icon(Icons.calendar_today),
                errorText: _endDateError ? 'Date invalide' : null, // Afficher un texte d'erreur si _endDateError est vrai
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _medicationController,
              decoration: InputDecoration(
                labelText: 'Médicament',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: 'Dosage',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addPrescription();
              },
              child: Text('Ajouter la prescription'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime currentDate = DateTime.now();
    final DateTime startDate = _startDateController.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').parse(_startDateController.text)
        : currentDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate.add(Duration(days: 1)), // Commencer au jour suivant de la date de début
      firstDate: startDate.add(Duration(days: 1)), // Commencer au jour suivant de la date de début
      lastDate: DateTime.now().add(Duration(days: 365)),
      locale: const Locale('fr'),
    );

    if (pickedDate != null) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(pickedDate);

      if (pickedDate.isBefore(currentDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La date ne peut pas être antérieure à la date actuelle.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (_startDateController.text.isNotEmpty && pickedDate.isBefore(formatter.parse(_startDateController.text))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La date de fin ne peut pas être antérieure à la date de début.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          controller.text = formattedDate;
        });
      }
    }
  }




  Future<void> _addPrescription() async {
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;
    String medication = _medicationController.text;
    String dosage = _dosageController.text;

    // Vérifier si les champs de date sont vides
    if (startDate.isEmpty || endDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez sélectionner une date de début et une date de fin.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Convertir les chaînes de date en objets DateTime
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateTime currentDate = DateTime.now();
    final DateTime startDateTime = formatter.parse(startDate);
    final DateTime endDateTime = formatter.parse(endDate);

    // Vérifier si la date de début est antérieure à la date du jour
    if (startDateTime.isBefore(currentDate)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La date de début ne peut pas être antérieure à la date actuelle.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Vérifier si la date de fin est antérieure à la date de début
    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('La date de fin ne peut pas être antérieure à la date de début.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Call API to add prescription
    try {
      await Api().addPrescription();
      // Prescription ajoutée avec succès, afficher un message de succès ou naviguer vers un autre écran
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Prescription ajoutée avec succès'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      // Gérer l'erreur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur s\'est produite lors de l\'ajout de la prescription: $e'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }


}
