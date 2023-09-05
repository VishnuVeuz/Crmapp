import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'api.dart';
import 'lead_detail.dart';
import 'leadmainpage.dart';
import 'opportunity_detail.dart';

class CommonOpportunity extends StatefulWidget {
  final dynamic id;
  final dynamic name;
  final dynamic contactname;
  final dynamic priority;
  final dynamic tags;
  final dynamic leadimg;

  CommonOpportunity(this.id,this.name, this.contactname,this.priority, this.tags, this.leadimg);

  @override
  State<CommonOpportunity> createState() => _CommonOpportunityState();
}

class _CommonOpportunityState extends State<CommonOpportunity> {

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tokendata();
  }
 String? token;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LeadMainPage()));
        return true;
      },
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Card(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/8.5,
//color: Colors.green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15),
                      child: Text(widget.name,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 15),
                      child: Text(widget.contactname,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Color(0xFF787878)),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: RatingBar.builder(
                            initialRating: double.parse(widget.priority),
                            itemSize: 19,
                            minRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 3,
                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 10,
                            ), onRatingUpdate: (double value) {

                          },

                          ),
                        ),


                        widget.leadimg!=""?
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 25),
                        //   child: Container(
                        //     width:35,
                        //     height:35,
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //         ),
                        //         borderRadius: BorderRadius.all(Radius.circular(20))
                        //     ),
                        //     child: CircleAvatar(
                        //       radius: 12,
                        //       child: ClipRRect(
                        //
                        //         borderRadius:
                        //         BorderRadius
                        //             .circular(18),
                        //         child: Image.memory(
                        //           base64Decode(leadimg),
                        //           fit: BoxFit.cover,
                        //           width: MediaQuery.of(
                        //               context)
                        //               .size
                        //               .width,
                        //           height: 300,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
                        //     :

                        Padding(
                          padding: const EdgeInsets
                              .only(right: 25),
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                ),
                                borderRadius: BorderRadius
                                    .all(
                                    Radius.circular(
                                        20))
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              child: ClipRRect(

                                borderRadius:
                                BorderRadius
                                    .circular(18),
                                child:Image.network("${widget.leadimg}?token=${token}"),

                              ),


                            ),
                          ),
                        ) :
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Container(
                            width:35,
                            height:35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              child: Icon(
                                Icons.person,
                                size: 20,
                                // Adjust the size of the icon as per your requirements
                                color: Colors
                                    .white, // Adjust the color of the icon as per your requirements
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),



                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10,left: 15),
                    //   child: Text(contactname,
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 12,
                    //         color: Color(0xFF787878)),
                    //   ),
                    // ),
                  ],
                ),

                //color: Colors.green,
              ),
            ),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OpportunityDetail(widget.id)));


              print(widget.id);
              print("check name");


            },
          )
        ],

      ),
    );
  }


 void tokendata() async{

   token = await getUserJwt();

   setState(() {

   });
 }

}
