import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Page login
class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key});

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}
class _PatientsListPageState extends State<PatientsListPage> {


  final events =
  [
    {
      "title" : "Marie Chrismas",
      "heure" : "16H",
      "spe" : "Biologie",
    },
    {
      "title" : "Damien Cavailles",
      "heure" : "09H",
      "spe" : "Médecine",
    },
    {
      "title" : "Jean Émarre",
      "heure" : "10H",
      "spe" : "Biologie",
    },
    {
      "title" : "Sophie Dupont",
      "heure" : "14H",
      "spe" : "Médecine",
    },
    {
      "title" : "Jacques Sonne",
      "heure" : "15H",
      "spe" : "Biologie",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: ListView.builder(

          itemCount: events.length,
          itemBuilder: (context, index){
            final event = events[index];
            final title = event['title'];
            final spe = event['spe'];
            final heure = event['heure'];
            return
              Card(
                child: ListTile(
                  title: Text("[$heure] $title"),
                  subtitle:
                  Text("$spe"),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
              );
          },
        )
    );
  }


}
