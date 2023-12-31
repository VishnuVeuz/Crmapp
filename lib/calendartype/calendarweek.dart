import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../api.dart';
import '../model/calendarmodel.dart';

class CalendarWeek extends StatefulWidget {
  var calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;

  CalendarWeek(this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData);

  @override
  State<CalendarWeek> createState() => _CalendarWeekState();
}

class _CalendarWeekState extends State<CalendarWeek> {



  List<Calenders> calendersDetailss = [];


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
            view: CalendarView.week,

           // onTap: calendarTapped,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          ),
        ));
  }

  // void calendarTapped(CalendarTapDetails calendarTapDetails) {
  //   if (calendarTapDetails.targetElement == CalendarElement.appointment) {
  //     Meeting? appointment = calendarTapDetails.appointments![0];
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => SecondRoute(appointment:appointment)),
  //     );
  //   }
  // }






  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    DateTime today1;
    DateTime today2;
    var minutess;
    print(today);
    print("today");

    for(int i =0;i< calendersDetailss.length;i++)
    {
      today1 =  DateTime.parse(calendersDetailss[i].starttime);
      minutess = double.parse(calendersDetailss[i].durations);
      today2 = DateTime.parse(calendersDetailss[i].stoptime);


      print(minutess);

      print(today1);
      print("vishnuDemo");
      print(today1.year);
      print(today1.month);
      print(today1.day);

      final DateTime startTime =
      DateTime(today1.year, today1.month, today1.day, today1.hour, today1.minute, 0);
      final DateTime endTime = DateTime(today2.year, today2.month, today2.day, today2.hour, today2.minute, 0);

      //final DateTime endTime = startTime.add( Duration(minutes: minutess));
      meetings.add(Meeting(calendersDetailss[i].id,
          calendersDetailss[i].name , startTime, endTime, const Color(0xFF0F8644), false));

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






