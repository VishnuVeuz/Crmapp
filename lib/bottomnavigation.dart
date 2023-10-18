
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'opportunitymainpage.dart';
import 'scrolling/scrollpagination.dart';

class MyBottomNavigationBar extends StatefulWidget {
  int indexvalue;

  MyBottomNavigationBar(this.indexvalue);
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int? currentIndex;
  //int? currentIndex1;// Add this variable to keep track of the current index

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex= widget.indexvalue;
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: IconThemeData(color: Colors.pinkAccent),
      selectedLabelStyle: TextStyle(
          fontSize: 12, fontFamily: 'Mulish', color: Color(0xFFF9246A), fontWeight: FontWeight.w300),
      unselectedLabelStyle: TextStyle(
          fontSize: 12, fontFamily: 'Mulish', color: Colors.black, fontWeight: FontWeight.w300),
      currentIndex: currentIndex==null?0:currentIndex!,
      // Set the currentIndex
      onTap: (int index) {
        setState(() {

          currentIndex = index;// Update the currentIndex when a tab is tapped
        });

        if (index == 0) {
// Handle the first tab
        } else if (index == 1) {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LeadScrolling('', "", "")));
        } else if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpportunityMainPage(null, "", "", "", "")));
        } else if (index == 3) {
          Scaffold.of(context).openDrawer();
        }
      },
      items: [
        currentIndex==0?
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/hoColor.svg"),
          label: 'Home',
        ):
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/ho.svg"),
          label: 'Home',
        ),

        currentIndex==1?
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/leadColor.svg"),
          label: 'Leads',
        ):
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/leadd.svg"),
          label: 'Leads',
        ),

        currentIndex==2?
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/oppoColor.svg"),
          label: 'Opportunity',
        ):
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/oppo.svg"),
          label: 'Opportunity',
        ),

        currentIndex==3?
        BottomNavigationBarItem(
          icon: SvgPicture.asset("images/moColor.svg"),
          label: 'More',
        ):
        BottomNavigationBarItem(
          icon: Container(
            width: 20,
              height: 20,
              child: SvgPicture.asset("images/mo.svg")),
          label: 'More',
        ),
      ],
      selectedItemColor: Color(0xFFF9246A),


      unselectedItemColor: Colors.black,
    );
  }
}




// import 'package:crm_project/scrolling/scrollpagination.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import 'opportunitymainpage.dart';
//
//
//
//  //int  currentIndex =0;
// Widget bottomNavigationBar(context){
//    return BottomNavigationBar(
//      type: BottomNavigationBarType.fixed,
//
//      selectedIconTheme: IconThemeData(color: Colors.pinkAccent),
//     // selectedItemColor: Color(0xFFF9246A),
//
//      selectedLabelStyle: TextStyle(
//          fontSize: 14,fontFamily: 'Mulish',color: Color(0xFFF9246A),fontWeight: FontWeight.w600
//      ),
//      unselectedLabelStyle: TextStyle(
//          fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600
//      ),
//
//      onTap: (int index){
//    // setState(() {
//    //   currentIndex = index;
//    // });
//
//            if(index==0){
//
//            }
//            else if(index==1){
//
//              Navigator.push(context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          LeadScrolling(
//                              '', "",
//                              "")));
//
//            }
//            else if (index==2) {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          OpportunityMainPage(
//                              null, "", "",
//                              "", "")));
//            }
//            else if(index==3){
//              Scaffold.of(context).openDrawer();
//            }
//      },
//      items: [
//        BottomNavigationBarItem(
//          icon: SvgPicture.asset("images/ho.svg"),
//          label: 'Home',
//        ),
//        BottomNavigationBarItem(
//          icon: SvgPicture.asset("images/leadd.svg"),
//          label: 'Leads',
//        ),
//        BottomNavigationBarItem(
//          icon: SvgPicture.asset("images/oppo.svg"),
//          label: 'Opportunity',
//        ),
//        BottomNavigationBarItem(
//          icon: SvgPicture.asset("images/mo.svg"),
//          label: 'More',
//        ),
//      ],
//      selectedItemColor: Colors.amber[800],
//    );
//    //   Container(
//    //   height: 65,
//    //   decoration: BoxDecoration(
//    //     border: Border.all(
//    //       width: 1,
//    //       color: Colors.grey
//    //     )
//    //   ),
//    // );
//
//  }
//
//
// // void setState(Null Function() param0) {
// // }
//