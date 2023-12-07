


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'leadcreation.dart';
import 'leadmainpage.dart';
import 'opportunitymainpage.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController urlController = TextEditingController();


  get message => null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFAA82E3) ,

      body: Column(

        children: [
          Container(
            width: MediaQuery.of(context).size.width/1,
            height: MediaQuery.of(context).size.height/1.8,
            color: Color(0xFFAA82E3),
            child: Column(

              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 62, left: 0,right: 30),
                  child: SizedBox(
                    width: 261,
                    height: 70,
                    child: Text(
                      '''For your customers.
CRM made easy.
      
      
      
                        '''
                          '',
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 27,
                        fontFamily: 'Proxima Nova',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 47.3, left: 20, right: 20),
                  child: Image.asset("images/main group.png"),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 46, left: 34.8),
                        child: SizedBox(
                          width: 92,
                          height: 35,
                          child: Text(
                            "Log in",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22.15,
                                fontFamily: 'Proxima Nova',
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 34),
                                child: SizedBox(
                                  width: 271,
                                  height: 19,
                                  child: TextFormField(
                                    controller: urlController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,

                                        hintText: 'Yourcompany.odoo.com',
                                        hintStyle: TextStyle(
                                            color: Color(0xFFAFAFAF),
                                            fontFamily: 'Proxima Nova',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 35,bottom: 13),
                                child: SvgPicture.asset("images/url.svg")
                                //Image.asset("images/user.png"),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 34, right: 34,top: 0),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: SizedBox(
                                width: 271,
                                height: 19,
                                child: TextFormField(
                                  controller: emailController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,

                                      hintText: 'Your email address',
                                      hintStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 35,bottom: 13),
                              child: SvgPicture.asset("images/email.svg"),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 34, right: 34,top: 0),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: SizedBox(
                                width: 273,
                                height: 19,
                                child: TextFormField(
                                  //textInputAction: TextInputAction.done,
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                          color: Color(0xFFAFAFAF),
                                          fontFamily: 'Proxima Nova',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 17)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 35,bottom: 13),
                              child: SvgPicture.asset("images/password.svg"),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 34, right: 34,top: 0),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20,left: 32,right: 32),
                          child: SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 53.12,
                            child: ElevatedButton(
                              child: Text(
                                "SUBMIT",

                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontFamily: 'Proxima Nova', fontSize: 15.57),
                              ),
                              onPressed: () async {


                                String userName,passWord,dbId,urlName;
                                userName = emailController.text.toString();
                                passWord = passwordController.text.toString();
                                urlName = urlController.text.toString();
                           // dbId = "Flutter_API";
                               // local

                             //dbId = "flutter_db";

                                // live server
                                // dbId = "FLUTTER__API";
                                // new local
                                // dbId = "KSA_nov_27";

                                // live server db by afna
                                dbId=  "VEUZ_FLUTTER_TEST";
                                String logindata = await login(userName,passWord,urlName);



                                if(logindata == "success"){

                                  addStringToSF("loggedin");

                                  print("test1");


                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => LeadMainPage()));
                                  //

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          LeadMainPage()));

                                }


                                else if(logindata == "Access Denied")
                                {
                                  print("test2");
                                  const snackBar = SnackBar(  content: Text('userId or Password is incorrect '),
                                    backgroundColor: Colors.blueGrey,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                                else{
                                  print("test3");
                                  const snackBar = SnackBar(  content: Text('Something Went Wrong Please check the Url.'),
                                    backgroundColor: Colors.blueGrey,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }



                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF043565),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16))),
                            ),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  addStringToSF(String logdetail) async {
    String logdetails;
    logdetails = logdetail;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('logedData', logdetails);
  }

}
