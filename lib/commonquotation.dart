import 'package:crm_project/quotation_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'leadmainpage.dart';
import 'opportunity_detail.dart';

class QuotationList extends StatelessWidget {
  final dynamic id;
  final dynamic name;
  final dynamic amount;
  final dynamic quotationname;
  final dynamic date;
  final dynamic state;

  QuotationList(this.id,this.name,this.amount,this.quotationname, this.date , this.state);


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
              elevation: 1,
              child: Container(
                width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height/8.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15,top: 2),
                          child: Container(
                            width: MediaQuery.of(context).size.width/2,

                            child: Text(name,
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w600,

                                  fontSize: 14,
                                  color: Color(0xFF000000)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2,right: 40),
                          child: Text(amount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                color: Color(0xFF000000)),
                          ),
                        ),

                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        children: [

                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15,top: 0,bottom: 0),
                                child: Text(quotationname,
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Color(0xFF787878)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5,top:0,bottom:0),
                                child: Text(date,
                                  style:TextStyle(
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Color(0xFF787878)),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 0,bottom: 0),
                              //   child: IconButton(icon: SvgPicture.asset("images/clock.svg",),
                              //
                              //     onPressed: () {
                              //
                              //     },
                              //   ),
                              // ),

                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 88,right: 20,bottom: 5,top: 5),
                            child: Container(

                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF3D418E),
                                ),
                                // borderRadius: BorderRadius.all(Radius.circular(15)),
                                color: Color(0xFF3D418E),
                              ),
                              height: 21,
                              width: 84,

                              child: Center(
                                child: Text(state,
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w600,
                                    fontSize:12.16,
                                    color: Color(0xFFFFFFFF),

                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )

                  ],
                ),

              ),
            ),
            onTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuotationDetail(id)));


              print(id);
              print("check name");


            },
          )
        ],

      ),
    );
  }
}


