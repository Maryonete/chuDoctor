import 'package:doctor/pages/patients_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login_page.dart';

// HomePage
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/logo.svg",
              height: 110,
              fit: BoxFit.scaleDown,),
            const Text("CHU SoigneMoi",
              style: TextStyle(
                  fontSize: 42,
                  fontFamily: 'Poppins'
              ),
            ),
            Padding(padding: EdgeInsets.only(top:0)),
            const Text("Espace médecins - s'identifier",
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),

          ],
        )
    );
  }
}