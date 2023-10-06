import 'package:crm_project/customerdetail.dart';
import 'package:crm_project/quotation_detail.dart';
import 'package:flutter/material.dart';

import 'api.dart';
import 'leadmainpage.dart';

class CustomerList extends StatefulWidget {
  final dynamic id;
  final dynamic name;
  final dynamic jobposition;
  final dynamic state;
  final dynamic country;
  final dynamic email;
  final dynamic meetingcount;
  final dynamic opportunitycount;
  final dynamic customerimage;
  final dynamic parentname;

  CustomerList(this.id,this.name,this.jobposition,this.state, this.country , this.email,
      this.meetingcount,this.opportunitycount,this.customerimage,this.parentname);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
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
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Card(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height/8.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [


                          widget.customerimage !=""?

                          Padding(
                            padding: const EdgeInsets
                                .only(left: 15),
                            child: Container(

                              height: 80,
                              width:MediaQuery.of(context).size.width/5 ,


                              decoration: BoxDecoration(
                                //color: Colors.red,
                                border: Border.all(
                                ),
                                borderRadius: BorderRadius
                                    .all(
                                    Radius.circular(
                                        90)),

                              ),
                              child: ClipRRect(

                                borderRadius:
                                BorderRadius
                                    .circular(100),
                                child:Image.network("${widget.customerimage}?token=${token}"),


                              ),
                            ),
                          ):

                          Padding(
                            padding: const EdgeInsets
                                .only(left: 15),
                            child: Container(

                              height: 100,
                              width:MediaQuery.of(context).size.width/4 ,

                              decoration: BoxDecoration(
                                //  color: Colors.red,
                                border: Border.all(
                                ),
                                borderRadius: BorderRadius
                                    .all(
                                    Radius.circular(
                                        100)),

                              ),
                              child: ClipRRect(

                                borderRadius:
                                BorderRadius
                                    .circular(100),
                                child:Icon(Icons.person,size: 80,),


                              ),
                            ),
                          ),

                          // :Container(
                          //   height: 100,
                          //   width:MediaQuery.of(context).size.width/4 ,
                          //   color: Colors.red,
                          // ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15,top: 5),
                                child: Container(
                                  width:MediaQuery.of(context).size.width/1.6,
                                  child: Text(widget.name,
                                    style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15,top: 4),
                                child: Visibility(
                                  visible: widget.jobposition==""?false:true,
                                  child: Container(
                                    width:MediaQuery.of(context).size.width/1.6,
                                    child: Text(widget.jobposition,
                                      style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Color(0xFF787878)),
                                    ),
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Visibility(
                                    visible:widget.state == ""?false:true ,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15,top: 4),
                                      child: Text(widget.state,
                                        style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFF787878)),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:widget.country ==""?false:true ,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15,top: 4),
                                      child: Text(widget.country,
                                        style:  TextStyle(
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFF787878)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible:widget.email==""?false:true ,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15,top: 4),
                                  child: Text(widget.email,
                                    style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Color(0xFF787878)),
                                  ),
                                ),
                              ),

                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15,top: 8,bottom: 5),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Image
                                              .asset(
                                            "images/calendar.png",
                                            color: Colors.black,width: 20,),


                                          Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text(
                                                  widget.meetingcount,
                                                  style: TextStyle(

                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'Mulish',
                                                      fontSize: 10.26,
                                                      color: Color(0xFF000000)),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Image
                                              .asset(
                                              "images/star2.png",
                                            color: Colors.black,width: 20,),


                                          Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: Text(
                                                  widget.opportunitycount,
                                                  style: TextStyle(
                                                      fontFamily: 'Mulish',
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 10.26,
                                                      color: Color(0xFF000000)),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),


                        ],
                      ),


                    ],
                  ),

                ),
              ),
            ),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomerDetail(widget.id)));


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

