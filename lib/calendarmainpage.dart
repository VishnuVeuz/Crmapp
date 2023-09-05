import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'calendarcreate.dart';
import 'calendartype/calendarday.dart';
import 'calendartype/calendarmonth.dart';
import 'calendartype/calendarweek.dart';
import 'calendartype/calendaryear.dart';
import 'drawer.dart';

class Calender extends StatelessWidget {

  var calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;

  Calender(this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData);


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
            return   Padding(
              padding: const EdgeInsets.only(top:20,right: 20),
              child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
                onPressed: () {
                  //print("testapp3");
                  Scaffold.of(context).openDrawer();
                },


              ),
            );
          })








        ],

      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
              children: [

                Container(
                  width: 450,
                  height: 60,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //  DateTime now = DateTime.now();

                      Padding(
                        padding: const EdgeInsets.only(left:34),
                        child: Text(DateTime.now().toString(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Color(0xFF292929)),),
                      ),



                    ],),

                ),
                Divider(color: Color(0xFFEBEBEB),),
                Padding(
                  padding: const EdgeInsets.only(right: 260),
                  child: Container(
                    width: 80,
                    height: 30,
                    //alignment: Alignment.topLeft,
                    color: Colors.pinkAccent,
                    child: TextButton(onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarAdd(0,calendarTypeId,calendarmodel,dateTimes,activityDataId,[])));


                    },

                      child: Text("Add",style: TextStyle(color: Colors.white),),

                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40),
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
                                  unselectedLabelStyle: TextStyle(color: Color(0xFF017E82)),
                                  labelStyle:
                                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700,fontSize: 13,),
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
    );
  }
}

