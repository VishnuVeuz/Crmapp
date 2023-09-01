import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../api.dart';
import '../model/calendarmodel.dart';

class CalendarMobth extends StatefulWidget {
  var calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;

  CalendarMobth(this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData);

  @override
  State<CalendarMobth> createState() => _CalendarMobthState();
}

class _CalendarMobthState extends State<CalendarMobth> {



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
            view: CalendarView.month,
            initialDisplayDate:widget.dateTimes,
            //onTap: calendarTapped,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
          ),
        ));
  }

  // void calendarTapped(CalendarTapDetails calendarTapDetails) {
  //   print("demo data pass2");
  //   if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
  //     Meeting? appointment = calendarTapDetails.appointments![0];
  //     print("demo data pass1");
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




//
// class SecondRoute extends StatelessWidget {
//   Meeting? appointment;
//
//   SecondRoute({super.key, this.appointment});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).primaryColor,
//
//
//         title: const Text("Back"),
//       ),
//       body:
//
//
//
//
//
//
//
//       Container(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 25),
//           child: Column(
//             //crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 //color: Colors.green,
//                 child: Row(
//                   //mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20),
//                       child: ElevatedButton(
//
//                         //if user click this button. user can upload image from camera
//
//                           onPressed: () {
//
//
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => CalendarEdit(appointment!.id)));
//                           },
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               // Icon(Icons.camera),
//                               Text('Edit',),
//                             ],
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             primary: Color(0xFFF04254),
//                           )
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 20,left: 20),
//                       child: ElevatedButton(
//                         //if user click this button. user can upload image from camera
//
//                           onPressed: () async{
//                             int calendarId =   appointment!.id;
//
//                             String delCalendar =  await deleteCalendar(calendarId);
//                             if (delCalendar == "success") {
//
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => Calender(0,"",DateTime.now(),[])),
//                               );
//                             }
//
//
//                           },
//                           child: Row(
//                             children: [
//                               // Icon(Icons.camera),
//                               Text('Discard',style: TextStyle(color: Colors.black),),
//                             ],
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             primary: Color(0xFFFFFFFF),
//                           )
//                       ),
//                     ),
//
//                   ],
//                 ),
//               ),
//               const Divider(color: Colors.white,),
//               // Text(
//               //   appointment!.id.toString(),
//               // ),
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20,),
//                   child: Row(
//                     children: [
//                       Text("Meeting Subject:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 20),
//                         child: Text(
//                           appointment!.eventName,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.only(left: 25,right: 24,),
//                 child: Divider(color: Color(0xFFE6E3E3),),
//               ),
//               Center(
//                 child: Row(
//                   children: [
//                     Text("Starting at:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Text(
//                           DateFormat('MMMM yyyy,hh:mm a').format(appointment!.from,).toString()),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 25,right: 24,),
//                 child: Divider(color: Color(0xFFE6E3E3),),
//               ),
//               Center(
//                 child: Row(
//                   children: [
//                     Text("  Ending at:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Text(
//                           DateFormat('MMMM yyyy,hh:mm a').format(appointment!.to,).toString()),
//                     ),
//                   ],
//                 ),
//               ),
//
//
//
//
//
//
//             ],
//           ),
//         ),
//       ),
//
//
//     );
//   }
// }
//
//

