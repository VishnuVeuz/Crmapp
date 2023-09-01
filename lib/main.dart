import 'package:crm_project/lead_detail.dart';
import 'package:crm_project/splash.dart';
import 'package:flutter/material.dart';

import 'leadcreation.dart';
import 'login.dart';
import 'opportunitymainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFF3D418E)
        //primarySwatch: Colors.blue,
      ),
      //home:LeadDetail(267),
      home:SplashPage(),
 // home: OpportunityMainPage(),
    );
  }
}



