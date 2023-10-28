// import 'dart:async';
// import 'opportunitymainpage.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// import 'leadmainpage.dart';
// import 'login.dart';
//
// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);
//
//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }
//
// class _SplashPageState extends State<SplashPage> {
//
//   String? loginvalue;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     profilePreference();
//     // Timer(
//     //     Duration(seconds: 3),
//     //         () =>
//     // );
//     Timer(
//         Duration(seconds: 0),
//             () =>
//
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LoginPage(),
//                 ))
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.transparent, // Set the color to transparent
//     );
//     // return SafeArea(
//     //   child: Scaffold(
//     //
//     //     body: Center(
//     //       child: Container(
//     //         width: 200,
//     //         height: 60,
//     //         decoration: BoxDecoration(
//     //           image: DecorationImage(
//     //             image: AssetImage(
//     //                 'images/logo1.png'),
//     //             fit: BoxFit.fill,
//     //           ),
//     //           shape: BoxShape.rectangle,
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
//
//   profilePreference() async {
//     loginvalue = await getStringValuesSF() as String;
//     Timer(
//       Duration(seconds: 0),
//           () =>
//           loginnavigates(loginvalue),
//     );
//
//
//   }
//
//   void loginnavigates(String? loginvalue) {
//     if(loginvalue == "loggedin")
//     {
//       Navigator.pushReplacement(context,
//         MaterialPageRoute(builder:
//             (context) =>
//             LeadMainPage(),
//         ),);
//     }
//     if(loginvalue == "loggedout")
//     {
//       Navigator.pushReplacement(context,
//         MaterialPageRoute(builder:
//             (context) =>
//             LoginPage(),
//         ),);
//     }
//
//   }
//
// }
// Future getStringValuesSF() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //Return String
//   String? stringValue = prefs.getString('logedData')??"loggedout";
//   print(stringValue);
//   print("Stringvalueeeee");
//   return stringValue;
// }
//




import 'dart:async';
import 'opportunitymainpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'leadmainpage.dart';
import 'login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  String? loginvalue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profilePreference();
    // Timer(
    //     Duration(seconds: 3),
    //         () =>
    // );

    Timer(
        Duration(seconds: 3),
            () =>

                Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ))
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Center(
          child: Container(
            width: 200,
             height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/logo.png'),
                fit: BoxFit.fill,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
        ),
      ),
    );
  }

  profilePreference() async {
    loginvalue = await getStringValuesSF() as String;
    Timer(
        Duration(seconds: 2),
            () =>
                loginnavigates(loginvalue),
    );


  }

  void loginnavigates(String? loginvalue) {
    if(loginvalue == "loggedin")
    {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
            (context) =>
                LeadMainPage(),
        ),);
    }
    if(loginvalue == "loggedout")
    {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder:
            (context) =>
                LoginPage(),
        ),);
    }

  }

}
Future getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
   String? stringValue = prefs.getString('logedData')??"loggedout";
 print(stringValue);
 print("Stringvalueeeee");
  return stringValue;
}
