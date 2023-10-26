import 'package:crm_project/lead_detail.dart';
import 'package:crm_project/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'leadcreation.dart';
import 'login.dart';
import 'opportunitymainpage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  await FlutterDownloader.initialize( // Initialize flutter_downloader
   // debug: true, // Set this to true for debugging purposes
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
 // runApp(const MyApp());




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
          primaryColor: Color(0xFF3D418E),

      ),
      //home:LeadDetail(267),
      home:SplashPage(),
 // home: OpportunityMainPage(),
    );
  }
}



