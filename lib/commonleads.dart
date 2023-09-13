import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import 'api.dart';
import 'drawer.dart';
import 'lead_detail.dart';
import 'leadmainpage.dart';

class LeadListviewCommon extends StatefulWidget {
  final dynamic id;
  final dynamic name;
  final dynamic contactname;
  final dynamic priority;
  final dynamic tags;
  final dynamic leadimg;

  LeadListviewCommon(this.id,this.name, this.contactname,this.priority, this.tags, this.leadimg);

  @override
  State<LeadListviewCommon> createState() => _LeadListviewCommonState();
}

class _LeadListviewCommonState extends State<LeadListviewCommon> {

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
               // height: MediaQuery.of(context).size.height/8.5,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,top: 8),
                      child: Text(widget.name,
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ),
                    Visibility(
                      visible:widget.contactname==""?false:true ,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5,left: 15),
                        child: Text(widget.contactname,
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Color(0xFF787878)),
                        ),
                      ),
                    ),




                    Visibility(
                      visible: widget.tags!.length >0 ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width/1.1 ,
                          height: 20,
                          //color: Colors.pinkAccent,

                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: widget.tags!.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                const EdgeInsets.only(right: 8.0, top: 4),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,

                                  child: Row(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 5,
                                        color:Colors.red,

                                      ),
                                      SizedBox(width: 4,),

                                      Center(
                                        child: Text(

                                          widget.tags![index]["name"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Mulish',
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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


                        Padding(
                          padding: const EdgeInsets
                              .only(right: 25,bottom: 8),
                          child: Container(
                            width: 25,
                            height: 25,
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
                          padding: const EdgeInsets.only(right: 25,bottom: 8),
                          child: Container(
                            width:25,
                            height:25,
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




                  ],
                ),

                //color: Colors.green,
              ),
            ),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeadDetail(widget.id)));


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

