import 'dart:convert';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:crm_project/scrolling/opportunityscrolling.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'api.dart';
import 'drawer.dart';


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
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
                  onPressed: () {

                    Scaffold.of(context).openDrawer();
                  },
                ),
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


}
