import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crm_project/drawer.dart';
import 'package:crm_project/leadcreation.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnavigation.dart';
import 'notificationactivity.dart';
import 'api.dart';
import 'commonleads.dart';
import 'lead_detail.dart';
import 'globals.dart' as globals;
import 'notification.dart';
import 'opportunitymainpage.dart';


class LeadMainPage extends StatefulWidget {
  const LeadMainPage({Key? key}) : super(key: key);

  @override
  State<LeadMainPage> createState() => _LeadMainPageState();
}

class _LeadMainPageState extends State<LeadMainPage> {
  void _onItemTapped(int index) {
    setState(() {
      //_selectedIndex = index;
    });
  }


  String username="";
  List tags = [];
  bool _isInitialized = false;
  String notificationCount="0";
  String messageCount="0";
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
        appBar:  AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0,right: 0),
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width/4.5,
                  child: Text(username,style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.none),),
                ),
              )
            ],
          ),
          leading: Builder(
            builder: (context)=>Padding(
              padding: const EdgeInsets.only(left:20),
              child: CircleAvatar(
                radius: 10,
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
            Builder(builder: (context){
              return Row(
                children: [
                  Stack(
                      alignment: Alignment
                          .center,
                      children: [
                        IconButton(icon: SvgPicture.asset("images/messages.svg"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Notifications()));
                          },
                        ),
                        Positioned(
                          bottom: 24,
                          right: 24,

                          child: Container(
                            width: 17.0,
                            height: 19.0,
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle,
                              color: Color(0xFFFA256B),
                            ),
                            child: Center(child: Text(messageCount,style: TextStyle(color: Colors.white,fontSize: 8),)),
                          ),
                        ),
                      ]
                  ),
                  Stack(
                      alignment: Alignment
                          .center,
                      children: [
                        IconButton(icon: SvgPicture.asset("images/clock2.svg"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ActivitiesNotification()));
                          },
                        ),
                        Positioned(
                          bottom: 24,
                          right: 24,

                          child: Container(
                            width: 17.0,
                            height: 19.0,
                            decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle,
                              color: Color(0xFFFA256B),
                            ),
                            child: Center(child: Text(notificationCount,style: TextStyle(color: Colors.white,fontSize: 8),)),
                          ),
                        ),
                      ]
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 0),
                  //   child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                  //     onPressed: () {
                  //
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(icon:SvgPicture.asset("images/drawer.svg"),
                      onPressed: (){
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                ],
              );
            })
          ],
        ),
        body: WillPopScope(
          onWillPop: () => _goBack(context),
          child: Container(
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
                Container(
                  height:50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 5, right: 25),
                        child: Text("Leads",
                          style: TextStyle(fontSize: 18,
                               //letterSpacing: .5,

                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w600,

                              color: Color(0xFF101010)),

                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 25,top: 8),
                      //   child: Container(
                      //     child: Row(
                      //       children: [
                      //         InkWell(
                      //           onTap: () {
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => LeadCreation(0)));
                      //           },
                      //           child: SvgPicture.asset(
                      //             "images/create.svg",
                      //             width: 28,
                      //             height: 28,
                      //           ),
                      //         ),
                      //         SizedBox(width: 5,),
                      //         Text("New",      style: TextStyle(fontSize: 12,
                      //             //letterSpacing: .5,
                      //
                      //             fontFamily: 'Mulish',
                      //             fontWeight: FontWeight.w600,
                      //
                      //             color: Color(0xFF212121)),)
                      //       ],
                      //     ),
                      //   ),
                      // ),

                    ],
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
                    padding: const EdgeInsets.only(top: 2,left: 8),
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
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF414141)),

                                ),
                              ],
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
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
                        builder: (context) => LeadScrolling('my',"","")));
                  },
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5,left: 8),
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
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF414141)),

                                ),
                              ],
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
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
                        builder: (context) => LeadScrolling('',"","")));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 40,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24, top: 10, right: 25),
                      child: Text("Recent Leads",

                        style: TextStyle(fontSize: 17,
                            wordSpacing: 4,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Mulish',
                            color: Color(0xFF101010)),

                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 1.67,

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
                              print("dajkdnm1");
                             // print(snapshot.data[0]["tag_ids"].length);
                              print("dajkdnm");
                              print(snapshot.data?.length);
                              // if (snapshot.data[0]["tag_ids"].length > 0) {
                              //   //tags=snapshot.data![index]["tag_ids"][0]["name"].toString();
                              //   tags = snapshot.data[0]["tag_ids"];
                              // } else {
                              //   tags = [];
                              // }
                          return    snapshot.data?.length == 0 ?  Center(child: Text("No data found", style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight
                                  .w600,
                              fontSize: 14,
                              color: Colors.black))):

                               ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                //shrinkWrap: true,
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  if (snapshot.data[index]["tag_ids"].length > 0) {
                                    //tags=snapshot.data![index]["tag_ids"][0]["name"].toString();
                                    tags = snapshot.data[index]["tag_ids"];
                                  } else {
                                    tags = [];
                                  }

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: Card(
                                          //elevation:5,
                                          //shadowColor: Colors.grey,
                                          child: Container(

                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                           // height: 90,
                                           // decoration: const BoxDecoration(
                                           //   borderRadius: BorderRadius.all(Radius.circular(20)),
                                           //   boxShadow: [
                                           //     BoxShadow(
                                           //       color: Colors.grey,
                                           //       blurRadius: 25.0,
                                           //       offset: Offset(0, -10)
                                           //     )
                                           //   ]
                                           // ),

                                           child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(
                                                          left: 20, top: 5),
                                                      child: Text(
                                                        snapshot
                                                            .data![index]["name"] ??
                                                            "",
                                                        style: TextStyle(
                                                            fontFamily: 'Mulish',
                                                           // wordSpacing: 5,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            fontSize: 14,
                                                            color: Colors.black),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: snapshot.data![index]["contact_name"]==""?false:true,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(
                                                            top: 5, left: 20),
                                                        child: Text(snapshot
                                                            .data![index]["contact_name"] ??
                                                            "",
                                                          style: TextStyle(
                                                              fontFamily: 'Mulish',
                                                              fontWeight: FontWeight
                                                                  .w600,
                                                              fontSize: 12,
                                                              color: Color(0xFF787878)),
                                                        ),

                                                      ),
                                                    ),

                                                  Visibility(
                                                    visible: tags!.length >0 ? true : false,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 20),
                                                      child: Container(
                                                          width: MediaQuery
                                                              .of(context)
                                                              .size
                                                              .width/1.4 ,
                                                          height: 20,
                                                          //color: Colors.pinkAccent,

                                                          child: ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            shrinkWrap: true,
                                                            itemCount: tags!.length ?? 0,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              return Padding(
                                                                padding:
                                                                const EdgeInsets.only(right: 8.0, top: 4),
                                                                child: SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,

                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        height: 5,
                                                                        width: 5,
                                                                        color:  Color(int.parse(tags![index]["color"])),
                                                                        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),

                                                                      ),
                                                                      SizedBox(width: 4,),

                                                                      Center(
                                                                        child: Text(

                                                                          tags![index]["name"].toString(),
                                                                          style: TextStyle(
                                                                              color: Color(0xFF787878),
                                                                              fontFamily: 'Mulish',
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 12),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                    ),
                                                  ),





                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [


                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(left: 15,bottom: 8,top: 2),
                                                          child: Container(
                                                            //color:Colors.green,
                                                            width: MediaQuery.of(context).size.width/1.23,
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





                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(right: 25,bottom:5,left: 0),
                                                          child: Container(
                                                            width: 25,
                                                            height: 25,
                                                            decoration: BoxDecoration(
                                                              //color: Colors.red,
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
                                                              .only(right: 25,bottom: 8,left: 0),
                                                          child: Container(
                                                            width: 25,
                                                            height: 25,
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
        ),

        // bottomNavigationBar: NavigationBar(
        //   onDestinationSelected: (int index) {
        //
        //
        //     print(index);
        //     print("final data");
        //     if(index==0){
        //       // Navigator.push(context,
        //       //     MaterialPageRoute(
        //       //         builder: (context) =>
        //       //             LeadScrolling(
        //       //                 '', "notification",
        //       //                 "[assigned_to_me]")));
        //     }
        //     else if(index==1){
        //       Navigator.push(context,
        //           MaterialPageRoute(
        //               builder: (context) =>
        //                   LeadScrolling(
        //                       '', "",
        //                       "")));
        //
        //     }
        //     else if (index==2) {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) =>
        //                   OpportunityMainPage(
        //                       null, "", "",
        //                       "", "")));
        //     }
        //     else if(index==3){
        //       Scaffold.of(context).openDrawer();
        //     }
        //     setState(() {
        //      // currentPageIndex = index;
        //     });
        //   },
        //
        //   backgroundColor: Colors.white,
        //  // indicatorColor: Colors.amber[800],
        //   //selectedIndex: currentPageIndex,
        //
        //   destinations: [
        //     NavigationDestination(
        //       selectedIcon: Icon(Icons.home),
        //       icon: SvgPicture.asset("images/ho.svg"),
        //       label: 'Home',
        //
        //     ),
        //     NavigationDestination(
        //       icon: SvgPicture.asset("images/leadd.svg"),
        //       label: 'Leads',
        //     ),
        //     NavigationDestination(
        //       selectedIcon: Icon(Icons.school),
        //       icon: SvgPicture.asset("images/oppo.svg"),
        //       label: 'Opportunity',
        //
        //     ),
        //     NavigationDestination(
        //       selectedIcon: Icon(Icons.school),
        //       icon:  SvgPicture.asset("images/mo.svg"),
        //       label: 'More',
        //
        //     ),
        //   ],
        // ),


        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: FloatingActionButton(
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
        ),
        bottomNavigationBar:MyBottomNavigationBar(1),
      );
    }
  }


  companyData() async {

    token = await getUserJwt();

    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();

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

  Future<bool> _goBack(BuildContext context) async {

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Do you want to exit'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text('Yes'),
              ),
            ],
          ));
      return Future.value(true);

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



