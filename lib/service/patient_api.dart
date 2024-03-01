import 'package:doctor/service/api.dart';

class PatientApi {
  static Future<Map<String, dynamic>?> fetchPatientInfo(int patientId) async {
    try {
      Map<String, dynamic>? result = await Api().getInfoPatient(patientId);
      return result;
    } catch (e) {
      print('Error fetching patient info: $e');
      return null;
    }
  }
}
