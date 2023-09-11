import 'package:crm_project/calendarcreate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'api.dart';
import 'drawer.dart';
import 'notificationactivity.dart';

class CalencerFullDetail extends StatefulWidget {
  var calendarId;
  CalencerFullDetail(this.calendarId);

  @override
  State<CalencerFullDetail> createState() => _CalencerFullDetailState();
}

class _CalencerFullDetailState extends State<CalencerFullDetail> {
  String? meetingsub,partnername,startdate,stopdate,duration,allday,organizer,
      reminder,location,meetingurl,tag,description,privacy,showas;

  String ? token;
  bool meetingvisibility = true,optionsvisibility = false;
  bool isCheckedAllday = false;
  bool _isInitialized = false;
  List tags = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCalendarDetails();
  }
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
              Text(
                meetingsub!,
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              )
            ],
          ),
          leading: Builder(
            builder: (context) =>
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: Image.asset("images/back.png"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Builder(builder: (context) {
              return Row(
                children: [
                  Container(
                    child: Stack(
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
                            bottom: 25,
                            right: 28,

                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Color(0xFFFA256B),
                              ),
                              child: Center(child: Text("12",style: TextStyle(color: Colors.white,fontSize: 8),)),
                            ),
                          ),
                        ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      icon: SvgPicture.asset("images/drawer.svg"),
                      onPressed: () {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 25,top: 8),
              //   child: Row(
              //     //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Column(
              //         children: [
              //
              //           InkWell(
              //             // onTap: (){
              //             //   Navigator.push(
              //             //       context,
              //             //       MaterialPageRoute(
              //             //           builder: (context) => CalendarAdd(0)));
              //             //
              //             // },
              //             child: SvgPicture
              //                 .asset(
              //               "images/create.svg",width: 28,height: 28,),
              //           ),
              //
              //
              //
              //
              //           Padding(
              //             padding: const EdgeInsets.only(top: 5),
              //             child: Text("Create",style: TextStyle(
              //               fontFamily: 'Mulish',
              //               fontWeight: FontWeight.w400,
              //               fontSize: 12,
              //               color: Color(0xFF212121),
              //             )),
              //           )
              //         ],
              //       ),
              //       SizedBox(width: 20,),
              //       Column(
              //
              //         children: [
              //
              //           InkWell(
              //             onTap: (){
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) =>
              //                           CalendarAdd(widget.calendarId,null,"",DateTime.now(),null,[])));
              //
              //             },
              //             child: SvgPicture
              //                 .asset(
              //               "images/edit.svg",width: 28,height: 28,),
              //           ),
              //
              //
              //
              //           Padding(
              //             padding: const EdgeInsets.only(top: 5),
              //             child: Text("Edit",style: TextStyle(
              //               fontFamily: 'Mulish',
              //               fontWeight: FontWeight.w400,
              //               fontSize: 12,
              //               color: Color(0xFF212121),
              //             )),
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 20),
                    child: SizedBox(
                      width: 93,
                      height: 33,
                      child: ElevatedButton(
                          child: Text(
                            "Edit",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.57,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CalendarAdd(widget.calendarId,null,"",DateTime.now(),null,[])));




                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9246A),
                          )),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 10, top: 20),
                  //   child: SizedBox(
                  //     width: 93,
                  //     height: 33,
                  //     child: ElevatedButton(
                  //         child: Text(
                  //           "Create",
                  //           style: TextStyle(
                  //               fontWeight: FontWeight.w700,
                  //               fontSize: 13.57,
                  //               color: Colors.black),
                  //         ),
                  //         onPressed: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(builder: (context) => CalendarAdd()),
                  //           );
                  //         },
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Colors.white,
                  //         )),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Meeting subject",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.3,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Text(
                          meetingsub!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF666666))
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:0, left: 22, right: 22),
                child: Divider(color: Color(0xFFEBEBEB)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Partner Name",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.3,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Text(
                          partnername!,
                          style:TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                              fontSize: 12,
                              color: Color(0xFF666666)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 23, right: 5),
                    child: Center(

                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2.2,
                        child: ElevatedButton(
                            child: Text(
                              "Meeting Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.black,fontFamily: 'Mulish'),
                            ),
                            onPressed: () {
                              setState(() {
                                meetingvisibility = true;
                                optionsvisibility = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary:  Color(0xFFEBEBEB),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 0, right: 10),
                    child: Center(

                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 2.4,
                        child: ElevatedButton(
                            child: Text(
                              "Options",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.black,fontFamily: 'Mulish'),
                            ),
                            onPressed: () {
                              setState(() {
                                optionsvisibility = true;
                                meetingvisibility = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary:  Color(0xFFEBEBEB),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: meetingvisibility,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Start at",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    startdate!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Stop at",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    stopdate!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Duration",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    duration!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 25, vertical: 0),
                        //       child: Text(
                        //         "All day",
                        //         style: TextStyle(
                        //             fontWeight: FontWeight.w600,
                        //             fontSize: 13,
                        //             color: Color(0xFF666666)),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(right: 70),
                        //       child: Checkbox(
                        //         value: isCheckedAllday,
                        //         onChanged: (bool? value) {
                        //           setState(() {
                        //             isCheckedAllday = value!;
                        //           });
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       top: 0, left: 22, right: 22),
                        //   child: Divider(color: Color(0xFFEBEBEB)),
                        // ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text("Organizer",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF666666))),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 2.3,

                              child: Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Text(
                                  organizer!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF666666)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Reminder",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    "reminder!",
                                    style:TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Location",
                                    style:TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width /2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    location!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Meeting URL",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    meetingurl!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Tags",
                                    style:TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    "Tags",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 22, right: 22),
                          child: Divider(color: Color(0xFFEBEBEB)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Description",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 2.3,

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Text(
                                    description!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: optionsvisibility,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text("Privacy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xFF666666))),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3,

                              child: Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Text(
                                  "Privacy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xFF000000)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 22, right: 22),
                        child: Divider(color: Color(0xFFEBEBEB)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text("Show as",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xFF666666))),
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3,

                              child: Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Text(
                                  "Show as",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Color(0xFF000000)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                ),
              )

            ],
          ),
        ),
      );
    }
  }
  void getCalendarDetails() async{

    token = await getUserJwt();

    var data =  await getCalendarData(widget.calendarId);
    print(data);
    print("gchgvhj");
    setState(() {

     // privacy,showas;
      print(data['partner_ids'][0]['display_name'].toString());
      print("demodemo");

      meetingsub= data['name'].toString()??"";
    partnername= data['partner_ids'][0]['display_name'].toString()??"";
      startdate= data['start'].toString();
      stopdate= data['stop'].toString();
      duration=data['duration'].toString();
      // allday=data['allday']?? false;

      // data['alarm_ids'].length!=0?
      //   reminder =data['alarm_ids']['name'].toString()??""
      //     :reminder = "";

      organizer=data['user_id']['name']??"";
      //reminder =data['alarm_ids']['name'].toString()??"";
      location=data['location'].toString()??"";
      meetingurl=data['videocall_location'].toString()??"";
      //tags
      description=data['description'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').toString()??"";

      // if (data["categ_ids"].length > 0) {
      //   //tags=snapshot.data![index]["tag_ids"][0]["name"].toString();
      //   tags = data["categ_ids"];
      // } else {
      //   tags = [];
      // }



      _isInitialized = true;

    });


    //print(token);


  }
}

