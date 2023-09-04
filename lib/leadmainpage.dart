import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_project/drawer.dart';
import 'package:crm_project/leadcreation.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'commonleads.dart';
import 'lead_detail.dart';
import 'globals.dart' as globals;


class LeadMainPage extends StatefulWidget {
  const LeadMainPage({Key? key}) : super(key: key);

  @override
  State<LeadMainPage> createState() => _LeadMainPageState();
}

class _LeadMainPageState extends State<LeadMainPage> {
  String username="";

  bool _isInitialized = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyData();
    profilePreference();
  }
  String? token;

  @override
  Widget build(BuildContext context) {

    if (!_isInitialized) {
      // Show a loading indicator or any other placeholder widget while waiting for initialization
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 10),
                child: Text(username, style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                    decoration: TextDecoration.none),),
              ),
            ],

          ),
          leading: Builder(
            builder: (context) =>
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    radius: 12,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      // Adjust the size of the icon as per your requirements
                      color: Colors
                          .white, // Adjust the color of the icon as per your requirements
                    ),

                  ),
                ),
          ),


          automaticallyImplyLeading: false,
          actions: [
            Builder(builder: (context) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(icon: SvgPicture.asset("images/messages.svg"),
                      onPressed: () {

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(icon: SvgPicture.asset("images/clock2.svg"),
                      onPressed: () {

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                      onPressed: () {

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
                      onPressed: () async {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ],
              );
            })
          ],

        ),
        body: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          //color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 5, right: 25),
                child: Text("Leads",
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101010)),

                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 25,top: 10,right: 25),
              //   child: Text("Lists",
              //     style:TextStyle(fontSize: 18,fontWeight:FontWeight.w500,color: Color(0xFF101010)),
              //
              //   ),
              // ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 35,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Image.asset("images/list.png"),
                                onPressed: () {},
                              ),
                              Text("My Leads",
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF414141)),

                              ),
                            ],
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            child: IconButton(
                              icon: Image.asset("images/Vector7.png"),
                              onPressed: () {},


                            ),
                          ),
                        )
                      ],
                    ),

                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LeadScrolling('my')));
                },
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 35,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              IconButton(
                                icon: Image.asset("images/list.png"),
                                onPressed: () {},
                              ),
                              Text("All Lists",
                                style: TextStyle(fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF414141)),

                              ),
                            ],
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            child: IconButton(
                              icon: Image.asset("images/Vector7.png"),
                              onPressed: () {},


                            ),
                          ),
                        )
                      ],
                    ),

                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LeadScrolling('')));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10, right: 25),
                child: Text("Recent Leads",
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101010)),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.45,

                  child: FutureBuilder(
                      future: recentLead("recent"),
                      builder: (context, AsyncSnapshot snapshot) {
                        print(snapshot.data);
                        print("snap data final ");
                        if (snapshot.hasError) {
                          print(snapshot.hasError);
                          print("snap error");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              print("dfffdfdf");
                              //print(snapshot.data!.length);
                              return const Center(child: Text(
                                  'Something went wrong'));
                            }

                            return ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              //shrinkWrap: true,
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Card(
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          height: 90,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, top: 15),
                                                child: Text(
                                                  snapshot
                                                      .data![index]["name"] ??
                                                      "",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 15),
                                                child: Text(snapshot
                                                    .data![index]["contact_name"] ??
                                                    "",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 12,
                                                      color: Color(0xFF787878)),
                                                ),

                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [


                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(left: 10),
                                                    child: RatingBar.builder(
                                                      initialRating: double
                                                          .parse(
                                                          snapshot
                                                              .data![index]["priority"] ??
                                                              0),
                                                      itemSize: 19,
                                                      minRating: 0,
                                                      direction: Axis
                                                          .horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 3,
                                                      itemPadding: EdgeInsets
                                                          .symmetric(
                                                          horizontal: 1.0),
                                                      itemBuilder: (context,
                                                          _) =>
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                            size: 10,
                                                          ),
                                                      onRatingUpdate: (
                                                          double value) {

                                                      },

                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(top: 0,left: 15),
                                                  //   child: Text("Ratingbar",
                                                  //     style: TextStyle(
                                                  //         fontWeight: FontWeight.w600,
                                                  //         fontSize: 12,
                                                  //         color: Color(0xFF787878)),
                                                  //   ),
                                                  // ),
                                                  snapshot
                                                      .data![index]["image_1920"] !=
                                                      "" ?

                                                  // Padding(
                                                  //   padding: const EdgeInsets
                                                  //       .only(right: 25),
                                                  //   child: Container(
                                                  //     width: 35,
                                                  //     height: 35,
                                                  //     decoration: BoxDecoration(
                                                  //         border: Border.all(
                                                  //         ),
                                                  //         borderRadius: BorderRadius
                                                  //             .all(
                                                  //             Radius.circular(
                                                  //                 20))
                                                  //     ),
                                                  //     child: CircleAvatar(
                                                  //       radius: 12,
                                                  //       child: ClipRRect(
                                                  //
                                                  //         borderRadius:
                                                  //         BorderRadius
                                                  //             .circular(18),
                                                  //         child: Image.memory(
                                                  //           base64Decode(
                                                  //               snapshot
                                                  //                   .data![index]["image_1920"] ??
                                                  //                   ""),
                                                  //           fit: BoxFit.cover,
                                                  //           width: MediaQuery
                                                  //               .of(
                                                  //               context)
                                                  //               .size
                                                  //               .width,
                                                  //           height: 300,
                                                  //         ),
                                                  //       ),
                                                  //
                                                  //
                                                  //     ),
                                                  //   ),
                                                  // ) :



                                                Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 25),
                                                    child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20))
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 12,
                                                        child: ClipRRect(

                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(18),
                                                          child:Image.network(
                                                              "${snapshot.data![index]["image_1920"]}?token=${token}"),

                                                        ),


                                                      ),
                                                    ),
                                                  ) :

                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(right: 25),
                                                    child: Container(
                                                      width: 35,
                                                      height: 35,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                          ),
                                                          borderRadius: BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  20))
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 12,
                                                        child: Icon(
                                                          Icons.person,
                                                          size: 20,
                                                          // Adjust the size of the icon as per your requirements
                                                          color: Colors
                                                              .white, // Adjust the color of the icon as per your requirements
                                                        ),

                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          //color: Colors.green,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LeadDetail(snapshot
                                                        .data![index]["id"])));
                                      },
                                    )
                                  ],

                                );
                              },
                            );
                          }
                        }
                        return Center(child: const CircularProgressIndicator());
                      }
                  ),


                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LeadCreation(0)));
            // Add your onPressed code here!
          },
          backgroundColor: Color(0xFF3D418E),
          child: const Icon(Icons.add),
        ),
      );
    }
  }

  companyData() async {

    token = await getUserJwt();

    String responce = await getUserCompanyData();
    print(responce);

    // List<dynamic> dynamicList = json.decode(responce);
    List<Map<String, dynamic>> dataList = json.decode(responce).cast<Map<String, dynamic>>();

    globals.selectedIds =  dataList
        .where((item) => item['selected'] == true)
        .map<int>((item) => item['id'])
        .toList();

    print(globals.selectedIds);
    print("kjbjdemo teststststnk");
    setState(() {
      _isInitialized = true;
    });

  }


  profilePreference() async{
    username = await getStringValuesSF() as String;

  }


}
Future getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('personName')??"";
  print(stringValue);
  print("Stringvalueeeee");
  return stringValue;
}
