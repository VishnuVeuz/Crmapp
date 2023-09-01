import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../calendarmainpage.dart';

class CalendarYear extends StatefulWidget {
  var calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;

  CalendarYear(this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData);


  @override
  State<CalendarYear> createState() => _CalendarYearState();
}

class _CalendarYearState extends State<CalendarYear> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: TableCalendar(
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            print(selectedDay);
            print("elected dayaaa");


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Calender(null,"",selectedDay,null,[])));

          });
        },

        firstDay: DateTime.utc(2010, 10, 20),
        lastDay: DateTime.utc(2040, 10, 20),
        focusedDay: DateTime.now(),
        headerVisible: true,
        daysOfWeekVisible: true,
        sixWeekMonthsEnforced: true,
        shouldFillViewport: false,
        headerStyle: HeaderStyle(titleTextStyle: TextStyle(
            fontSize: 20, color: Colors.deepPurple, fontWeight: FontWeight.w800)),
        calendarStyle: CalendarStyle(todayTextStyle: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}