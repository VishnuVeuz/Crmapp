import 'package:basic_utils/basic_utils.dart';
import 'package:crm_project/calendarcreate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'api.dart';
import 'calendarmainpage.dart';
import 'drawer.dart';
import 'globals.dart';

class CalencerFullDetail extends StatefulWidget {
  var calendarId;
  CalencerFullDetail(this.calendarId);

  @override
  State<CalencerFullDetail> createState() => _CalencerFullDetailState();
}

class _CalencerFullDetailState extends State<CalencerFullDetail> {
  String? meetingsub,partnername,startdate,stopdate,duration,allday,organizer,
      location,meetingurl,description,privacy,showas;

  List reminder = [];
  List tags = [];


  String ? token;
  bool meetingvisibility = true,optionsvisibility = false;
  bool isCheckedAllday = false;
  bool _isInitialized = false;

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
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width/2.5,
                //color: Colors.red,
                child: Text(
                  meetingsub!,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return Calender(null,"",DateTime.now(),null,[],"");
                          },
                            settings: RouteSettings(name: 'Calender',),
                          ));
                    },
                  ),
                ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: SvgPicture.asset("images/drawer.svg"),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            })
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Calender(null,"",DateTime.now(),null,[],"")));
            return true;
          },
          child: Container(
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
                Padding(

                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [

                          InkWell(
                            onTap: (){
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => CalendarAdd()),);
                            },
                            child: SvgPicture
                                .asset(
                              "images/create.svg",width: 28,height: 28,),
                          ),



                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Create",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),
                      Column(
                        children: [


                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CalendarAdd(widget.calendarId,null,"",DateTime.now(),null,[],"")));




                            },
                            child: SvgPicture
                                .asset(
                              "images/edit.svg",width: 28,height: 28,),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Edit",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: ()async{

                              var data =
                              await deleteCalendar(
                                  widget.calendarId);

                              if (data['message'] ==
                                  "Success") {
                                print("responce");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Calender(null,"",DateTime.now(),null,[],"")));
                              }



                            },
                            child: SvgPicture
                                .asset(
                              "images/delete.svg",width: 28,height: 28,),
                          ),




                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Delete",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),

                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 25, top: 20),
                //       child: SizedBox(
                //         width: 93,
                //         height: 33,
                //         child: ElevatedButton(
                //             child: Text(
                //               "Edit",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 13.57,
                //                   color: Colors.white),
                //             ),
                //             onPressed: () {
                //               Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                       builder: (context) =>
                //                           CalendarAdd(widget.calendarId,null,"",DateTime.now(),null,[])));
                //
                //
                //
                //
                //             },
                //             style: ElevatedButton.styleFrom(
                //               primary: Color(0xFFF9246A),
                //             )),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 10, top: 20),
                //       child: SizedBox(
                //         width: 93,
                //         height: 33,
                //         child: ElevatedButton(
                //             child: Text(
                //               "Create",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 13.57,
                //                   color: Colors.black),
                //             ),
                //             onPressed: () {
                //               // Navigator.push(
                //               //   context,
                //               //   MaterialPageRoute(builder: (context) => CalendarAdd(0)),
                //               // );
                //             },
                //             style: ElevatedButton.styleFrom(
                //               primary: Colors.white,
                //             )),
                //       ),
                //     ),
                //   ],
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
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
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              meetingsub!,
                              style:  TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  color: Color(0xFF212121)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
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
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              partnername!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  color: Color(0xFF212121)),
                            ),
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
                              .width / 2.5,
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
                                primary: Color(0xFFEBEBEB),
                              )),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 0, right: 10),
                      child: Center(

                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2.2,
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
                                primary: Color(0xFFEBEBEB),
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
                                      style:  TextStyle(
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
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        startdate!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF212121)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 22, right: 22),
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
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        stopdate!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF212121)),
                                      ),
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
                                      style:  TextStyle(
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
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        duration!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF212121))
                                      ),
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
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      organizer!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF212121)),
                                    ),
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 2),
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 2.3,

                                     // color: Colors.pinkAccent,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: reminder!.length ?? 0,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Padding(
                                          padding:
                                          const EdgeInsets.only(right: 8.0, top: 5),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,

                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(30)),
                                               // color:  Color(int.parse(reminder![index]["color"])),
                                               // color: Colors.red,
                                         ),

                                              width: MediaQuery.of(context).size.width/2.8,
                                              //height: 20,

                                              child:
                                              Center(
                                                child: Text(

                                                  reminder![index]["name"].toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'Mulish',
                                                      fontSize: 12,
                                                      color: Color(0xFF212121)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
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
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        location!,
                                        style:  TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF212121)),
                                      ),
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
                                      style:  TextStyle(
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
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        meetingurl!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color((0xFF212121)),
                                      ),
                                  ),
                                    ),
                                ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(color: Color(0xFFEBEBEB)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Tags",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left:25,right: 25,top: 0),
                                child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width/1.8 ,
                                //  height: 20,
                                  //color: Colors.pinkAccent,

                                  child:  Wrap(
                                    alignment: WrapAlignment.end,
                                    direction: Axis.horizontal, // Direction is horizontal
                                    spacing: 8.0, // Space between items
                                    runSpacing: 8.0, // Space between rows (if wrapping)
                                    children: List.generate(tags!.length ?? 0, (int index) {
                                      return InkWell(

                                        onTap: ()async{
                                          // var colors =   await getColors();
                                          //
                                          // int selectedtagId = tags![index]["id"];
                                          // showDialog(
                                          //   context: context,
                                          //   builder: (BuildContext context) => _buildColorPopupDialog(context,colors,selectedtagId),
                                          // ).then((value) => setState(() {
                                          //   tagChangeColoir == null? tags![index]["color"] = tags![index]["color"]:
                                          //   tags![index]["color"] =  tagChangeColoir;
                                          // }));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(30)),
                                            color:
                                            Color(int.parse(tags![index]["color"])),
                                          ),
                                          width: 79,
                                          height: 19,
                                          child: Center(
                                            child: Text(
                                              tags![index]["name"].toString(),
                                              style: TextStyle(

                                                  color: Colors.white,
                                                  fontFamily: 'Mulish',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 8),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
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
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        description!,
                                        style:  TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF212121)),
                                      ),
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
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Privacy",
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
                                    StringUtils.capitalize(privacy!),

                                    style:TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF212121)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Show as",
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
                                    StringUtils.capitalize(showas!),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF212121)),
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

      privacy = data['privacy']??"";
      showas = data['show_as']??"";

      data['alarm_ids'].length>0?
        reminder =data['alarm_ids']
          :reminder = [];


      data['categ_ids'].length>0?
      tags =data['categ_ids']
          :tags = [];

      print(reminder);
      print("reminderrrr");

      organizer=data['user_id']['name']??"";
      //reminder =data['alarm_ids']['name'].toString()??"";
      location=data['location'].toString()??"";
      meetingurl=data['videocall_location'].toString()??"";
      //tags
      description=data['description'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').toString()??"";



      _isInitialized = true;

    });


    //print(token);


  }
}

