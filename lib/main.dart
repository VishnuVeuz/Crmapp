import 'package:crm_project/quotation_detail.dart';
import 'package:crm_project/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'customerdetail.dart';
import 'lead_detail.dart';
import 'leadcreation.dart';
import 'login.dart';
import 'opportunity_detail.dart';
import 'opportunitymainpage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await FlutterDownloader.initialize( // Initialize flutter_downloader
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
           providers: [
             ChangeNotifierProvider(create: (context) => PostProvider()),
             ChangeNotifierProvider(create: (context) => PostProvideropportunity()),
             ChangeNotifierProvider(create: (context) => PostProviderquotation()),
             ChangeNotifierProvider(create: (context) => PostProvidercustomer()),
          ],
          child: MyApp()
        ),
    );
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


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



