import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:crm_project/scrolling/opportunityscrolling.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'api.dart';
import 'drawer.dart';
import 'notification.dart';
import 'notificationactivity.dart';


class OpportunityMainPage extends StatefulWidget {
  var opportunityId;
  var similartype;
  var opportunityFrom;
  var filterItems;
  OpportunityMainPage(this.opportunityId,this.similartype,this.opportunityFrom,this.filterItems);


  @override
  State<OpportunityMainPage> createState() => _OpportunityMainPageState();
}

class _OpportunityMainPageState extends State<OpportunityMainPage> {

  bool _isInitialized = false;
  List opportunityTypes=[];
  int? opportunityTypesId;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    opportunityData();
  }

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
              Text("Opportunity", style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none),)
            ],
          ),
          // leading: Builder(
          //   builder: (context) =>
          //       Padding(
          //         padding: const EdgeInsets.only(left: 20),
          //         child: IconButton(icon: Image.asset("images/back.png"),
          //           onPressed: () {
          //
          //           },
          //         ),
          //       ),
          // ),
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
                  IconButton(onPressed:(){
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildFilterPopupDialog(context),
                    ).then((value) => setState(() {}));
                  },
                      icon:Icon(Icons.filter_alt_outlined,color: Colors.white,)),
                  //Icon(Icons.filter_alt_outlined,color: Colors.white,),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
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
        body: SafeArea(

             child:
              DefaultTabController(
                length: opportunityTypes.length,
                child: Column(
                  children: <Widget>[
                    ButtonsTabBar(
                      buttonMargin: const EdgeInsets.fromLTRB(10, 5, 2, 5),

                      contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      physics: BouncingScrollPhysics(),
                      backgroundColor: Colors.pinkAccent,
                      unselectedBackgroundColor: const Color(0XFFEDF2FF),
                      unselectedLabelStyle:
                      const TextStyle(color: Color(0XFF3C3F4E)),
                      labelStyle: const TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white, fontWeight: FontWeight.normal),
                      // tabs: const [
                      //   Tab(
                      //     text: "In Progress",
                      //   ),
                      //   Tab(
                      //     text: "Completed",
                      //   ),
                      //   Tab(
                      //     text: "Cancelled",
                      //   ),
                      // ],
                        onTap: (index){
                         print(opportunityTypes[index]['name']);
                         // setState(() {
                         //   // opportunityTypesId= opportunityTypes[index]['id'];
                         //  // opportunityTypesId= 4;
                         //  print(opportunityTypesId);
                         //    print("opportunityTypesId");
                         //
                         // });
                          },
                      tabs: List<Widget>.generate(
                        opportunityTypes.length,
                            (int index) {
                          BuildContext context;
                          print(opportunityTypes.length);

                          print("tabar name");
                          return Tab(
                            text: opportunityTypes[index]['name'],
                          );
                        },
                      ),


                    ),
                    Expanded(
                      child: TabBarView(
                       // controller: ,

                      children: List.generate(opportunityTypes.length, (index) =>

                          OpportunityScrolling(opportunityTypes[index]['id'],widget.opportunityId,widget.similartype,widget.opportunityFrom,widget.filterItems),),



                      ),
                    ),
                  ],
                ),
              ),

        ),
      );
    }
  }



 opportunityData() async {
  opportunityTypes = await getOpportunityTypes();
   print(opportunityTypes);
   print(opportunityTypes.length);
setState(() {
  opportunityTypesId = opportunityTypes[0]['id'];
  _isInitialized = true;
});

 }
  _buildFilterPopupDialog(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 550,left: 50),
        child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: InkWell(
              child: Container(
                //width: 40,
                child: Center(
                  child: Text(
                    "Lost",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,   fontFamily: 'Mulish',),
        ),
                ),
              ),
              onTap: (){

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            OpportunityMainPage(
                                null, "", "lost",
                                "[lost]")));


              },
            ),


        ),
      );
    });
  }


}
