import 'dart:convert';
import 'dart:io';

import 'package:crm_project/api.dart';
import 'package:crm_project/quotationcreation.dart';
import 'package:crm_project/scrolling/quotationscrolling.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';

import 'calendarmainpage.dart';
import 'drawer.dart';
import 'lognoteedit.dart';

class QuotationDetail extends StatefulWidget {
  var quotationId;
  QuotationDetail(this.quotationId);
  @override
  State<QuotationDetail> createState() => _QuotationDetailState();
}

class _QuotationDetailState extends State<QuotationDetail> {
  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  String? quotationname,customername,expiration,pricelist,paymentterms,
      salesperson,salesteam,company,customerreference,tags,shippingpolicy,deliverydate,
      fiscalposition,sourcedocument,campaign,medium,source,createdby,
      createdon,lastupdatedby,lastupdatedon,salespersonimg, attachmentCount = "0";

  bool _isInitialized = false;
  bool optvisibility = false,ordervisibility = true;

  List orderLineProducts = [];
  List optionalProducts = [];


  Map<String, dynamic>? orderLineProductsData;
  Map<String, dynamic>? optionalProductsData;


  dynamic activityTypeName, activityTypeId, assignedToname, assignedToid,
      activityTypeNameCategory,btntext="Schedule";
  TextEditingController summaryController = TextEditingController();
  TextEditingController commandsController = TextEditingController();
  TextEditingController DuedateTime = TextEditingController();

  TextEditingController feedbackController = TextEditingController();

  bool scheduleBtn=true,opencalendarBtn= false,meetingColum=true;

  DateTime? _selectedDate;
  var DuedateTimeFinal;

  bool scheduleView=false,scheduleActivityVisibility = true,
      scheduleVisibiltyOverdue=false,scheduleVisibiltyToday=false,
      scheduleVisibiltyPlanned=false, attachmentVisibility = false,
      lognoteoptions = true, starImage = false;


  String? scheduleDays,scheduleactivityType,scheduleSummary,scheduleUser,
      scheduleCreateDate,scheduleCreateUser,scheduleDueon,scheduleNotes,
      scheduleBtn1,scheduleBtn2,scheduleBtn3;

  int? scheduleLength=0,scheduleOverdue,scheduleToday,schedulePlanned;
  var scheduleData;

  Icon scheduleIcon =  Icon(Icons.circle,
    color: Colors.white,
    size: 8,
  );

  // lognote

