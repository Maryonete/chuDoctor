import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:doctor/service/api.dart';
import 'package:doctor/service/patient_api.dart';
=======
>>>>>>> d0db740 (add icon)
import 'package:doctor/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:doctor/pages/prescription.dart';
import 'package:doctor/service/prescription_api.dart';
<<<<<<< HEAD
import 'package:doctor/utils/snackbar_utils.dart';
=======
import 'package:doctor/utils/constants.dart';

>>>>>>> d0db740 (add icon)

class AddPrescriptionPage extends StatefulWidget {
  final int? patientId;

  const AddPrescriptionPage({Key? key, this.patientId}) : super(key: key);

  @override
  _AddPrescriptionPageState createState() => _AddPrescriptionPageState();
}

class _AddPrescriptionPageState extends State<AddPrescriptionPage> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _medicationController;
  late TextEditingController _dosageController;

  List<Map<String, dynamic>>? drugs;
  String? selectedDrug;

  Map<String, dynamic>? patientInfo;
  bool _startDateError = false;
  bool _endDateError = false;
  bool _isLoading = false;

  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    fetchPatientInfo();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _medicationController = TextEditingController();
    _dosageController = TextEditingController();
    fetchDrugs();
    if (drugs != null) {
      drugs!.sort((a, b) => a['name'].compareTo(b['name']));
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _medicationController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  Future<void> fetchDrugs() async {
    try {
<<<<<<< HEAD
      List<Map<String, dynamic>>? result = await Api().getDrugs(context);
=======
      List<Map<String, dynamic>>? result = await PrescriptionApi().getDrugs(context);
>>>>>>> d0db740 (add icon)
      setState(() {
        drugs = result ?? []; // Utiliser une liste vide si result est null
      });
    } catch (e) {
<<<<<<< HEAD
      print('Error fetching drugs: $e');
=======
      SnackbarUtils.showMessage(context,'Error fetching drugs: $e',duration: Duration(seconds: 2));
>>>>>>> d0db740 (add icon)
    }
  }

  Future<void> fetchPatientInfo() async {
    if (widget.patientId != null) {
      try {
<<<<<<< HEAD
        Map<String, dynamic>? result = await PatientApi.fetchPatientInfo(widget.patientId!);
=======
        Map<String, dynamic>? result = await AppUsersUtils.fetchPatientInfo(context, widget.patientId!);
>>>>>>> d0db740 (add icon)
        setState(() {
          patientInfo = result;
        });
      } catch (e) {
<<<<<<< HEAD
        print('Error fetching patient info: $e');
=======
        SnackbarUtils.showMessage(context,'Erreur: $e',duration: Duration(seconds: 2));
>>>>>>> d0db740 (add icon)
      }
    }
  }

  void _editMedication(int index) {
    String? selectedDrug = medications[index]['name'];
    String dosage = medications[index]['dosage'];

    if (selectedDrug != null && selectedDrug.isNotEmpty && dosage.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Modifier le médicament'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedDrug,
                onChanged: (String? value) {
                  setState(() {
                    medications[index]['name'] = value!;
                  });
                },
                items: drugs != null
                    ? drugs!.map((Map<String, dynamic> drug) {
                  return DropdownMenuItem<String>(
                    value: drug['name'],
                    child: Text(drug['name']),
                  );
                }).toList()
                    : [],
                decoration: InputDecoration(labelText: 'Médicament'),
              ),
              TextField(
                controller: TextEditingController(text: dosage),
                onChanged: (value) => medications[index]['dosage'] = value,
                decoration: InputDecoration(labelText: 'Dosage'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur'),
          content: Text('Veuillez renseigner le médicament et le dosage.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _removeMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
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
        title: Text(
          patientInfo != null
              ? 'Nouvelle prescription\n${patientInfo!["firstName"]} ${patientInfo!["lastName"]}'
              : 'Prescriptions du patient',
<<<<<<< HEAD
          style: const TextStyle(color: Colors.white),
        ),
=======
          style: const TextStyle(color: Colors.white, fontFamily: 'Georgia'),
        ),
        iconTheme: IconThemeData(color: Colors.white),
>>>>>>> d0db740 (add icon)
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              AuthUtils.logout(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  errorText: _startDateError ? 'Date invalide' : null,
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
                  errorText: _endDateError ? 'Date invalide' : null,
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              if (medications.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Médicaments sélectionnés:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: medications.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(medications[index]['name'] ?? ''),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editMedication(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeMedication(index),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Utilisation de la liste triée dans le widget DropdownButtonFormField
                  DropdownButtonFormField<String>(
                    value: selectedDrug,
                    onChanged: (String? value) {
                      setState(() {
                        selectedDrug = value;
                      });
                    },
                    items: drugs != null
                        ? (drugs!
                      ..sort((a, b) => a['name'].compareTo(b['name']))) // Tri des médicaments par nom
                        .map((Map<String, dynamic> drug) {
                      return DropdownMenuItem<String>(
                        value: drug['name'],
                        child: Text(drug['name']),
                      );
                    }).toList()
                        : [],
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
                    onPressed: _isLoading ? null : _addMedication,
                    child: Text('Ajouter un médicament'),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Center(
                child: IgnorePointer(
                  ignoring: _isLoading,
                  child: Opacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _addPrescription,
                      style: ButtonStyle(
<<<<<<< HEAD
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
=======
                        backgroundColor: MaterialStateProperty.all<Color>(AppColors.myColor),
>>>>>>> d0db740 (add icon)
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator() // Afficher CircularProgressIndicator si _isLoading est vrai
                          : Text('Enregistrer la prescription'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMedication() {
    String selectedDrugName = selectedDrug ?? '';
    String dosage = _dosageController.text;

    if (selectedDrugName.isNotEmpty && dosage.isNotEmpty) {
      setState(() {
        medications.add({
          'name': selectedDrugName,
          'dosage': dosage,
        });
        selectedDrug = null;
        _dosageController.clear();
      });
    }
  }
  // selection date de debut et fin de la prescription
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime currentDate = DateTime.now();
    final DateTime startDate = controller.text.isNotEmpty
        ? DateFormat('dd-MM-yyyy').parse(controller.text)
        : currentDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: startDate.add(const Duration(days: 1)),
      firstDate: startDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('fr'),
    );

    if (pickedDate != null) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formattedDate = formatter.format(pickedDate);

      if (pickedDate.isBefore(currentDate)) {
        SnackbarUtils.showMessage(context,'La date ne peut pas être antérieure à la date actuelle',duration: Duration(seconds: 2));
      } else if (controller.text.isNotEmpty && pickedDate.isBefore(formatter.parse(controller.text))) {
         SnackbarUtils.showMessage(context,'La date de fin ne peut pas être antérieure à la date de début.',duration: Duration(seconds: 2));
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

    if (startDate.isEmpty || endDate.isEmpty || medications.isEmpty) {
      SnackbarUtils.showMessage(context, 'Veuillez renseigner toutes les informations nécessaires.', duration: Duration(seconds: 5));
      return;
    }
    // Appeler la fonction checkMedecinID pour obtenir l'ID du médecin
<<<<<<< HEAD
    String? medecinId = await AuthUtils().checkMedecinID();
=======
    String? medecinId = await AppUsersUtils().checkMedecinID();
>>>>>>> d0db740 (add icon)
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateTime currentDate = DateTime.now();
    final DateTime startDateTime = formatter.parse(startDate);
    final DateTime endDateTime = formatter.parse(endDate);

    if (startDateTime.isBefore(currentDate)) {
      SnackbarUtils.showMessage(
          context,
          'La date de début ne peut pas être antérieure à la date actuelle',
          duration: Duration(seconds: 2));
      return;
    }

    if (endDateTime.isBefore(startDateTime)) {
      SnackbarUtils.showMessage(
          context,
          'La date de fin ne peut pas être antérieure à la date de début',
          duration: Duration(seconds: 2));
      return;
    }

    setState(() {
      _isLoading = true; // Activer l'indicateur de chargement
    });

    // Convertir les chaînes de date en DateTime
    DateTime startD = formatter.parse(startDate);
    DateTime endD = formatter.parse(endDate);

    // Construire les données de prescription
    var prescriptionData = {
      'startDate': startD.toIso8601String(),
      'endDate': endD.toIso8601String(),
      'patient_id': widget.patientId,
      'medications': medications.map((medication) {
        // Trouver l'ID du médicament en fonction de son nom
        String? selectedDrugName = medication['name'];
        String? drugId;
        if (selectedDrugName != null && drugs != null) {
          for (var drug in drugs!) {
            if (drug['name'] == selectedDrugName) {
              drugId = drug['id'].toString();;
              break;
            }
          }
        }
        // Utiliser l'ID du médicament trouvé dans les données de prescription
        return {
          'drugId': drugId,
          'dosage': medication['dosage'],
        };
      }).toList(),
      'medecin_id' : medecinId
    };

    try {
      // Appeler la fonction addPrescription pour envoyer les données à l'API
      await PrescriptionApi().addPrescription(prescriptionData);
      // Réinitialiser les contrôleurs et vider la liste de médicaments après l'ajout réussi
      setState(() {
        _medicationController.clear();
        _dosageController.clear();
        medications.clear();
        _isLoading = false; // Désactiver l'indicateur de chargement
      });
      // Naviguer vers PrescriptionPage après l'enregistrement réussi avec widget.patientId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PrescriptionPage(patientId: widget.patientId),
        ),
      );

      SnackbarUtils.showMessage(context,'Prescription ajoutée avec succès',backgroundColor: Colors.green, duration: Duration(seconds: 2));

    } catch (e) {
      // Gérer les erreurs de l'API
      setState(() {
        _isLoading = false; // Désactiver l'indicateur de chargement en cas d'erreur
      });
      SnackbarUtils.showMessage(
          context,
          'Une erreur s\'est produite lors de l\'ajout de la prescription',
          duration: Duration(seconds: 2));

      print('Error adding prescription: $e');
    }
  }
}
