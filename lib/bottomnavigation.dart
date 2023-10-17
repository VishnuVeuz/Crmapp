import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'opportunitymainpage.dart';

 Widget bottomNavigationBar(context){
   return BottomNavigationBar(
     type: BottomNavigationBarType.fixed,
     selectedItemColor: Color(0xFFF9246A),
     selectedLabelStyle: TextStyle(
         fontSize: 14,fontFamily: 'Mulish',color: Color(0xFFF9246A),fontWeight: FontWeight.w600
     ),
     unselectedLabelStyle: TextStyle(
         fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600
     ),
     onTap: (int index){
           if(index==0){
             // Navigator.push(context,
             //     MaterialPageRoute(
             //         builder: (context) =>
             //             LeadScrolling(
             //                 '', "notification",
             //                 "[assigned_to_me]")));
           }
           else if(index==1){
             Navigator.push(context,
                 MaterialPageRoute(
                     builder: (context) =>
                         LeadScrolling(
                             '', "",
                             "")));

           }
           else if (index==2) {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>
                         OpportunityMainPage(
                             null, "", "",
                             "", "")));
           }
           else if(index==3){
             Scaffold.of(context).openDrawer();
           }
     },
     items: [
       BottomNavigationBarItem(
         icon: SvgPicture.asset("images/ho.svg"),
         label: 'Home',
       ),
       BottomNavigationBarItem(
         icon: SvgPicture.asset("images/lead.svg"),
         label: 'Leads',
       ),
       BottomNavigationBarItem(
         icon: SvgPicture.asset("images/oppo.svg"),
         label: 'Opportunity',
       ),
       BottomNavigationBarItem(
         icon: SvgPicture.asset("images/mo.svg"),
         label: 'More',
       ),
     ],
   );
   //   Container(
   //   height: 65,
   //   decoration: BoxDecoration(
   //     border: Border.all(
   //       width: 1,
   //       color: Colors.grey
   //     )
   //   ),
   // );

 }