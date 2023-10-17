import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'calendarcreate.dart';
import 'calendartype/calendarday.dart';
import 'calendartype/calendarmonth.dart';
import 'calendartype/calendarweek.dart';
import 'calendartype/calendaryear.dart';
import 'drawer.dart';
import 'globals.dart';
import 'leadmainpage.dart';

class Calender extends StatelessWidget {

  var calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;
  String scheduleSummary;

  Calender(this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData,this.scheduleSummary);


  int tabIndex=0;
  @override
  Widget build(BuildContext context) {

    print(calendarTypeId);
    print(calendarmodel);
    print(dateTimes);
    print(calendarData);
    print("calendar data");


    if(calendarData.length>1){
      tabIndex = 2;
    }



    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,

        elevation: 0,

        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Calendar",
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ),

          ],
        ),
        // leading: Builder(
        //     builder: (context) => Padding(
        //       padding: const EdgeInsets.only(top: 10, left: 20),
        //       child: IconButton(
        //         icon: Image.asset("images/back.png"),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //       ),
        //     )
        //   // IconButton(
        //   //   icon: Image.asset("images/man2.png"),
        //   //   onPressed: () {},
        //   // ),
        // ),



        //backgroundColor: Color(0xFF3D418E),
        automaticallyImplyLeading: false,
        actions: [

          Builder(builder: (context) {
            return   Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20,right: 20),
                  child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
                    onPressed: () {
                      //print("testapp3");
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
        onWillPop: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => LeadMainPage()));
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: 450,
                    height: 50,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //  DateTime now = DateTime.now();

                        Padding(
                          padding: const EdgeInsets.only(left:22),
                          child: Text(DateTime.now().toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color(0xFF292929),fontFamily: 'Mulish',),),
                        ),



                      ],),

                  ),
                 // Divider(color: Color(0xFFEBEBEB),),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Container(
                      width: 80,
                      height: 30,
                      //alignment: Alignment.topLeft,
                      color: Color(0xFFF9246A),
                      child: TextButton(onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarAdd(0,calendarTypeId,calendarmodel,dateTimes,activityDataId,[],scheduleSummary)));


                      },
                        // style: TextButton.styleFrom(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        // ),

                        child: Text("Add",style: TextStyle(color: Colors.white,fontFamily: 'Mulish',),),

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: 680,
                      color: Colors.white,
                      child: DefaultTabController(
                        initialIndex: tabIndex,
                        length:4  ,
                        child:
                        Column(
                          children: <Widget>[

                            Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(right: 150),
                                  child: ButtonsTabBar(

                                    //backgroundColor: Colors.grey,
                                    //elevation: 0,


                                    unselectedBackgroundColor: Colors.white,
                                    unselectedLabelStyle: TextStyle(color: Color(0xFF017E82),fontFamily: 'Mulish'),
                                    labelStyle:
                                    TextStyle(color: Colors.black, fontWeight: FontWeight.w700,fontSize: 13,fontFamily: 'Mulish'),
                                    tabs: const [
                                      Tab(text: "DAY"),
                                      Tab(text: "WEEK",),
                                      Tab( text: "MONTH",),
                                      Tab( text: "YEAR",),

                                    ],
                                  ),
                                ),

                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: <Widget>[
                                  Center(
                                    child: CalendarDay(calendarTypeId,calendarmodel,dateTimes,activityDataId,[]),
                                  ),
                                  Center(
                                    child: CalendarWeek(calendarTypeId,calendarmodel,dateTimes,activityDataId,[]),
                                  ),
                                  Center(
                                    child: CalendarMobth(calendarTypeId,calendarmodel,dateTimes,activityDataId,[]),
                                  ),
                                  Center(
                                    child: CalendarYear(calendarTypeId,calendarmodel,dateTimes,activityDataId,[]),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


