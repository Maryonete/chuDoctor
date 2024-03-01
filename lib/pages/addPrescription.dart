import 'package:flutter/material.dart';
import 'package:doctor/service/api.dart';
import 'package:doctor/service/patient_api.dart';

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
              //logout();
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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toString();
      });
    }
  }

  Future<void> _addPrescription() async {
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;
    String medication = _medicationController.text;
    String dosage = _dosageController.text;

    // Call API to add prescription
    try {
      await Api().addPrescription();
      // Prescription added successfully, show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Prescription ajoutée avec succès'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Une erreur s\'est produite lors de l\'ajout de la prescription: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
