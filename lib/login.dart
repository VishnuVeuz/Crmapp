


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'leadcreation.dart';
import 'leadmainpage.dart';


class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  get message => null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1,
            height: MediaQuery.of(context).size.height/2,
            color: Color(0xFF3D418E),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 62, left: 49),
                  child: SizedBox(
                    width: 261,
                    height: 60,
                    child: Text(
                      '''For your customers.
CRM made easy.
      
      
      
                        '''
                          '',
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        fontFamily: 'Mulish',
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
                        padding: const EdgeInsets.only(top: 32, left: 34.8),
                        child: SizedBox(
                          width: 62,
                          height: 25,
                          child: Text(
                            "Log in",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.15,
                                fontFamily: 'Mulish',
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 40),
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
                                          color: Colors.grey,
                                          fontFamily: 'Mulish',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 35,bottom: 13),
                              child: Image.asset("images/user.png"),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 34, right: 34,top: 10),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
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
                                          color: Colors.grey,
                                          fontFamily: 'Mulish',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 35,bottom: 13),
                              child: Image.asset("images/lock2.png"),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 34, right: 34,top: 10),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: 329.64,
                            height: 53.12,
                            child: ElevatedButton(
                              child: Text(
                                "SUBMIT",

                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontFamily: 'Mulish', fontSize: 15.57),
                              ),
                              onPressed: () async {


                                String userName,passWord,dbId;
                                userName = emailController.text.toString();
                                passWord = passwordController.text.toString();
                                  // dbId = "Flutter_API";
                                dbId = "flutter_db";
                                String logindata = await login(userName,passWord,dbId);



                                if(logindata == "success"){

                                  addStringToSF("loggedin");

                                  print("test1");


                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LeadMainPage()));
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
                                  const snackBar = SnackBar(  content: Text('Something Went Wrong.'),
                                    backgroundColor: Colors.blueGrey,);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }



                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFEF4253),
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
