import 'package:crm_project/quotation_detail.dart';
import 'package:flutter/material.dart';

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
                          padding: const EdgeInsets.only(left: 15,top: 15),
                          child: Text(name,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15,right: 20),
                          child: Text(amount.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),

                      ],
                    ),
                    Row(
                      children: [

                        Container(
                          //width: 230,
                         // color: Colors.green,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15,top: 15),
                                child: Text(quotationname,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15,top: 15),
                                child: Text(date,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80,right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF3D418E),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Color(0xFF3D418E),
                            ),
                            height: 20,
                            width: 60,

                            child: Center(
                              child: Text(state,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 9,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                      ],
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