  TextEditingController lognoteController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];
  List<dynamic> selectedImagesDisplay = [];
  List<dynamic> attachmentImagesDisplay = [];
  String imagepath = "";
  String personImg="";
  List base64string1 = [];
  List<Map<String, dynamic>> myData1 = [];
  String base64string="";
  int lognoteDatalength = 0;

  Map<String, dynamic>? lognoteData;
  List logDataHeader = [];
  List logDataTitle=[];
  List ddd2=[];
  List? tagss=[];

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuotationDetails();
  }

  String? token;
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
              Text(quotationname!, style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.white,
                  decoration: TextDecoration.none),)
            ],
          ),
          leading: Builder(
            builder: (context) =>
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(icon: Image.asset("images/back.png"),
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
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(icon: SvgPicture.asset("images/messages.svg"),
                      onPressed: () {

                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: IconButton(icon: SvgPicture.asset("images/clock2.svg"),
                      onPressed: () {

                      },
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
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
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
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(

                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(icon: SvgPicture.asset(
                              "images/create.svg"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuotationCreation(0)));
                            },
                          ),
                        ),
                        Text("Create")
                      ],
                    ),
                    Column(

                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(icon: SvgPicture.asset(
                              "images/edit.svg"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuotationCreation(
                                              widget.quotationId

                                          )));
                            },
                          ),
                        ),
                        Text("Edit")
                      ],
                    ),
                    Column(

                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(icon: SvgPicture.asset(
                              "images/delete.svg"),
                            onPressed: () async {
                              print(widget.quotationId);
                              var data =
                              await deleteQuotationData(
                                  widget
                                      .quotationId);

                              if (data['message'] ==
                                  "Success") {
                                print(data);


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuotationScrolling ()
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Text("Delete")
                      ],
                    ),
                    Column(

                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(icon: SvgPicture.asset(
                              "images/create.svg"),
                              onPressed: () async {
                                var data = await getQuotationData(
                                    widget.quotationId,
                                    "duplicate");
                                String resMessageText;

                                if (data['message']
                                    .toString() ==
                                    "success") {
                                  resMessageText =
                                      data['data']['id']
                                          .toString();
                                  int resmessagevalue =
                                  int.parse(
                                      resMessageText);
                                  if (resmessagevalue !=
                                      0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              QuotationCreation(
                                                  resmessagevalue)),
                                    );
                                  }
                                };
                              }
                          ),
                        ),
                        Text("Duplicate")
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
                  child: Text(quotationname!, style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    color: Colors.black,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Customer",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          customername!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Quotation Template",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          "Quotation Template",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Expiration",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          expiration!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Pricelist",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          pricelist!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Payment Terms",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          paymentterms!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Sales",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Salesperson",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),



                    salespersonimg!=""?
                    Padding(
                      padding: const EdgeInsets
                          .only(left: 110),
                      child: Container(
                        width: 30,
                        height: 30,

                        decoration: BoxDecoration(
                            border: Border.all(
                            ),
                            borderRadius: BorderRadius
                                .all(
                                Radius.circular(
                                    20)),

                        ),
                        child: CircleAvatar(
                          radius: 12,
                          child: ClipRRect(

                            borderRadius:
                            BorderRadius
                                .circular(18),
                            child:Image.network("${salespersonimg!}?token=${token}"),


                          ),


                        ),
                      ),
                    ) :


                    Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              //  color: Colors.green
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(
                                20))),
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
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3.5,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          salesperson!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Sales Teams",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          salesteam!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Company",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          company!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Customer Reference",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          customerreference!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Tags",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,
                      //height: 50,
                      //color: Colors.pinkAccent,

                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: tagss!.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, top: 4),
                            child: Container(
                              width: 40,
                              height: 15,
                              child: ElevatedButton(
                                child: Text(
                                  tagss![index]["name"].toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 6),
                                ),
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  primary: Color(
                                      int.parse(tagss![index]["color"])),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Delivery",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Shipping Policy",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          shippingpolicy!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Delivery Date",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          deliverydate!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Invoicing",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Fiscal Position",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          fiscalposition!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Tracking",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                  child: Divider(color: Color(0xFFEBEBEB)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Source Document",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          sourcedocument!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Campaign",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          campaign!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Medium",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          medium!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Source",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          source!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Created by",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          createdby!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Created on",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          createdon!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Last Updated by",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          lastupdatedby!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                      padding: const EdgeInsets.only(left: 25),
                      child: Text("Last Updated on",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF666666))),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width /  2.4,

                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          lastupdatedon!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30,left: 10,right: 0),
                      child: Center(

                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          child: ElevatedButton(
                              child: Text(
                                "Orderlines",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.black),
                              ),
                              onPressed: () {

                                setState(() {

                                  optvisibility = false;
                                  ordervisibility = true;

                                });


                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              )),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 30,left: 0,right: 10),
                      child: Center(

                        child: Container(
                          width: MediaQuery.of(context).size.width/2.5,
                          child: ElevatedButton(
                              child: Text(
                                "Optional products",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.black),
                              ),
                              onPressed: () {

                                setState(() {

                                  optvisibility = true;
                                  ordervisibility = false;

                                });


                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),





                Visibility(
                  visible: ordervisibility,
                  child: Container(
                    color: Colors.white70,
                    //height: MediaQuery.of(context).size.height / 1.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderLineProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          orderLineProductsData = orderLineProducts[index];

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Container(
                                // width: 490,
                                // height:
                                // MediaQuery.of(context).size.height / 7,
                                  color: Colors.white,
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 10,
                                                        left: 25),
                                                    child: Container(
                                                      width: 230,
                                                      child: Text(
                                                        orderLineProductsData![
                                                        'name'] ??
                                                            "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize: 14,
                                                            color:
                                                            Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //   const EdgeInsets.only(
                                                  //       top: 10,
                                                  //       left: 40,
                                                  //       right: 25),
                                                  //   child: Text(
                                                  //     "sum: ${orderLineProductsData!['price_subtotal']}",
                                                  //     style: TextStyle(
                                                  //         fontWeight:
                                                  //         FontWeight.w500,
                                                  //         fontSize: 11,
                                                  //         color:
                                                  //         Colors.black),
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 10, left: 25),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Quantity : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFF787878)),
                                                    ),
                                                    Text(
                                                      orderLineProductsData![
                                                      "product_uom_qty"]
                                                          .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFF787878)),
                                                    ),
                                                    Text(
                                                      " " +
                                                          orderLineProductsData![
                                                          "product_uom"]["name"]
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFF787878)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 5, left: 25),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "Unit Price :",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                        Text(
                                                          orderLineProductsData![
                                                          'price_unit']
                                                              .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //   const EdgeInsets.only(
                                                  //       left: 200,
                                                  //       right: 25,
                                                  //       bottom: 10),
                                                  //   child: Container(
                                                  //     width: 30,
                                                  //     height: 30,
                                                  //     //color: Colors.green,
                                                  //     child: IconButton(
                                                  //       icon: Icon(
                                                  //           Icons.delete),
                                                  //       onPressed: () {
                                                  //         print(index);
                                                  //
                                                  //         orderLineProducts
                                                  //             .removeAt(
                                                  //             index);
                                                  //         setState(() {});
                                                  //         // orderLineProductsData?.removeAt(index);
                                                  //         print(
                                                  //             orderLineProducts[
                                                  //             index]
                                                  //                 .toString());
                                                  //         print(
                                                  //             orderLineProducts);
                                                  //         print(
                                                  //             "datatatatatattata");
                                                  //       },
                                                  //     ),
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        }),
                  ),
                ),


                // code change for products




                Visibility(
                  visible: optvisibility,
                  child: Container(
                    color: Colors.white70,
                    //height: MediaQuery.of(context).size.height / 1.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: optionalProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          optionalProductsData = optionalProducts[index];

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Container(
                                // width: 490,
                                // height:
                                // MediaQuery.of(context).size.height / 7,
                                  color: Colors.white,
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        //crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 10,
                                                        left: 25),
                                                    child: Container(
                                                      width: 230,
                                                      child: Text(
                                                        optionalProductsData![
                                                        'name'] ??
                                                            "",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize: 14,
                                                            color:
                                                            Colors.black),
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 10, left: 25),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Quantity : ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFF787878)),
                                                    ),
                                                    Text(
                                                      optionalProductsData![
                                                      "quantity"]
                                                          .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFF787878)),
                                                    ),
                                                    Text(
                                                      " " +
                                                          optionalProductsData![
                                                          "uom_id"]["name"]
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          fontSize: 11,
                                                          color: Color(
                                                              0xFF787878)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 5, left: 25),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        Text(
                                                          "Unit Price :",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                        Text(
                                                          optionalProductsData![
                                                          'price_unit']
                                                              .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 11,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 200,
                                                        right: 25,
                                                        bottom: 10),
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      //color: Colors.green,
                                                      child: IconButton(
                                                        icon: Icon(
                                                            Icons.delete),
                                                        onPressed: () {
                                                          print(index);

                                                          optionalProducts
                                                              .removeAt(
                                                              index);
                                                          setState(() {});
                                                          // orderLineProductsData?.removeAt(index);
                                                          print(
                                                              optionalProducts[
                                                              index]
                                                                  .toString());
                                                          print(
                                                              optionalProducts);
                                                          print(
                                                              "datatatatatattata");
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        }),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 10, right: 0),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: ElevatedButton(
                              child: Text(
                                "Log note",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.black),
                              ),
                              onPressed: () {
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 0, right: 10),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: ElevatedButton(
                              child: Text(
                                "Schedule Activity",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.black),
                              ),
                              onPressed: () async {
                                await defaultScheduleValues();

                                summaryController.text = "";
                                commandsController.text = "";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildOrderPopupDialog(context, 0),
                                ).then((value) => setState(() {}));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 0, right: 10),
                      child: Center(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              child: IconButton(
                                icon: Image.asset("images/pin.png"),
                                onPressed: () {
                                  setState(() {
                                    attachmentVisibility == true
                                        ? attachmentVisibility = false
                                        : attachmentVisibility = true;
                                  });

                                },
                              ),
                            ),
                            Container(
                              width: 50,
                              child: Text(
                                attachmentCount!,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // code for attchments

                Visibility(
                  visible: attachmentVisibility,
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: getattchmentData(widget.quotationId, "sale.order"),
                          builder: (context, AsyncSnapshot snapshot) {

                            if (snapshot.hasError) {

                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                if (snapshot.data == null) {

                                  return const Center(
                                      child: Text('Something went wrong'));
                                }
                                if (snapshot.data.length != 0) {
                                  attachmentImagesDisplay = snapshot.data;

                                  return Padding(
                                    padding:
                                    const EdgeInsets.only(left: 0, right: 100),
                                    child: Container(
                                      //color: Colors.green,

                                      width: MediaQuery.of(context).size.width / 3,

                                      child: GridView.builder(
                                        shrinkWrap: true,

                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: attachmentImagesDisplay.length,
                                        gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                        itemBuilder:
                                            (BuildContext context, int index) {


                                          return Center(
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    child: Image.network(
                                                      "${attachmentImagesDisplay[index]['url']}?token=${token}",
                                                      height: 120,
                                                      width: 80,
                                                    ),
                                                  ),
                                                  Positioned(
                                                      left: 57,
                                                      right: 0,
                                                      bottom: 85,
                                                      top: 1,
                                                      child: Container(
                                                        width: 15,
                                                        // height: 15,
                                                        color: Colors.grey[200],
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .delete_outline_outlined,
                                                            size: 15.0,
                                                            color: Colors.grey[800],
                                                          ),
                                                          onPressed: () async {
                                                            print(
                                                                attachmentImagesDisplay[
                                                                index]['id']);
                                                            print("idvaluevalue");
                                                            // print(
                                                            //     logDataTitle[indexx][indexs]['attachment_ids'][index]["id"]);
                                                            int lodAttachmentId = attachmentImagesDisplay[index]['id'];
                                                            var data = await deleteLogAttachment(
                                                                lodAttachmentId);

                                                            if (data['message'] ==
                                                                "Success") {
                                                              print(
                                                                  "jhbdndsjbv");
                                                              await getQuotationDetails();
                                                              setState(() {
                                                                attachmentImagesDisplay
                                                                    .clear();
                                                              });
                                                            }

                                                            // print(
                                                            //     data);
                                                            print(
                                                                "delete testststs");
                                                          },
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            }
                            return Center(child: const CircularProgressIndicator());
                          }),
                      TextButton(onPressed: (){

                        myAlert("attachment");
                      }, child: Text("Select Attachments")),

                    ],
                  ),
                ),
                //

                // code for attchments


                // code for lognote

                Container(
                  width: MediaQuery.of(context).size.width,

                  //height: MediaQuery.of(context).size.height/6,
                  // color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          salespersonimg != "" ?
                          Padding(
                            padding: const EdgeInsets
                                .only(left: 25),
                            child: Container(
                              width: 30,
                              height: 30,

                              decoration: BoxDecoration(
                                border: Border.all(
                                ),
                                borderRadius: BorderRadius
                                    .all(
                                    Radius.circular(
                                        20)),

                              ),
                              child: CircleAvatar(
                                radius: 12,
                                child: ClipRRect(

                                  borderRadius:
                                  BorderRadius
                                      .circular(18),
                                  child: Image.network(
                                      "${salespersonimg!}?token=${token}"),


                                ),


                              ),
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    //  color: Colors.green
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20))),
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

                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.5,
                              //height: 46,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(
                                          0xFFEBEBEB))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width/1.5,
                                    // height: 40,
                                    // color: Colors.red,
                                    child:Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                          controller: lognoteController,
                                          decoration:
                                          const InputDecoration(
                                              border:
                                              InputBorder.none,
                                              hintText:
                                              "Send a message to followers",
                                              hintStyle: TextStyle(
                                                //fontFamily: "inter",
                                                  fontWeight:
                                                  FontWeight
                                                      .w400,
                                                  fontSize: 10,
                                                  color: Color(
                                                      0xFFAFAFAF)))),
                                    ),
                                  ),
                                  Divider(color: Colors.grey,),

                                  IconButton(
                                    icon: Image.asset(
                                        "images/pin.png"),
                                    onPressed: () {

                                      myAlert("lognote");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),


                      selectedImages.isEmpty ?  Padding(
                        padding: const EdgeInsets.only(left:73),
                        child: Container(

                          width:
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                          // height: 40,
                        ),
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.only(left:70,right: 50),
                        child: Container(

                          width:
                          MediaQuery
                              .of(context)
                              .size
                              .width,
                          // height: 40,
                          child: Container(
                            width: 40,
                            //height: 40,
                            child: GridView.builder(
                              shrinkWrap: true, // Avoid scrolling
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                              selectedImages.length,
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8),
                              itemBuilder:
                                  (BuildContext context,
                                  int index) {
                                return Center(
                                    child: kIsWeb
                                        ? Image.network(
                                        selectedImages[
                                        index]
                                            .path)
                                        : Image.file(
                                        selectedImages[
                                        index]));
                              },
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20,left: 73,top: 5),
                        child: SizedBox(
                          width: 56,
                          height: 28,
                          child: ElevatedButton(
                              child: Center(
                                child: Text(
                                  "Log",
                                  style: TextStyle(
                                      fontWeight: FontWeight
                                          .w700,
                                      fontSize: 11,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () async {
                                for (int i = 0;
                                i < selectedImages.length;
                                i++) {
                                  imagepath = selectedImages[i]
                                      .path
                                      .toString();
                                  File imagefile = File(
                                      imagepath); //convert Path to File
                                  Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
                                  base64string = base64.encode(imagebytes);

                                  // base64string1.add(
                                  //     base64string);
                                  //

                                  String dataImages =
                                      '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                                  Map<String, dynamic> jsondata = jsonDecode(dataImages);
                                  myData1.add(jsondata);

                                }
                                // print(myData1);
                                // print("final datatata");


                                await logNoteData(myData1);
                                setState(() {
                                  logDataHeader.clear();
                                  logDataTitle.clear();
                                  selectedImagesDisplay.clear();
                                  lognoteController.text= "";
                                  selectedImages.clear();
                                  myData1.clear();
                                });

                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF04254),
                              )),
                        ),
                      ),
                    ],
                  ),



                ),



                // code for lognote

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(     // <-- TextButton
                        onPressed: () {
                          setState(() {
                            scheduleActivityVisibility == true ?scheduleActivityVisibility = false :scheduleActivityVisibility = true;

                          });

                        },
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          size: 30.0,
                          color: Colors.black54,
                        ),
                        label: Text('Planned Activities',style: TextStyle(fontSize: 12,color: Colors.black),),
                      ),

                      Visibility(
                        visible: scheduleVisibiltyOverdue,
                        child: Container(
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Center(child: Text(scheduleOverdue.toString(),style: TextStyle(fontSize: 10,
                              fontWeight:FontWeight.bold ,color: Colors.white),)),


                        ),
                      ),
                      Visibility(
                        visible: scheduleVisibiltyToday,
                        child: Container(
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow,
                          ),
                          child: Center(child: Text(scheduleToday.toString(),style: TextStyle(fontSize: 10,
                              fontWeight:FontWeight.bold ,color: Colors.black),)),


                        ),
                      ),
                      Visibility(
                        visible: scheduleVisibiltyPlanned,
                        child: Container(
                          width: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: Center(child: Text(schedulePlanned.toString(),style: TextStyle(fontSize: 10,
                              fontWeight:FontWeight.bold ,color: Colors.white),)),


                        ),
                      ),
                    ],
                  ),
                ),



                // code change for schedule activity

                Visibility(
                  visible:scheduleActivityVisibility ,
                  child: Container(
                    color: Colors.white70,
                    //height: MediaQuery.of(context).size.height/1.8,
                    child: scheduleLength==0 ? Container()
                   : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: scheduleLength,
                        itemBuilder:
                            (BuildContext context, int index) {

                          scheduleData['records'][index]['icon']=="fa-envelope"? scheduleIcon =  const Icon(Icons.email_outlined,
                            color: Colors.white,
                            size: 8,
                          ): scheduleData['records'][index]['icon']=="fa-phone"? scheduleIcon =  Icon(Icons.phone,
                            color: Colors.white,
                            size: 8,
                          ):scheduleData['records'][index]['icon']=="fa-users"? scheduleIcon =  Icon(Icons.person,
                            color: Colors.white,
                            size: 8,
                          ):scheduleData['records'][index]['icon']=="fa-file-text-o"? scheduleIcon =  Icon(Icons.file_copy,
                            color: Colors.white,
                            size: 8,
                          ):scheduleData['records'][index]['icon']=="fa-line-chart"? scheduleIcon =  Icon(Icons.bar_chart,
                            color: Colors.white,
                            size: 8,
                          ):scheduleData['records'][index]['icon']=="fa-tasks"? scheduleIcon =  Icon(Icons.task,
                            color: Colors.white,
                            size: 8,
                          ):scheduleData['records'][index]['icon']=="fa-upload"? scheduleIcon =  Icon(Icons.upload,
                            color: Colors.white,
                            size: 8,
                          ):Icon(Icons.circle,
                            color: Colors.white,
                            size: 8,
                          );
                          return Card(
                            elevation: 1,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 13.0,right: 15),
                                          child: Container(

                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                CircleAvatar(
                                                  radius: 12,
                                                  child: ClipRRect(

                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(18),
                                                    child: Image.network(
                                                        "${scheduleData['records'][index]['image']!}?token=${token}"),


                                                  ),


                                                ),


                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: Container(
                                                    width: 10.0,
                                                    height: 10.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:  Color(int.parse(scheduleData['records'][index]['label_color'])),
                                                    ),
                                                    child: Center(
                                                      child: scheduleIcon,
                                                      // child: Icon(
                                                      //   Icons.image,
                                                      //   color: Colors.white,
                                                      //   size: 8,
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),


                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0,left: 12,right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [
                                          Container(

                                            width: MediaQuery.of(context).size.width/5.5,
                                            // color: Colors.red,

                                            child: Text(scheduleData['records'][index]['delay_label'].toString() ?? "",
                                              style: TextStyle(fontSize: 13,color: Color(int.parse(scheduleData['records'][index]['label_color']))),),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            // color: Colors.red,
                                            width: MediaQuery.of(context).size.width/5.5,


                                            child: Text(scheduleData['records'][index]['activity_type_id'][1].toString() ?? "",
                                              style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold,),),
                                          ),
                                          SizedBox(width: 5,),
                                          Container(
                                            //color: Colors.red,
                                            width: MediaQuery.of(context).size.width/4.5,

                                            child: Text(scheduleData['records'][index]['user_id'][1].toString() ?? "",
                                              style: TextStyle(fontSize: 13,color: Colors.grey),),
                                          ),


                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                print(scheduleView);
                                                print("final data ");
                                                scheduleView==false? scheduleView=true : scheduleView==true? scheduleView=false : false;
                                                print(scheduleView);
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20,right: 20),
                                              child: Container(

                                                width: 10,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black,
                                                ),
                                                child: Center(
                                                  child: Text("i",

                                                    style: TextStyle(fontSize: 12,color: Colors.white,
                                                        fontWeight: FontWeight.w800),),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 49),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [


                                      Visibility(
                                        visible: scheduleView,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 15,left: 17),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Activity type",
                                                style: TextStyle(fontSize: 14,color: Colors.grey,
                                                  fontWeight: FontWeight.bold,),),

                                              SizedBox(height: 5,),
                                              Text(scheduleData['records'][index]['activity_type_id'][1],
                                                style: TextStyle(fontSize: 14,color: Colors.grey),),
                                              SizedBox(height: 5,),
                                              Text("Created",
                                                style: TextStyle(fontSize: 14,color: Colors.grey
                                                  , fontWeight: FontWeight.bold,),),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [

                                                  Text(scheduleData['records'][index]['create_date'].toString() ?? "",
                                                    style: TextStyle(fontSize: 14,color: Colors.grey),),

                                                  SizedBox(width: 5,),

                                                  Container(
                                                    child:   CircleAvatar(
                                                      radius: 12,
                                                      child: ClipRRect(

                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        child: Image.network(
                                                            "${scheduleData['records'][index]['image2']!}?token=${token}"),


                                                      ),


                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),

                                                  Text(scheduleData['records'][index]['create_uid'][1].toString() ?? "",
                                                    style: TextStyle(fontSize: 14,color: Colors.grey
                                                      , fontWeight: FontWeight.bold,),),


                                                ],
                                              ),
                                              SizedBox(height: 5,),
                                              Text("Assigned to",
                                                style: TextStyle(fontSize: 14,color: Colors.grey
                                                  , fontWeight: FontWeight.bold,),),
                                              SizedBox(height: 5,),
                                              Row(
                                                children: [



                                                  Container(
                                                    child:    CircleAvatar(
                                                      radius: 12,
                                                      child: ClipRRect(

                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                        child: Image.network(
                                                            "${scheduleData['records'][index]['image']!}?token=${token}"),


                                                      ),


                                                    ),
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Text(scheduleData['records'][index]['user_id'][1].toString() ?? "",
                                                    style: TextStyle(fontSize: 14,color: Colors.grey),),


                                                ],
                                              ),

                                              SizedBox(height: 5,),
                                              Text("Due on",
                                                style: TextStyle(fontSize: 14,color: Colors.grey
                                                  , fontWeight: FontWeight.bold,),),
                                              SizedBox(height: 5,),
                                              Text(scheduleData['records'][index]['date_deadline'].toString() ?? "",
                                                style: TextStyle(fontSize: 14,color: Colors.grey),),

                                              SizedBox(height: 5,),



                                            ],
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top: 8,left: 12,right: 10),
                                        child: Container(
                                          //color: Colors.red,

                                          width: MediaQuery.of(context).size.width/1.5,
                                          child:  Text(scheduleData['records'][index]['note'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                                              .toString() ?? "",
                                            style: TextStyle(fontSize: 14,color: Colors.black
                                            ),),

                                        ),
                                      ),


                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.end,

                                        children: [
                                          Container(
                                            //color: Colors.red,
                                            height: 25,
                                            width: MediaQuery.of(context).size.width/4.3,
                                            child: TextButton.icon(     // <-- TextButton
                                              onPressed: ()async {

                                                int datasIds = scheduleData['records'][index]['id'];

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      _buildMarkDoneDialog(
                                                          context, datasIds
                                                      ),
                                                ).then((value) => setState(() {}));

                                              },
                                              icon: Icon(
                                                Icons.check,
                                                size: 13.0,
                                                color: Colors.black54,
                                              ),
                                              label: Text(scheduleData['records'][index]['buttons'][0].toString() ?? "",style: TextStyle(fontSize: 10,color: Colors.black54),),
                                            ),
                                          ),
                                          SizedBox(width: 10,),

                                          scheduleData['records'][index]['buttons'][1] == "Reschedule" ?


                                          Container(
                                            width: MediaQuery.of(context).size.width/4.3,
                                            child: TextButton.icon(     // <-- TextButton
                                              onPressed: ()async {
                                                //  int idType = scheduleData['records'][index]['id'];
                                                //
                                                // var data =  await editDefaultScheduleData(scheduleData['records'][index]['id']);
                                                //
                                                //
                                                // String textType =  scheduleData['records'][index]['buttons'][1].toString();

                                                DateTime dateTime =  DateTime.parse(scheduleData['records'][index]['date_deadline']);



                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (
                                                            context) =>
                                                            Calender(null,"",dateTime,null,[])));



                                              },
                                              icon: Icon(
                                                Icons.calendar_month,
                                                size: 13.0,
                                                color: Colors.black54,
                                              ),
                                              label: Text(scheduleData['records'][index]['buttons'][1].toString() ?? "",style: TextStyle(fontSize: 10,color: Colors.black54),),
                                            ),
                                          ):
                                          Container(
                                            width: MediaQuery.of(context).size.width/4.3,
                                            child: TextButton.icon(     // <-- TextButton
                                              onPressed: ()async {
                                                int idType = scheduleData['records'][index]['id'];

                                                var data =  await editDefaultScheduleData(scheduleData['records'][index]['id']);




                                                setState(() {

                                                  activityTypeName = data['activity_type_id']??null;
                                                  activityTypeId = data['activity_type_id']['id']??null;
                                                  activityTypeNameCategory = data['activity_type_id']['category']??"";
                                                  assignedToname= data['user_id']??null;
                                                  assignedToid = data['user_id']['id']??null;
                                                  DuedateTime.text = data['date_deadline']??"";
                                                  summaryController.text = data['summary']??"";
                                                  commandsController.text = data['note']??"";
                                                  // DuedateTime.text == "default" ?
                                                  if(activityTypeNameCategory == "default"){
                                                    scheduleBtn=true;
                                                    opencalendarBtn= false;
                                                    btntext = "Schedule";
                                                    meetingColum = true;
                                                  }
                                                  else if(activityTypeNameCategory == "phonecall"){
                                                    scheduleBtn=true;
                                                    opencalendarBtn= true;
                                                    btntext = "Save";
                                                    meetingColum = true;
                                                  }
                                                  else if(activityTypeNameCategory == "meeting"){
                                                    scheduleBtn=false;
                                                    opencalendarBtn= true;
                                                    btntext = "Schedule";
                                                    meetingColum = false;
                                                  }
                                                  else if(activityTypeNameCategory == "upload_file"){
                                                    scheduleBtn=true;
                                                    opencalendarBtn= false;
                                                    btntext = "Schedule";
                                                    meetingColum = true;
                                                  }


                                                  print(activityTypeNameCategory);
                                                  print("jhbvjbvsvj");
                                                });


                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      _buildOrderPopupDialog(
                                                          context, idType
                                                      ),
                                                ).then((value) => setState(() {}));






                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                size: 13.0,
                                                color: Colors.black54,
                                              ),
                                              label: Text(scheduleData['records'][index]['buttons'][1].toString() ?? "",style: TextStyle(fontSize: 10,color: Colors.black54),),
                                            ),
                                          ),



                                          SizedBox(width: 10,),
                                          Container(

                                            width: MediaQuery.of(context).size.width/5,
                                            child: TextButton.icon(     // <-- TextButton
                                              onPressed: () async{

                                                var data =  await deleteScheduleData(scheduleData['records'][index]['id']);


                                                if(data['message']=="Success") {
                                                  print("responce");
                                                  setState(() {
                                                    getScheduleDetails();
                                                  });
                                                }






                                                print("demo datataaa");

                                              },
                                              icon: Icon(
                                                Icons.cancel_outlined,
                                                size: 13.0,
                                                color: Colors.black54,
                                              ),
                                              label: Text(scheduleData['records'][index]['buttons'][2].toString() ?? "",style: TextStyle(fontSize: 10,color: Colors.black54),),
                                            ),
                                          ),
                                        ],
                                      )



                                    ],
                                  ),
                                ),
                              ],
                            ),


                          );
                        }),
                  ),
                ),



                SizedBox(height: 20,),



                FutureBuilder(
                    future: getlogNoteData(widget.quotationId, "sale.order"),
                    builder: (context, AsyncSnapshot snapshot) {

                      logDataHeader.clear();
                      logDataTitle.clear();
                      print(snapshot.data);
                      print("snap data final ");
                      if (snapshot.hasError) {
                        print(snapshot.hasError);
                        print("snap error");
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          if (snapshot.data == null) {
                            print("dfffdfdf");
                            //print(snapshot.data!.length);
                            return const Center(child: Text(
                                'Something went wrong'));
                          }

                          if (snapshot.data.length != 0) {
                            snapshot.data?.forEach((key, value) {
                              logDataHeader.add(key);
                              logDataTitle.add(value);

                              print(logDataHeader.length);
                              print("ddd1.length");
                            });


                            // print(logDataHeader.length);
                            // print(logDataTitle.length);
                            // print("ddd2.length");
                            //
                            // print(logDataHeader[0]);
                            // print(logDataTitle[0][0]['id']);
                            // print("ddd2.lengthssss");


                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: logDataHeader.length,
                                itemBuilder:
                                    (BuildContext context, int indexx) {
                                  return Card(
                                    elevation: 1,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Center(child: Text(
                                            logDataHeader[indexx],
                                            style: TextStyle(fontSize: 12,
                                                color: Colors.black),)),
                                        ),

                                        ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: logDataTitle[indexx]
                                                .length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int indexs) {
                                              selectedImagesDisplay =
                                              logDataTitle[indexx][indexs]['attachment_ids'];
                                              lognoteoptions = logDataTitle[indexx][indexs]['is_editable'] ?? true;
                                              starImage   = logDataTitle[indexx][indexs]['starred']??false;



                                              return Card(
                                                elevation: 1,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            alignment: Alignment
                                                                .center,
                                                            children: [
                                                              // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left: 210,
                                                                    right: 50),
                                                                child: Container(
                                                                  //color: Colors.cyan,
                                                                  height: 30,
                                                                  width: 90,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                bottom: 0,
                                                                right: 0,
                                                                //left: 20,
                                                                child: Container(
                                                                  width: 90.0,
                                                                  height: 30.0,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      border: Border
                                                                          .all(
                                                                        color: Colors
                                                                            .grey,
                                                                        width: 1,
                                                                      )),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment
                                                                        .spaceAround,
                                                                    children: [
                                                                      Container(
                                                                        height: 20,
                                                                        width: 20,
                                                                        //color: Colors.red,
                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .topRight,
                                                                          child: IconButton(
                                                                            icon: Icon(
                                                                                Icons
                                                                                    .add_reaction_outlined,
                                                                                size: 15.0),
                                                                            onPressed: () {},
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        height: 20,
                                                                        width: 20,

                                                                        child: Align(
                                                                          alignment: Alignment
                                                                              .topRight,
                                                                          child:
                                                                          starImage ==
                                                                              true
                                                                              ?
                                                                          IconButton(
                                                                            icon: Icon(
                                                                              Icons
                                                                                  .star_rate,
                                                                              size: 15.0,
                                                                              color: Colors
                                                                                  .yellow[700],
                                                                            ),
                                                                            onPressed: () async {
                                                                              int lodDataId = logDataTitle[indexx][indexs]['id'];

                                                                              var data = await logStarChange(
                                                                                  lodDataId,
                                                                                  false);


                                                                              if( data['result']['message'] == "success"){
                                                                                print("startrue");
                                                                                setState(() {
                                                                                  starImage = false;
                                                                                });

                                                                              }




                                                                              print(
                                                                                  data);
                                                                              print(
                                                                                  " ");
                                                                            },
                                                                          )
                                                                              :
                                                                          IconButton(
                                                                            icon: Icon(
                                                                              Icons
                                                                                  .star_rate,
                                                                              size: 15.0,

                                                                            ),
                                                                            onPressed: () async {
                                                                              int lodDataId = logDataTitle[indexx][indexs]['id'];

                                                                              var data = await logStarChange(
                                                                                  lodDataId,
                                                                                  true);

                                                                              if( data['result']['message'] == "success"){
                                                                                print("starfalse");
                                                                                setState(() {
                                                                                  starImage = true;
                                                                                });

                                                                              }

                                                                              print(
                                                                                  data);
                                                                              print(
                                                                                  "hfghavjhcvjsch2");
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible: lognoteoptions,
                                                                        child: Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 20,
                                                                              width: 20,
                                                                              //color: Colors.red,
                                                                              child: Align(
                                                                                alignment: Alignment
                                                                                    .topRight,
                                                                                child: IconButton(
                                                                                  icon: Icon(
                                                                                      Icons
                                                                                          .edit,
                                                                                      size: 15.0),
                                                                                  onPressed: () {
                                                                                    int lodDataId = logDataTitle[indexx][indexs]['id'];
                                                                                    String logdata = logDataTitle[indexx][indexs]['body']
                                                                                        .replaceAll(
                                                                                        RegExp(
                                                                                            r'<[^>]*>|&[^;]+;'),
                                                                                        ' ') ??
                                                                                        "";
                                                                                    Navigator
                                                                                        .push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                            builder: (
                                                                                                context) =>
                                                                                                LogNoteEdit(
                                                                                                    lodDataId,
                                                                                                    salespersonimg!,
                                                                                                    token!,
                                                                                                    widget
                                                                                                        .quotationId,
                                                                                                    logdata)));

                                                                                    print(
                                                                                        "emojiVisibility");
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              height: 20,
                                                                              width: 20,
                                                                              //color: Colors.red,
                                                                              child: Align(
                                                                                alignment: Alignment
                                                                                    .center,
                                                                                child: IconButton(
                                                                                  icon: Icon(
                                                                                      Icons
                                                                                          .delete_outline_outlined,
                                                                                      size: 15.0),
                                                                                  onPressed: () async {
                                                                                    int lodDataId = logDataTitle[indexx][indexs]['id'];
                                                                                    var data = await deleteLogData(
                                                                                        lodDataId);

                                                                                    if (data['message'] ==
                                                                                        "Success") {
                                                                                      print(
                                                                                          "final11");
                                                                                      await getQuotationDetails();
                                                                                      setState(() {
                                                                                        logDataHeader
                                                                                            .clear();
                                                                                        logDataTitle
                                                                                            .clear();
                                                                                        selectedImagesDisplay
                                                                                            .clear();
                                                                                      });
                                                                                    }
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),


                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          ListView.builder(
                                                              scrollDirection: Axis
                                                                  .vertical,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: 1,
                                                              itemBuilder: (
                                                                  BuildContext context,
                                                                  int index) {
                                                                return Card(
                                                                  elevation: 0,
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment: CrossAxisAlignment
                                                                                .start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets
                                                                                    .only(
                                                                                    left: 15.0,
                                                                                    right: 15),
                                                                                child: Container(
                                                                                  //color: Colors.green,
                                                                                  child: Stack(
                                                                                    alignment: Alignment
                                                                                        .center,
                                                                                    children: [
                                                                                      // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                                                      CircleAvatar(
                                                                                        radius: 12,
                                                                                        child: ClipRRect(

                                                                                          borderRadius:
                                                                                          BorderRadius
                                                                                              .circular(
                                                                                              18),
                                                                                          child: Image
                                                                                              .network(
                                                                                              "${logDataTitle[indexx][indexs]['image']}?token=${token}"),
                                                                                        ),
                                                                                      ),
                                                                                      Positioned(
                                                                                        bottom: 0,
                                                                                        right: 0,
                                                                                        child: Container(
                                                                                          width: 10.0,
                                                                                          height: 10.0,

                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape
                                                                                                .circle,
                                                                                            color: Colors
                                                                                                .green,
                                                                                          ),

                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),


                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Container(
                                                                                // color: Colors.green,
                                                                                  width: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .width /
                                                                                      4,
                                                                                  child: Text(
                                                                                      logDataTitle[indexx][indexs]['create_uid'][1],
                                                                                      style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        color: Colors
                                                                                            .black,
                                                                                        fontWeight: FontWeight
                                                                                            .bold,))),
                                                                              Container(
                                                                                //color: Colors.green,
                                                                                  width: MediaQuery
                                                                                      .of(
                                                                                      context)
                                                                                      .size
                                                                                      .width /
                                                                                      4,
                                                                                  child: Text(
                                                                                      logDataTitle[indexx][indexs]["period"],
                                                                                      style: TextStyle(
                                                                                        fontSize: 11,
                                                                                        color: Colors
                                                                                            .grey[700],)))
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom: 5,
                                                                            right: 53),
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                              .start,
                                                                          children: [

                                                                            Container(
                                                                              // color: Colors.green,
                                                                                width: MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .width /
                                                                                    4,
                                                                                child: Text(
                                                                                    logDataTitle[indexx][indexs]['subject']
                                                                                        .replaceAll(
                                                                                        RegExp(
                                                                                            r'<[^>]*>|&[^;]+;'),
                                                                                        ' ') ??
                                                                                        "",
                                                                                    style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      color: Colors
                                                                                          .black,))),


                                                                            Container(
                                                                              // color: Colors.green,
                                                                                width: MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .width /
                                                                                    2,
                                                                                child: Html(
                                                                                  data: logDataTitle[indexx][indexs]['body'],
                                                                                  style: {
                                                                                    'p': Style(
                                                                                        fontSize: FontSize
                                                                                            .small),
                                                                                    // Customize the font size for <p> elements
                                                                                    // Customize the font size for <strong> elements
                                                                                  },

                                                                                )),


                                                                            selectedImagesDisplay
                                                                                .isEmpty
                                                                                ? Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  left: 5),
                                                                              child: Container(

                                                                                width:
                                                                                MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .width /
                                                                                    2,
                                                                                // height: 40,
                                                                              ),
                                                                            )
                                                                                :
                                                                            Padding(
                                                                              padding: const EdgeInsets
                                                                                  .only(
                                                                                  left: 0,
                                                                                  right: 100),
                                                                              child: Container(
                                                                                //color: Colors.green,

                                                                                width:
                                                                                MediaQuery
                                                                                    .of(
                                                                                    context)
                                                                                    .size
                                                                                    .width /
                                                                                    3,
                                                                                // height: 140,
                                                                                child: GridView
                                                                                    .builder(
                                                                                  shrinkWrap: true,
                                                                                  // Avoid scrolling
                                                                                  physics: NeverScrollableScrollPhysics(),
                                                                                  itemCount:
                                                                                  selectedImagesDisplay
                                                                                      .length,
                                                                                  gridDelegate:
                                                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                      crossAxisCount: 1),
                                                                                  itemBuilder:
                                                                                      (
                                                                                      BuildContext context,
                                                                                      int index) {
                                                                                    print(
                                                                                        selectedImagesDisplay
                                                                                            .length);
                                                                                    print(
                                                                                        selectedImagesDisplay[index]["datas"]);
                                                                                    print(
                                                                                        "selectedImagesDisplay.length,");

                                                                                    return Center(
                                                                                      child: Container(
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            ClipRRect(
                                                                                              child: Image
                                                                                                  .network(
                                                                                                "${selectedImagesDisplay[index]["datas"]}?token=${token}",
                                                                                                height: 120,
                                                                                                width: 80,
                                                                                              ),


                                                                                            ),
                                                                                            Positioned(

                                                                                                left: 57,
                                                                                                right: 0,
                                                                                                bottom: 85,
                                                                                                top: 1,
                                                                                                child: Container(
                                                                                                  width: 15,
                                                                                                  // height: 15,
                                                                                                  color: Colors
                                                                                                      .grey[200],
                                                                                                  child: IconButton(
                                                                                                    icon: Icon(
                                                                                                      Icons
                                                                                                          .delete_outline_outlined,
                                                                                                      size: 15.0,
                                                                                                      color: Colors
                                                                                                          .white,),
                                                                                                    onPressed: () async {
                                                                                                      print(
                                                                                                          logDataTitle[indexx][indexs]['attachment_ids'][index]["id"]);
                                                                                                      int lodAttachmentId = logDataTitle[indexx][indexs]['attachment_ids'][index]["id"];
                                                                                                      var data = await deleteLogAttachment(
                                                                                                          lodAttachmentId);

                                                                                                      if (data['message'] ==
                                                                                                          "Success") {
                                                                                                        print(
                                                                                                            "jhbdndsjbv");
                                                                                                        await getQuotationDetails();
                                                                                                        setState(() {
                                                                                                          logDataHeader
                                                                                                              .clear();
                                                                                                          logDataTitle
                                                                                                              .clear();
                                                                                                          selectedImagesDisplay
                                                                                                              .clear();
                                                                                                        });
                                                                                                      }


                                                                                                      print(
                                                                                                          data);
                                                                                                      print(
                                                                                                          "delete testststs");
                                                                                                    },
                                                                                                  ),
                                                                                                )
                                                                                            )
                                                                                          ],
                                                                                        ),

                                                                                      ),

                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),


                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                );
                                                              }

                                                          ),
                                                        ],
                                                      ),
                                                      //color: Colors.red,

                                                    ),

                                                  ],
                                                ),


                                              );
                                            })


                                      ],
                                    ),


                                  );
                                });
                          }
                          else{
                            return Container();
                          }
                        }
                      }
                      return Center(child: const CircularProgressIndicator());
                    }
                ),




              ],
            ),
          ),
        ),
      );
    }
  }

   getQuotationDetails() async {

    token  = await getUserJwt();

    var data = await getQuotationData(widget.quotationId, "");

    print(data);
    print("default data");

    setState(() {



      quotationname = data['name'] ?? "";


      customername = data['partner_id']['display_name'] ?? "";
      expiration = data['validity_date'].toString();
      pricelist = data['pricelist_id']['name']?? "";

      paymentterms = data['payment_term_id']['name'] ?? "";

      salesperson = data['user_id']['name'] ?? "";

      salesteam = data['team_id']['name'] ?? "";

      company = data['company_id']['name'] ?? "";

       customerreference = (data['client_order_ref'] ?? "").toString();

      // for (int i = 0; i < data['tag_ids'].length; i++) {
      //   selctedTag.add(data['tag_ids'][i]);
      // }
      //
      // for (int i = 0; i < selctedTag.length; i++) {
      //   editTagName.add(new ValueItem(
      //       label: selctedTag[i]['name'],
      //       value: selctedTag[i]['id'].toString()));
      // }

      // tags = editTagName.map((item) => item.value).toList();
      deliverydate = data['commitment_date'].toString();
      fiscalposition = data['fiscal_position_id']['name'] ?? "";
      sourcedocument = (data['origin'] ?? "").toString();

      campaign = data['campaign_id']['name'] ?? "";

      medium = data['medium_id']['name'] ?? "";

      source = data['source_id']['name'] ?? "";



      shippingpolicy = data['picking_policy'] ?? "";
      createdby = data['create_uid'][1] ?? "";
      createdon = data['create_date'] ?? "";
      lastupdatedby= data['write_uid'][1] ?? "";
      lastupdatedon= data['write_date'] ?? "";
      salespersonimg = data['image'] ?? "";


      for (int i = 0; i < data['order_line'].length; i++) {
        orderLineProducts.add(data['order_line'][i]);
      }


      for (int i = 0; i < data['sale_order_option_ids'].length; i++) {
        optionalProducts.add(data['sale_order_option_ids'][i]);
      }


      if(data["tag_ids"].length>0){
        //tags=snapshot.data![index]["tag_ids"][0]["name"].toString();
        tagss=data["tag_ids"];
      }
      else{
        tagss = [];
      }
      print(orderLineProducts);
      print(optionalProducts);
      print("initial data");




      attachmentCount = (data["message_attachment_count"] ?? "0").toString();

      _isInitialized = true;
    });


  }

  _buildOrderPopupDialog(BuildContext context, int typeIds) {

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(




        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          //color: Colors.green,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 250),
                  child: IconButton(
                    icon: Image.asset(
                      "images/cross.png",
                      color: Colors.black,
                    ),
                    onPressed: () {

                      setState(() {

                      });


                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: SearchChoices.single(
                    //items: items,

                    value: activityTypeName,
                    hint: Text(
                      "Activity Type",
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                    searchHint: null,
                    autofocus: false,
                    onChanged: (value) async {
                      setState(() {
                        print(value['capital']);

                        activityTypeName = value;
                        activityTypeId = value["id"];
                        activityTypeNameCategory = value["category"];



                        if(activityTypeNameCategory == "default"){
                          scheduleBtn=true;
                          opencalendarBtn= false;
                          btntext = "Schedule";
                          meetingColum = true;
                        }
                        else if(activityTypeNameCategory == "phonecall"){
                          scheduleBtn=true;
                          opencalendarBtn= true;
                          btntext = "Save";
                          meetingColum = true;
                        }
                        else if(activityTypeNameCategory == "meeting"){
                          scheduleBtn=false;
                          opencalendarBtn= true;
                          btntext = "Schedule";
                          meetingColum = false;
                        }
                        else if(activityTypeNameCategory == "upload_file"){
                          scheduleBtn=true;
                          opencalendarBtn= false;
                          btntext = "Schedule";
                          meetingColum = true;
                        }


                        print(activityTypeName);
                        print(activityTypeId);
                      });
                      await productDefaultDetails();
                    },

                    dialogBox: false,
                    isExpanded: true,
                    menuConstraints:
                    BoxConstraints.tight(const Size.fromHeight(300)),
                    itemsPerPage: 10,
                    currentPage: currentPage,
                    selectedValueWidgetFn: (item) {
                      return (Center(
                          child: Container(
                            width: 300,
                            child: Text(
                              item["name"],
                              style: TextStyle(
                                  fontSize: 10, color: Colors.black),
                            ),
                          )));
                    },
                    futureSearchFn: (String? keyword,
                        String? orderBy,
                        bool? orderAsc,
                        List<Tuple2<String, String>>? filters,
                        int? pageNb) async {
                      Response response = await get(
                        Uri.parse(
                            "${baseUrl}api/activity_type?res_model=sale.order&page_no=${pageNb ??
                                1}&count=10${keyword == null
                                ? ""
                                : "&filter=$keyword"}"),
                        headers: {
                          'Authorization': 'Bearer $token',
                        },
                      ).timeout(const Duration(
                        seconds: 10,
                      ));

                      if (response.statusCode != 200) {
                        throw Exception("failed to get data from internet");
                      }

                      dynamic data = jsonDecode(response.body);

                      int nbResults = data["length"];

                      List<DropdownMenuItem> results =
                      (data["records"] as List<dynamic>)
                          .map<DropdownMenuItem>((item) =>
                          DropdownMenuItem(
                            value: item,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Text("${item["name"]}"),
                              ),
                            ),
                          ))
                          .toList();
                      return (Tuple2<List<DropdownMenuItem>, int>(
                          results, nbResults));
                    },
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  child: TextFormField(
                    controller: summaryController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Summary',
                        labelStyle: TextStyle(color: Colors.black,
                            fontSize: 10)),
                  ),
                ),

                Visibility(
                  visible: meetingColum,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: TextField(
                                enabled: false,
                                controller: DuedateTime,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Due Date",
                                    hintStyle: TextStyle(
                                      //fontFamily: "inter",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10,
                                        color: Colors.black))),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: SearchChoices.single(
                          //items: items,

                          value: assignedToname,
                          hint: Text(
                            "Assigned To",
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                          searchHint: null,
                          autofocus: false,
                          onChanged: (value) async {
                            setState(() {
                              print(value['capital']);

                              assignedToname = value;
                              assignedToid = value["id"];
                            });
                            await productDefaultDetails();
                          },

                          dialogBox: false,
                          isExpanded: true,
                          menuConstraints:
                          BoxConstraints.tight(const Size.fromHeight(300)),
                          itemsPerPage: 10,
                          currentPage: currentPage,
                          selectedValueWidgetFn: (item) {
                            return (Center(
                                child: Container(
                                  width: 300,
                                  child: Text(
                                    item["name"],
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black),
                                  ),
                                )));
                          },
                          futureSearchFn: (String? keyword,
                              String? orderBy,
                              bool? orderAsc,
                              List<Tuple2<String, String>>? filters,
                              int? pageNb) async {
                            Response response = await get(
                              Uri.parse(
                                  "${baseUrl}api/assigned_to?res_model=sale.order&res_id=${widget
                                      .quotationId}&page_no=${pageNb ??
                                      1}&count=10${keyword == null
                                      ? ""
                                      : "&filter=$keyword"}"),

                              // "${baseUrl}api/products?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${companyId == null ? "" : "&company_id=$companyId"}"),
                              headers: {
                                'Authorization': 'Bearer $token',
                              },
                            ).timeout(const Duration(
                              seconds: 10,
                            ));

                            if (response.statusCode != 200) {
                              throw Exception("failed to get data from internet");
                            }

                            dynamic data = jsonDecode(response.body);

                            int nbResults = data["length"];

                            List<DropdownMenuItem> results =
                            (data["records"] as List<dynamic>)
                                .map<DropdownMenuItem>((item) =>
                                DropdownMenuItem(
                                  value: item,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text("${item["name"]}"),
                                    ),
                                  ),
                                ))
                                .toList();
                            return (Tuple2<List<DropdownMenuItem>, int>(
                                results, nbResults));
                          },
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: TextFormField(
                          controller: commandsController,
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Commands',
                              labelStyle: TextStyle(color: Colors.black,
                                  fontSize: 10)),
                        ),
                      ),
                    ],
                  ),
                ),



                Visibility(
                  visible: opencalendarBtn,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: SizedBox(
                        width: 146,
                        height: 38,
                        child: ElevatedButton(
                            child: Center(
                              child: Text(
                                "Open Calendar",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () async{

                              String resmessage;
                              typeIds ==0 ? resmessage=  await activitySchedule() : resmessage=  await editactivitySchedule(typeIds);


                              int resmessagevalue = int.parse(resmessage);
                              if (resmessagevalue != 0) {
                                setState(() {});

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      // Calender(0,"",DateTime.now(),[])),

                                      Calender(widget.quotationId,"sale.order",DateTime.now(),resmessagevalue,[])),
                                );
                              }


                            },



                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF04254),
                            )),
                      ),
                    ),
                  ),
                ),



                Visibility(
                  visible: scheduleBtn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: SizedBox(
                            width: 146,
                            height: 38,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    btntext,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  String resmessage;

                                  typeIds ==0 ? resmessage=  await activitySchedule() : resmessage=  await editactivitySchedule(typeIds);
                                  //resmessage=  await activitySchedule();
                                  int resmessagevalue = int.parse(resmessage);
                                  if (resmessagevalue != 0) {
                                    await getScheduleDetails();
                                    setState(() {});

                                    Navigator.pop(context);
                                  }


                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF04254),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(width: 15,),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: SizedBox(
                            width: 146,
                            height: 38,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    "Mark as Done",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () async{

                                  String resmessage;
                                  typeIds ==0 ? resmessage=  await markDone() : resmessage=  await editMarkDone(typeIds);

                                  int resmessagevalue = int.parse(resmessage);
                                  if (resmessagevalue != 0) {

                                    await getScheduleDetails();
                                    setState(() {});

                                    Navigator.pop(context);
                                  }



                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF04254),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: SizedBox(
                          width: 146,
                          height: 38,
                          child: ElevatedButton(
                              child: Center(
                                child: Text(
                                  "Done & Schedule\n next",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () async{

                                String resmessage;
                                typeIds ==0 ? resmessage=  await markDone() : resmessage=  await editMarkDone(typeIds);

                                int resmessagevalue = int.parse(resmessage);
                                if (resmessagevalue != 0) {


                                  await defaultScheduleValues();

                                  setState(() {
                                    summaryController.text = "";
                                    commandsController.text = "";
                                    typeIds =0;
                                  });
                                  //Navigator.pop(context);
                                }





                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF04254),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Center(
                        child: SizedBox(
                          width: 146,
                          height: 38,
                          child: ElevatedButton(
                              child: Center(
                                child: Text(
                                  "Discard",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () async {
                                await  getQuotationDetails();
                                setState((){

                                });


                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF04254),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),



              ],
            ),
          ),
        ),
      );
    });
  }



  _buildMarkDoneDialog(BuildContext context, int marktypeIds) {

    print(marktypeIds);
    print("demodemo");
    return StatefulBuilder(builder: (context, setState) {
      return   AlertDialog(
        title: const Text(
            'Mark Done'),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius
                .circular(
                8)),
        content:
        Container(
          height:
          60,
          width: MediaQuery
              .of(
              context)
              .size
              .width,
          child:
          TextField(
            controller:
            feedbackController,
            decoration:
            InputDecoration(
              //border: OutlineInputBorder(),
              hintText:
              'Write Feedback',
            ),
          ),
        ),
        actions: <
            Widget>[
          Row(
            children: [
              SizedBox(
                width: MediaQuery
                    .of(
                    context)
                    .size
                    .width /
                    2.8,
                height: 38,
                child: ElevatedButton(
                    child: Center(
                      child: Text(
                        "Done & Schedule Next",
                        style: TextStyle(
                            fontWeight: FontWeight
                                .w700,
                            fontSize: 10,
                            color: Colors
                                .white),
                      ),
                    ),
                    onPressed: () async {

                      String  resmessage =   await markDoneScheduleActivity(feedbackController.text, marktypeIds);


                      int resmessagevalue = int.parse(resmessage);
                      if (resmessagevalue != 0) {

                        feedbackController.text = "";
                        Navigator.pop(context);
                        await getScheduleDetails();


                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildOrderPopupDialog(
                                  context, 0
                              ),
                        ).then((value) => setState(() {}));
                      }



                    },

                    style: ElevatedButton
                        .styleFrom(
                      primary: Color(
                          0xFFF04254),
                    )),
              ),
              Padding(
                padding: const EdgeInsets
                    .only(
                    left: 5),
                child: SizedBox(
                  width: MediaQuery
                      .of(
                      context)
                      .size
                      .width /
                      6.4,
                  height: 38,
                  child: ElevatedButton(
                      child: Center(
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w700,
                              fontSize: 10,
                              color: Colors
                                  .white),
                        ),
                      ),
                      onPressed: () async {

                        String  resmessage =   await markDoneScheduleActivity(feedbackController.text, marktypeIds);


                        int resmessagevalue = int.parse(resmessage);
                        if (resmessagevalue != 0) {
                          feedbackController.text = "";
                          await getScheduleDetails();
                          setState(() {

                            Navigator.pop(context);
                          });



                        }


                      },

                      style: ElevatedButton
                          .styleFrom(
                        primary: Color(
                            0xFFF04254),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets
                    .only(
                    left: 5),
                child: SizedBox(
                  width: MediaQuery
                      .of(
                      context)
                      .size
                      .width /
                      5,
                  height: 38,
                  child: ElevatedButton(
                      child: Center(
                        child: Text(
                          "Discard",
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .w700,
                              fontSize: 10,
                              color: Colors
                                  .black),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator
                              .pop(
                              context);
                        });
                      },
                      style: ElevatedButton
                          .styleFrom(
                        primary: Color(
                            0xFFFFFFFF),
                      )),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }





  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String expirationDate = DateFormat("yyyy-MM-dd").format(_selectedDate!);

        DuedateTimeFinal = expirationDate;
        DuedateTime.text = expirationDate;

        print(expirationDate);
        print('expiration date');
      });
    }
  }







  getScheduleDetails() async {

    var datas = await getScheduleActivityData(widget.quotationId, "sale.order");

    String scheduleIcpnValue;

    setState(() {
      scheduleLength = datas['length']??0 ;
      scheduleData = datas;
      scheduleOverdue = datas['overdue']??0 ;
      scheduleToday = datas['today']??0 ;
      schedulePlanned = datas['planned']??0 ;
      // scheduleIcpnValue = datas['planned']??0

      scheduleOverdue!=0 ? scheduleVisibiltyOverdue = true :scheduleVisibiltyOverdue=false;
      scheduleToday!=0 ? scheduleVisibiltyToday=true :scheduleVisibiltyToday=false;

      schedulePlanned!=0 ? scheduleVisibiltyPlanned=true : scheduleVisibiltyPlanned=false;



      scheduleIcon= Icon(Icons.add,
        color: Colors.white,
        size: 8,

      );


      _isInitialized = true;
    });




    print(scheduleData);

    return scheduleData;




  }






  leadLost(bool valueType) async {
    String value = await lostLead(widget.quotationId, valueType);

    print(value);
    print("valuesss");
    return value;
  }

  productDefaultDetails() {}



  activitySchedule() async {

    String value = await scheduleActivity(activityTypeId, assignedToid,widget.quotationId,
        summaryController.text,DuedateTime.text,commandsController.text,"sale.order","");

    print(value);
    print("valuesss");
    return value;
  }

  editactivitySchedule(int typeIds) async {

    String value = await editScheduleActivity(activityTypeId, assignedToid,widget.quotationId,
        summaryController.text,DuedateTime.text,commandsController.text,"sale.order","",typeIds);

    print(value);
    print("valuesss");
    return value;
  }




  markDone() async {

    String value = await scheduleActivity(activityTypeId, assignedToid,widget.quotationId,
        summaryController.text,DuedateTime.text,commandsController.text,"sale.order","mark_done");

    print(value);
    print("valuesss");
    return value;
  }

  editMarkDone(int typeIds) async {

    String value = await editScheduleActivity(activityTypeId, assignedToid,widget.quotationId,
        summaryController.text,DuedateTime.text,commandsController.text,"sale.order","mark_done",typeIds);

    print(value);
    print("valuesss");
    return value;
  }

  logNoteData(List myData1) async{

    String value = await logNoteCreate(lognoteController.text,"sale.order",widget.quotationId,myData1);

    print(value);
    print("valuesss");
    return value;

  }
  void myAlert(String modelType) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      modelType == "lognote"
                          ? getImages()
                          : getImagesAttachment();
                      //getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      print("system 2");
                      modelType == "lognote"
                          ? getImage(ImageSource.camera)
                          : getImageAttachment(ImageSource.camera);

                      //getImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    setState(() {
      isLoading = true;
    });
    print("system 1");
    // var img = await picker.pickImage(source: media));
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print("system 2");
    // var img = await picker.pickMultiImage();

    if (img != null) {
      setState(
            () {
          if (imageData.isNotEmpty) {
            print("system 3");
            for (var i = 0; i < imageData.length; i++) {
              selectedImages.add(File(imageData[i].path));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    }
    print(selectedImages);
    print("system 4");

    setState(() {
      isLoading = false;
    });
  }

  //
  Future getImages() async {
    final pickedFile = await picker.pickMultipleMedia(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
          () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future getImageAttachment(ImageSource media) async {
    setState(() {
      isLoading = true;
    });
    print("system 1");
    // var img = await picker.pickImage(source: media));
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print("system 2");
    if (img != null) {
      Uint8List imagebytes = await img!.readAsBytes(); //convert to bytes
      base64string = base64.encode(imagebytes);
      String dataImages =
          '{"name":"name","type":"binary","datas":"${base64string
          .toString()}","res_model":"sale.order","res_id":"${widget.quotationId}"}';

      Map<String, dynamic> jsondata =
      jsonDecode(dataImages);
      myData1.add(jsondata);
    }

    String attachCount =  await attchmentDataCreate(myData1);
    setState(() {
      myData1.clear();
      attachmentCount = attachCount;
    });
    setState(() {
      isLoading = false;
    });
  }


  Future getImagesAttachment() async {
    final pickedFile = await picker.pickMultipleMedia(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
          () {
        isLoading = true;
      },);

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        Uint8List imagebytes = await xfilePick[i]!
            .readAsBytes(); //convert to bytes
        base64string = base64.encode(imagebytes);
        String dataImages =
            '{"name":"name","type":"binary","datas":"${base64string
            .toString()}","res_model":"sale.order","res_id":"${widget.quotationId}"}';

        Map<String, dynamic> jsondata =
        jsonDecode(dataImages);
        myData1.add(jsondata);

        //attachmentSelectedImages.add(File(xfilePick[i].path));
      }
      String attachCount =   await attchmentDataCreate(myData1);
      setState(() {
        myData1.clear();
        attachmentCount = attachCount;
      });
      setState(() {
        isLoading = false;
      });
      print(myData1);
      print("listarraycheck");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')));
    }
  }




  defaultScheduleValues() async {
    token = await getUserJwt();

    var data = await defaultScheduleData(widget.quotationId, "sale.order");
    print(data['activity_type_id']);
    print("hgchgvhjb");
    setState(() {

      activityTypeName = data['activity_type_id']??null;
      activityTypeId = data['activity_type_id']['id']??null;
      activityTypeNameCategory = data['activity_type_id']['category']??"";
      assignedToname= data['user_id']??null;
      assignedToid = data['user_id']['id']??null;
      DuedateTime.text = data['date_deadline']??"";

      // DuedateTime.text == "default" ?
      if(activityTypeNameCategory == "default"){
        scheduleBtn=true;
        opencalendarBtn= false;
        btntext = "Schedule";
        meetingColum = true;
      }
      else if(activityTypeNameCategory == "phonecall"){
        scheduleBtn=true;
        opencalendarBtn= true;
        btntext = "Save";
        meetingColum = true;
      }
      else if(activityTypeNameCategory == "meeting"){
        scheduleBtn=false;
        opencalendarBtn= true;
        btntext = "Schedule";
        meetingColum = false;
      }
      else if(activityTypeNameCategory == "upload_file"){
        scheduleBtn=true;
        opencalendarBtn= false;
        btntext = "Schedule";
        meetingColum = true;
      }





      print(activityTypeNameCategory);
      print("jhbvjbvsvj");
    });
  }


}
