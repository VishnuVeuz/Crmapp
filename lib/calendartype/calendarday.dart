import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../api.dart';
import '../calendarcreate.dart';
import '../calendardetail.dart';
import '../calendarmainpage.dart';
import '../model/calendarmodel.dart';

class CalendarDay extends StatefulWidget {
  var calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;

  CalendarDay(this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData);


  @override
  State<CalendarDay> createState() => _CalendarDayState();
}

class _CalendarDayState extends State<CalendarDay> {



  var calendarName;
  var calendarStart;
  var calendarStop;
  var calendarDuration;
  late int calendarId;


  List<Calenders> calendersDetailss = [];
  Calenders? calendersvalueData;

  // late var _calendarDataSource;




  @override
  void initState() {

    super.initState();

    calendarData();

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {

            return false;
          },
          child: SfCalendar(
            view: CalendarView.day,
            initialDisplayDate:widget.dateTimes,
           onTap: calendarTapped,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          ),
        ));
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      Meeting? appointment = calendarTapDetails.appointments![0];
      print("demo data pass");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondRoute(appointment:appointment)),
      );
    }
  }







  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    DateTime today1;
    DateTime today2;
    var minutess;
    print(today);
    print("today");

    if(widget.calendarData.length>0){
      for (int i = 0; i < widget.calendarData.length; i++) {
        today1 = DateTime.parse(widget.calendarData[i]['start']);
        minutess = double.parse(widget.calendarData[i]['duration'].toString());
        today2 = DateTime.parse(widget.calendarData[i]['stop']);


        print(minutess);

        print(today1);
        print("vishnuDemo");
        print(today1.year);
        print(today1.month);
        print(today1.day);

        final DateTime startTime =
        DateTime(
            today1.year, today1.month, today1.day, today1.hour, today1.minute,
            0);
        final DateTime endTime = DateTime(
            today2.year, today2.month, today2.day, today2.hour, today2.minute,
            0);

        //final DateTime endTime = startTime.add( Duration(minutes: minutess));
        meetings.add(Meeting(widget.calendarData[i]['id'],
            widget.calendarData[i]['name'], startTime, endTime,
            const Color(0xFF0F8644), false));
      }
    }

    else {
      for (int i = 0; i < calendersDetailss.length; i++) {
        today1 = DateTime.parse(calendersDetailss[i].starttime);
        minutess = double.parse(calendersDetailss[i].durations);
        today2 = DateTime.parse(calendersDetailss[i].stoptime);


        print(minutess);

        print(today1);
        print("vishnuDemo");
        print(today1.year);
        print(today1.month);
        print(today1.day);

        final DateTime startTime =
        DateTime(
            today1.year, today1.month, today1.day, today1.hour, today1.minute,
            0);
        final DateTime endTime = DateTime(
            today2.year, today2.month, today2.day, today2.hour, today2.minute,
            0);

        //final DateTime endTime = startTime.add( Duration(minutes: minutess));
        meetings.add(Meeting(calendersDetailss[i].id,
            calendersDetailss[i].name, startTime, endTime,
            const Color(0xFF0F8644), false));
      }
    }



    return meetings;
  }

  void calendarData() async{

    calendersDetailss = await getCalenders();
    setState(() {

    });
    print(calendersDetailss);
    print("calendersDetailss");


  }
}



class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.id,this.eventName, this.from, this.to, this.background, this.isAllDay);
  int id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}



class SecondRoute extends StatelessWidget {
  Meeting? appointment;

  SecondRoute({super.key, this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Text(
              appointment!.eventName,
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
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 20),
            child: IconButton(
              icon: Image.asset("images/back.png"),
              onPressed: () {},
            ),
          ),
        ),
        automaticallyImplyLeading: false,

      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 25),
                  child: ElevatedButton(
                      onPressed: () {


                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => CalendarAdd(appointment!.id)));
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Icon(Icons.camera),
                          Text('Edit',),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF04254),
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20),
                  child: ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () async {

                      var data =  await deleteCalendarData(appointment!.id);


                      if(data['message']=="Success") {
                        print("responce");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Calender(null,"",DateTime.now(),null,[])),);
                      }

                    },
                      child: Row(
                        children: [
                          Text('Delete',style: TextStyle(color: Colors.black),),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFFFFFF),
                      )
                  ),
                ),

              ],
            ),
            const Divider(color: Colors.white,),
            // Text(
            //   appointment!.id.toString(),
            // ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20,left: 25),
                child: Row(
                  children: [
                    Text("Meeting Subject:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        appointment!.eventName,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25,right: 24,),
              child: Divider(color: Color(0xFFE6E3E3),),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Row(
                  children: [
                    Text("Starting at:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          DateFormat('MMMM yyyy,hh:mm a').format(appointment!.from,).toString()),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25,right: 24,),
              child: Divider(color: Color(0xFFE6E3E3),),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text("  Ending at:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                          DateFormat('MMMM yyyy,hh:mm a').format(appointment!.to,).toString()),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25,right: 24,),
              child: Divider(color: Color(0xFFE6E3E3),),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text("  Privacy",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('Public'
                          ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 25,right: 24,),
              child: Divider(color: Color(0xFFE6E3E3),),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Row(
                  children: [
                    Text("  Organizer",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text('organizer'
                        ),
                    ),
                  ],
                ),
              ),
            ),







          ],
        ),
      ),


    );
  }
}



