import 'package:flutter/material.dart';
import 'package:doctor/utils/utils.dart';
import 'package:doctor/pages/addPrescription.dart';
import 'package:doctor/service/patient_api.dart';
import 'package:doctor/service/prescription_api.dart';
<<<<<<< HEAD
=======
import 'package:doctor/utils/constants.dart';
>>>>>>> d0db740 (add icon)


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
<<<<<<< HEAD
        Map<String, dynamic>? result = await PatientApi.fetchPatientInfo(widget.patientId!);
=======
        Map<String, dynamic>? result = await AppUsersUtils.fetchPatientInfo(context, widget.patientId!);
>>>>>>> d0db740 (add icon)
        setState(() {
          patientInfo = result;
        });
      } catch (e) {
        print('Error fetching patient info: $e');
      }
    }
  }

  // liste prescriptions du patients
  Future<void> fetchPrescriptions() async {
    try {
      Map<String, dynamic> prescriptionData = {
        'patient_id': widget.patientId,
<<<<<<< HEAD
        'medecin_id': await AuthUtils().checkMedecinID(),
=======
        'medecin_id': await AppUsersUtils().checkMedecinID(),
>>>>>>> d0db740 (add icon)
      };
      List<Map<String, dynamic>>? result =
      await PrescriptionApi.getPrescriptionsPatient(context, prescriptionData);
      setState(() {
        prescriptions = result;
      });
    } catch (e) {
      print('Error fetching prescriptions: $e');
    }
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
                    : 'Prescriptions du patient',
<<<<<<< HEAD
                style: const TextStyle(color: Colors.white),
=======
                style: const TextStyle(color: Colors.white, fontFamily: 'Georgia'),
>>>>>>> d0db740 (add icon)
                overflow: TextOverflow.ellipsis, // Gérer le dépassement de texte avec des points de suspension
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
      body: prescriptions != null
          ? ListView.builder(
        itemCount: prescriptions!.length,
        itemBuilder: (context, index) {
          var medications = prescriptions![index]['medications'];
          var medicationsList = <Widget>[]; // Initialise la liste de widgets

          if (medications != null) {
            medicationsList = medications.map<Widget>((med) {
              return ListTile(
                title: Text(med['drug']),
                subtitle: Text(med['dosage']),
              );
            }).toList();
          }

          // Calculer le numéro de prescription
          int prescriptionCount = prescriptions!.length - index;

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
                      'Prescription $prescriptionCount',
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
                  title: Text('Début: ${AppDateUtils().formatDate(prescriptions![index]['start'])}'),
                  subtitle: Text('Fin: ${AppDateUtils().formatDate(prescriptions![index]['end'])}'),
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
<<<<<<< HEAD
        backgroundColor: Colors.blue, // Couleur de fond du bouton flottant
=======
        backgroundColor: AppColors.myColor, // Couleur de fond du bouton flottant
>>>>>>> d0db740 (add icon)
        foregroundColor: Colors.white, // Couleur de l'icône
        child: Icon(Icons.add),
      ),
    );
  }





  Future<void> _showEditPrescriptionDialog(BuildContext context, int prescriptionId, String currentEndDate) async {
    DateTime? selectedDate = DateTime.parse(currentEndDate); // Initialisez la date sélectionnée à la date actuelle

    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      locale: const Locale('fr'),
      confirmText: 'Enregistrer',
      helpText: 'Date de fin de la prescription',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Modifiez le texte du bouton d'action principale (Valider)
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
<<<<<<< HEAD
                textStyle: TextStyle(color: Colors.blue), // Couleur du texte du bouton
=======
                textStyle: TextStyle(color: AppColors.myColor), // Couleur du texte du bouton
>>>>>>> d0db740 (add icon)
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newDate != null) {
      selectedDate = newDate;
      // Mettez à jour la prescription avec la nouvelle date de fin
      try {
        // Appelez la fonction pour mettre à jour la prescription avec la nouvelle date de fin
        await PrescriptionApi().setPrescriptionDateEnd(prescriptionId, selectedDate);
        // Rafraîchissez la liste des prescriptions
        fetchPrescriptions();
      } catch (e) {
        print('Error updating prescription: $e');
        // Gérer l'erreur
      }
    }
  }



}
