import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'api.dart';
import 'customerdetail.dart';
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
  String fromCustomer;
  int custId;

  CommonOpportunity(this.id,this.name, this.contactname,this.priority, this.tags, this.leadimg,this.fromCustomer,this.custId);

  @override
  State<CommonOpportunity> createState() => _CommonOpportunityState();
}

class _CommonOpportunityState extends State<CommonOpportunity> {



 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.custId);
    print("demoooootesttttdemoooo");

    tokendata();
  }
 String? token;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.fromCustomer == "customer" ?
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CustomerDetail(widget.custId))):

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
              //  height: MediaQuery.of(context).size.height/8.5,
//color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20,top: 8),
                          child: Text(widget.name,
                            style: TextStyle(
                                fontFamily: 'Proxima Nova',
                                // wordSpacing: 5,
                                fontWeight: FontWeight
                                    .w500,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        Visibility(
                          visible: widget.contactname == ""?false:true,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,left: 20),
                            child: Text(widget.contactname,
                              style: TextStyle(
                                  fontFamily: 'Proxima Nova',
                                  fontWeight: FontWeight
                                      .w500,
                                  fontSize: 12,
                                  color: Color(0xFF787878)),
                            ),
                          ),
                        ),


                        Visibility(
                          visible: widget.tags!.length >0 ? true : false,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 21),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width/1.4 ,
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
                                            height: 8,
                                            width: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:  Color(int.parse(widget.tags![index]["color"])),),

                                            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),

                                          ),

                                          SizedBox(width: 4,),

                                          Center(
                                            child: Text(

                                              widget.tags![index]["name"].toString(),
                                              style: TextStyle(
                                                  color: Color(0xFF787878),
                                                  fontFamily: 'Proxima Nova',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12),
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
                              padding: const EdgeInsets.only(left: 15,bottom: 8,top: 2),
                              child: Container(
                                width: MediaQuery.of(context).size.width/1.23,

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




                  ],
                ),

                //color: Colors.green,
              ),
            ),
            onTap: (){
              print("common op");
              // Navigator.of(context).push(
              //     MaterialPageRoute(builder: (context) =>  OpportunityDetail(widget.id)));
              //

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

