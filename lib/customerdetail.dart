import 'dart:convert';

import 'package:crm_project/customercreation.dart';
import 'package:crm_project/scrolling/customerscrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'notificationactivity.dart';
import 'api.dart';
import 'calendarmainpage.dart';
import 'drawer.dart';
import 'notification.dart';
import 'opportunitymainpage.dart';

class CustomerDetail extends StatefulWidget {
  var customerId;
  CustomerDetail(this.customerId);

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  String? customername,
      taxid,
      jobposition,
      mobile,
      customerrank,
      supplierrank,
      email,
      website,
      title,
      tags,
      salesperson,
      paymentterms,
      fiscalposition,
      reference,
      company,
      internalnotes;

  bool _isInitialized = false;
  int? company_type,meetingCount,opportunityCount;
  bool? customerType;
  String? radioInput,customerImage,token;
  List addNewCustomer = [];
  Map<String, dynamic>? addNewCustomerData;
  List? tagss=[];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerDetails();
  }

  Widget build(BuildContext context) {
    int? _selectedOption = company_type;

    if (!_isInitialized) {
      // Show a loading indicator or any other placeholder widget while waiting for initialization
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width/4,
                child: Text(
                  customername!,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                icon: Image.asset("images/back.png"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
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
                            bottom: 25,
                            right: 28,

                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Color(0xFFFA256B),
                              ),
                              child: Center(child: Text("12",style: TextStyle(color: Colors.white,fontSize: 8),)),
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
                            bottom: 25,
                            right: 28,

                            child: Container(
                              width: 15.0,
                              height: 15.0,
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Color(0xFFFA256B),
                              ),
                              child: Center(child: Text("12",style: TextStyle(color: Colors.white,fontSize: 8),)),
                            ),
                          ),
                        ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                      onPressed: () {

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: SvgPicture.asset("images/drawer.svg"),
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
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [

                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>CustomerCreation(0) ));

                            },
                            child: SvgPicture
                                .asset(
                              "images/create.svg",width: 28,height: 28,),
                          ),



                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Create",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),
                      Column(
                        children: [


                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerCreation(widget.customerId)));

                            },
                            child: SvgPicture
                                .asset(
                              "images/edit.svg",width: 28,height: 28,),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Edit",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: ()async{
                              print(widget.customerId);
                              var data =
                                  await deleteCustomerData(widget.customerId);

                              if (data['message'] == "Success") {
                                print("responce");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerScrolling("","")),
                                );
                              }

                            },
                            child: SvgPicture
                                .asset(
                              "images/delete.svg",width: 28,height: 28,),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Delete",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),
                      Column(
                        children: [

                          InkWell(
                            onTap: ()async{
                              var data = await getCustomerData(
                                  widget.customerId, "duplicate");
                              String resMessageText;
                              print(data['message'].toString());
                              if (data['message'].toString() == "success") {
                                resMessageText = data['data']['id'].toString();
                                print(resMessageText);

                                int resmessagevalue = int.parse(resMessageText);
                                if (resmessagevalue != 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        CustomerCreation(resmessagevalue)),);
                                }
                              }
                            },
                            child: SvgPicture
                                .asset(
                              "images/create.svg",width: 28,height: 28,),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Duplicate",style: TextStyle(
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                          )
                        ],
                      ),
                      customerType == true
                          ? Column(
                              children: [

                                InkWell(
                                  onTap: ()async{
                                    String resmessage =
                                    await customerArchive(false);
                                    int resmessagevalue = int.parse(resmessage);
                                    if (resmessagevalue != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerDetail(
                                                    resmessagevalue)),
                                      );
                                    }
                                  },
                                  child: SvgPicture
                                      .asset(
                                    "images/archive.svg",width: 28,height: 28,),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Archive",style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                                )
                              ],
                            )
                          : Column(
                              children: [

                                InkWell(
                                  onTap: ()async{
                                    String resmessage =
                                    await customerArchive(true);
                                    int resmessagevalue = int.parse(resmessage);
                                    if (resmessagevalue != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerDetail(
                                                    resmessagevalue)),
                                      );
                                    }
                                  },
                                  child: SvgPicture
                                      .asset(
                                    "images/archive.svg",width: 28,height: 28,),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Unarchive",style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                                )
                              ],
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 39,
                      color: Color(0xFFF5F5F5),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: IconButton(
                                    icon: Image.asset("images/calendar.png"),
                                    onPressed: () {
                                      if(  meetingCount!>0 ){
                                        print("dkjvbk k ");

                                        Navigator
                                            .push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (
                                                    context) =>
                                                    Calender(null,"",DateTime.now(),null,[])));



                                      }
                                    },
                                  ),
                                ),
                                Center(
                                    child: Text(
                                  "Meeting",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 10,
                                      color: Color(0xFF212121)),
                                )),
                                Center(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                   meetingCount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        color: Color(0xFFED2449)),
                                  ),
                                )),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              print("clicked opportunity");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OpportunityMainPage(widget.customerId,"","","")));
                            },
                            child: Container(
                              child: Row(
                                children: [


                                  IconButton(
                                    icon: Image.asset("images/edit.png"),
                                    onPressed: () {},
                                  ),
                                  Center(
                                      child: Text(
                                    "Opportunity",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 10,
                                        color: Color(0xFF212121)),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      opportunityCount.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: Color(0xFFED2449)),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),

                          customerType == true?
                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 55,right: 25,bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Center(child: Text("",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),)),
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(top: 10,left: 55,right: 25,bottom: 10),
                            child: Container(
                              width: 90,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),

                              child: Center(child: Text("ARCHIVED",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white,  fontFamily: 'Mulish',),)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RadioListTile(

                              title: Text(
                                'Individual',
                                style: TextStyle(fontSize: 12,  fontFamily: 'Mulish',),

                              ),
                              value: "person",
                              groupValue: radioInput,
                              onChanged: (Object? value) {},
                            ),
                            RadioListTile(
                              title: Text(
                                'Company',
                                style: TextStyle(fontSize: 12,  fontFamily: 'Mulish',),
                              ),
                              value: "company",
                              groupValue: radioInput,
                              onChanged: (Object? value) {},
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 25),
                              child: Text(customername!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                   fontFamily: 'Mulish',
                                    fontSize: 16,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),


                      customerImage !=""?
                      Padding(
                        padding: const EdgeInsets
                            .only(left: 10,right: 10),
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
                                    1)),

                          ),
                          // child: ClipRRect(
                          //
                          //   borderRadius:
                          //   BorderRadius
                          //       .circular(0),
                          //   child:Image.network("${customerImage}?token=${token}"),
                          //
                          //
                          // ),
                          child: ClipRRect(

                            borderRadius:
                            BorderRadius
                                .circular(1),
                            child: Image.memory(
                              base64Decode(customerImage!),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(
                                  context)
                                  .size
                                  .width,
                              height: 300,
                            ),
                          ),
                        ),
                      ):
                      Padding(
                        padding: const EdgeInsets
                            .only(left: 10,right: 10),
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
                                    1)),

                          ),
                          child: ClipRRect(

                            borderRadius:
                            BorderRadius
                                .circular(0),
                            child:Icon(Icons.person,size: 80,),


                          ),
                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 10),
                        child: Text("Tax ID",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            taxid!,
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Job Position",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            jobposition!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Mobile",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            mobile!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Customer Rank",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            customerrank!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Supplier Rank",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            supplierrank!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Email",
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            email!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Website",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            website!,
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Title",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width /2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            title!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 0),
                    child: Text("Tags",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF666666))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25,right: 0,top: 5),
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /1.1,
                      height: 15,
                      //color: Colors.pinkAccent,

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: tagss!.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding:
                            const EdgeInsets.only(right: 8.0, top: 4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  color:  Color(int.parse(tagss![index]["color"])),),

                                width: 60,
                                height: 15,
                                child:
                                Center(
                                  child: Text(

                                    tagss![index]["name"].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 6),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Salesperson",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            salesperson!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Payment Terms",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            paymentterms!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Fiscal Position",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            "Fiscal Position",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Reference",
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            reference!,
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Company",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            company!,
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 0),
                        child: Text("Internal Notes",
                            style:TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 0),
                          child: Text(
                            internalnotes!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 22, right: 22),
                    child: Divider(color: Color(0xFFEBEBEB)),
                  ),


                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 450,
                      height: 39,
                      color: Color(0xFFF5F5F5),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, top: 5,bottom: 10),
                        child: Text(
                          "Contacts & Addresses", style: TextStyle(fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                        ),
                      ),
                    ),
                  ),



                  Container(
                    color: Colors.white70,
                    //height: MediaQuery.of(context).size.height / 1.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: addNewCustomer.length,
                        itemBuilder: (BuildContext context, int index) {
                          addNewCustomerData = addNewCustomer[index];

                          return Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              //height: MediaQuery.of(context).size.height/8.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width /
                                            4,
                                        // color: Colors.red,
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.blueGrey,
                                          size: 80,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 15),
                                                child: Container(
                                                  width:
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                      2,
                                                  //color: Colors.green,
                                                  child: Text(
                                                    addNewCustomerData!['name']??"",
                                                    style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 4),
                                            child: Text(
                                              addNewCustomerData!['email']??"",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 15, top: 4),
                                                child: Text(
                                                  addNewCustomerData!['state_id']["name"]??"",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 5, top: 4),
                                                child: Text(
                                                  addNewCustomerData!['country_id']["name"]??"",
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 4),
                                            child: Text(
                                              addNewCustomerData!['phone']??"",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, top: 4),
                                            child: Text(
                                              addNewCustomerData!['mobile']??"",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),



                ],
              ),
            ),
          ),
        ),
      );
    }
  }
  // ,,,,,
  // ,tags,,,,,,;

  void getCustomerDetails() async {
   String tokens = await getUserJwt();
    var data = await getCustomerData(widget.customerId, "");

    print(data);
    print("datatatatatata");
    setState(() {
      token = tokens;

      meetingCount = data['meeting_count']??0;
      opportunityCount=data['opportunity_count']??0;
      customerImage =  (data['image_1920']??"").toString();
      radioInput  = data['company_type'].toString();
      customername = data['name'].toString();
      taxid = data['vat'].toString();
      jobposition = data['function'].toString();
      mobile = data['mobile'].toString();
      customerrank = data['customer_rank'].toString();
      supplierrank = data['supplier_rank'].toString();
      email = data['email'].toString();
      website = data['website'].toString();
      title = data['title']['name'] ?? "";
      salesperson = data['user_id']['name'] ?? "";
      paymentterms = data['property_payment_term_id']['name'] ?? "";
      reference = data['ref'].toString();
      company = data["company_id"]["name"].toString() ?? "";
      internalnotes = data['comment']
              .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
              .toString() ??
          "";
      customerType = data['active'] ?? true;


      for (int i = 0; i < data['child_ids'].length; i++) {
        addNewCustomer.add(data['child_ids'][i]);
      }

      if(data["category_id"].length>0){
        //tags=snapshot.data![index]["tag_ids"][0]["name"].toString();
        tagss=data["category_id"];
      }
      else{
        tagss = [];
      }

      _isInitialized = true;
    });
  }

  customerArchive(bool valueType) async {
    String value = await archiveCustomer(widget.customerId, valueType);

    print(value);
    return value;
  }
}
