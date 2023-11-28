import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:crm_project/scrolling/opportunityscrolling.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';


import 'api.dart';
import 'bottomnavigation.dart';
import 'drawer.dart';
import 'globals.dart';
import 'notification.dart';
import 'notificationactivity.dart';
import 'globals.dart' as globals;


class OpportunityMainPage extends StatefulWidget {
  var opportunityId;
  var similartype;
  var opportunityFrom;
  var filterItems;
  String fromCustomer;
  OpportunityMainPage(this.opportunityId,this.similartype,this.opportunityFrom,this.filterItems,this.fromCustomer);


  @override
  State<OpportunityMainPage> createState() => _OpportunityMainPageState();
}

class _OpportunityMainPageState extends State<OpportunityMainPage> {
  String notificationCount="0";
  String  messageCount ="0";
  bool _isInitialized = false;
  List opportunityTypes=[];
  int? opportunityTypesId;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyData();
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
        bottomNavigationBar:MyBottomNavigationBar(2),
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
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text("Opportunity", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    color: Colors.white,
                    decoration: TextDecoration.none),),
              )
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
                       backgroundColor: Color(0xFF043565),


                      unselectedBorderColor: Colors.transparent,
                      unselectedBackgroundColor: const Color(0XFFEDF2FF),


                      unselectedLabelStyle:
                      const TextStyle(color: Color(0XFF3C3F4E)),
                      labelStyle: const TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.white, fontWeight: FontWeight.normal),



                        onTap: (index){
                         print(opportunityTypes[index]['name']);

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

                          OpportunityScrolling(opportunityTypes[index]['id'],widget.opportunityId,widget.similartype,widget.opportunityFrom,widget.filterItems,widget.fromCustomer),),



                      ),
                    ),
                  ],
                ),
              ),

        ),
        bottomNavigationBar:MyBottomNavigationBar(2),
      );
    }
  }



 opportunityData() async {
   var notificationMessage  = await getNotificationCount();

   notificationCount = notificationMessage['activity_count'].toString();

   messageCount = notificationMessage['message_count'].toString();
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
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: InkWell(
              child: Container(
               // width: 30,
                 //color: Colors.red,
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
                                "[lost]","")));


              },
            ),


        ),
      );
    });
  }

  companyData() async {

    // token = await getUserJwt();
    // print(token);
    print("token12121313");

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

    String responce1 = await getSingleSelectedUserCompanyData();
    globals.selectedCompanyIds = responce1;
    print(globals.selectedCompanyIds);
    print("globals.selectedCompanyIds3");
    //

    setState(() {
      _isInitialized = true;
    });

  }


}
