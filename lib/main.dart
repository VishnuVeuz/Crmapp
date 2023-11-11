import 'package:crm_project/quotation_detail.dart';
import 'package:crm_project/scrolling/quotationscrolling.dart';
import 'package:crm_project/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';

import 'customerdetail.dart';
import 'lead_detail.dart';
import 'leadcreation.dart';
import 'leadmainpage.dart';
import 'login.dart';
import 'opportunity_detail.dart';
import 'opportunitymainpage.dart';
import 'scrolling/customerscrolling.dart';

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
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
     // home:SplashPage(),
 // home: OpportunityMainPage(),

      navigatorKey: navigatorKey,
      initialRoute: 'HomePage', // Set the initial route
      routes: {
        'HomePage': (context) => SplashPage(),
        'LeadMainPage': (context) => LeadMainPage(),
        'LeadCreation': (context) => LeadCreation(0),
        'OpportunityMainPage': (context) => OpportunityMainPage(null, "", "", "", ""),
        'QuotationScrolling': (context) => QuotationScrolling("", ""),
        'CustomerScrolling': (context) => CustomerScrolling("", ""),
      },

    );
  }
}



