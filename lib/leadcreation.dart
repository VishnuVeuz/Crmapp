import 'dart:convert';

import 'package:crm_project/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'bottomnavigation.dart';
import 'drawer.dart';
import 'globals.dart';
import 'lead_detail.dart';
import 'leadmainpage.dart';
import 'globals.dart' as globals;
import 'notificationactivity.dart';


class LeadCreation extends StatefulWidget {

  var leadId;
  LeadCreation(this.leadId);

  @override
  State<LeadCreation> createState() => _LeadCreationState();
}

class _LeadCreationState extends State<LeadCreation> {
  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  dynamic titleName,titleId,countryName,countryId,stateName,stateId,
      languageName,languageId,salespersonName,salespersonId,salesteamName,
      salesteamId,campaignName,campaignId,campanyName,companyId,
      mediumName,mediumId,sourceName,sourceId;

  TextEditingController leadnameController = TextEditingController();
  TextEditingController probabilityController = TextEditingController();
  TextEditingController companynameController = TextEditingController();
  TextEditingController contactnameController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController streettwoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailccController = TextEditingController();
  TextEditingController jobpositionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  //TextEditingController languageController = TextEditingController();
  TextEditingController refferedbyController = TextEditingController();
  TextEditingController internalnotesController = TextEditingController();

  String notificationCount="0";
  String messageCount="0";

  final _formKey = GlobalKey<FormState>();

  late String rtaingValue = "0";
  String? token, baseUrl;

  bool _isInitialized = false;
  List tags = [];
  List seectedTag = [];
  List<ValueItem> editTagName = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.leadId==0 ? defaultvalues() : getLeadDetails();
    print(Navigator.of(context).toString());
    print("Navigator.of(context).toString()");

  }





  @override
  Widget build(BuildContext context) {
    

    if (!_isInitialized) {
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
              Text("Create Leads", style: TextStyle(
                  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.none),)
            ],
          ),
          leading: Builder(
            builder: (context) =>
                Padding(
                  padding: const EdgeInsets.only(left:17),
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
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 0),
                  //   child: IconButton(icon: SvgPicture.asset("images/messages.svg"),
                  //     onPressed: () {
                  //
                  //     },
                  //   ),
                  // ),
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
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Color(0xFFFA256B),
                              ),
                              child: Center(child: Text(messageCount,style: TextStyle(color: Colors.white,fontSize: 8),)),
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
                              width: 18.0,
                              height: 18.0,
                              decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Color(0xFFFA256B),
                              ),
                              child: Center(child: Text(notificationCount,style: TextStyle(color: Colors.white,fontSize: 8),)),
                            ),
                          ),
                        ]
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Form(
            key: _formKey,
            child:  WillPopScope(
              onWillPop: () async {
                print("fibbjbj");

                return true;
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LeadMainPage()));
                // return true;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [


                  Expanded(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,

                      //color: Colors.cyan,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(

                                validator: (value) {
                                  print(value);
                                  print("svdsdvbfd");
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the name';
                                  }
                                  return null;
                                },
                                controller: leadnameController,
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Color(0xFF1E1E1E),fontWeight: FontWeight.w500),
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Lead Name',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: probabilityController,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                                    labelText: 'Probability',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: companynameController,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Company Name',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),

                            //title


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Title',
                                        isDense: true,
                                          labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                         fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: titleName,
                                // hint: Text("Title",
                                //   style: TextStyle(fontSize: 5, color: Colors.black,fontFamily: 'Mulish'),),
                                searchHint: null,

                                autofocus: true,
                                onChanged: (value) {

                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    titleName = value;
                                    titleId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                       // width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&model=res.partner.title"),
                                    headers: {

                                      'Authorization': 'Bearer $token',

                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }

                                  dynamic data = jsonDecode(response.body);

                                  int nbResults = data["length"];

                                  List<DropdownMenuItem> results = (data["record"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                "${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),),

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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: contactnameController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Contact Name',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              child: Text(
                                "Address", style: TextStyle(fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),fontFamily: 'Proxima Nova'),),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: streetController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Street',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: streettwoController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Street2',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: cityController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'City',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),
                            //country

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Country',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: countryName,
                                // hint: Text("Country",
                                //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),),


                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    countryName = value;
                                    countryId = value['id'];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                        //width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);


                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&model=res.country"),
                                    headers: {

                                      'Authorization': 'Bearer $token',

                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["record"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                      ))
                                      .toList();
                                  return (Tuple2<List<DropdownMenuItem>, int>(
                                      results, nbResults));
                                },
                              ),
                            ),

                            //state

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'State',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: stateName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    stateName = value;
                                    stateId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                       // width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print(countryId);
                                  print("afna");
                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/states?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}${countryId == null
                                          ? ""
                                          : "&country_id=$countryId"}"),
                                    headers: {
                                      'Authorization': 'Bearer $token',

                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["records"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),

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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: zipController,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Zip',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: websiteController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Website',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),

                            //language

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Language',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: languageName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    languageName = value;
                                    languageId = value['id'];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                       // width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");

                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&model=res.lang"),
                                    headers: {
                                      //"Content-Type": "application/json",
                                      'Authorization': 'Bearer $token',
                                      //'type': 'lead',
                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["record"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                                            // "${item["capital"]} - ${item["country"]} - ${item["continent"]} - pop.: ${item["population"]}"),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: emailController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                                    // border: UnderlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: jobpositionController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Job Position',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                keyboardType: TextInputType.phone,
                               // maxLength: 10,
                                controller: phoneController,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                                    labelText: 'Phone',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return null;
                                  }

                                  if (int.tryParse(value) == null) {
                                    return 'Phone number should only contain digits';
                                  }

                                  if (value.length < 10) {
                                    return 'Phone number should contain at least 10 digits';
                                  }

                                  return null;
                                },



                              ),),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                keyboardType: TextInputType.phone,
                               // maxLength: 10,
                                controller: mobileController,
                                decoration: const InputDecoration(
                                    counterText: "",
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                                    labelText: 'Mobile',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return null;
                                  }

                                  if (int.tryParse(value) == null) {
                                    return 'Mobile number should only contain digits';
                                  }

                                  if (value.length < 10) {
                                    return 'Mobile number should contain at least 10 digits';
                                  }

                                  return null;
                                },

                              ),),


                            //company
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Company',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: campanyName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    campanyName = value;
                                    companyId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                       // width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        //color: Colors.red,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");


                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/companies?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&company_ids=${globals.selectedIds}"),
                                    headers: {

                                      'Authorization': 'Bearer $token',

                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["records"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Salesperson',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: salespersonName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    salespersonName = value;
                                    salespersonId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                        //width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");
                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/salespersons?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}${companyId == null ? "" : "&company_id=$companyId"}"),
                                    headers: {

                                      'Authorization': 'Bearer $token',
                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["records"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                      ))
                                      .toList();
                                  return (Tuple2<List<DropdownMenuItem>, int>(
                                      results, nbResults));
                                },
                              ),
                            ),

                            //sales team

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Sales Team',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: salesteamName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    salesteamName = value;
                                    salesteamId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                        //width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");


                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/sales_teams?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword${companyId == null
                                          ? ""
                                          : "&company_id=$companyId"}"}"),
                                    headers: {

                                      'Authorization': 'Bearer $token',

                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["records"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),

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
                              padding: const EdgeInsets.only(left: 25, top: 10),
                              child: Text(

                                "Priority", style: TextStyle(color: Color(0xFF666666), fontSize: 11,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 20, top: 10),
                                child: RatingBar.builder(
                                  initialRating: double.parse(rtaingValue),
                                  itemSize: 19,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 3,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                  itemBuilder: (context, _) =>
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 10,
                                      ),
                                  onRatingUpdate: (rating) {
                                    rtaingValue = rating.toInt().toString();
                                    print(rtaingValue);
                                    print("rating");
                                  },
                                )),

                            SizedBox(height: 0,),
                            Padding(
                              padding: const EdgeInsets.only(left: 25,right: 25,bottom: 0),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Tags',
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 12,
                                        fontFamily: 'Proxima Nova',
                                        fontWeight: FontWeight.w500,

                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Container(
                                      height: 30,
                                      // color: Colors.red,
                                      child: MultiSelectDropDown.network(
                                       suffixIcon: Icons.arrow_drop_down,


                                        hint: '',




                                        borderColor: Colors.transparent,
                                        backgroundColor: Colors.grey[50],


                                        borderWidth: 0,


                                        hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 12,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        selectedOptions: editTagName
                                            .map((tag) => ValueItem( label: tag.label,value: tag.value))
                                            .toList(),

                                        onOptionSelected: (options) {
                                          print(options);
                                          tags.clear();
                                          for (var options in options) {

                                            tags.add(options.value);
                                            print('Label: ${options.label}');
                                            print('Value: ${options.value}');
                                            print(tags);
                                            print('---');
                                          }

                                        },
                                        networkConfig: NetworkConfig(


                                          url: "${baseUrl}api/tags",
                                          method: RequestMethod.get,
                                          headers: {


                                            'Authorization': 'Bearer $token',
                                          },
                                        ),

                                        responseParser: (response) {
                                          debugPrint('Response: $response');

                                          final list = (response['records'] as List<
                                              dynamic>).map((e) {
                                            var item = e as Map<String, dynamic>;
                                            return ValueItem(

                                              label: item['name'],
                                              value: item['id'].toString(),

                                            );
                                          }).toList();

                                          return Future.value(list);
                                        },


                                   chipConfig:  ChipConfig(wrapType: WrapType.scroll,

                                   ),

                                        responseErrorBuilder: ((context, body) {
                                          print(body);
                                          print(token);
                                          return const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text('Error fetching the data'),
                                          );
                                        }),


                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 25,right: 25,bottom: 0),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 0.5,
                              ),
                            ),

                            //campaign

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Campaign',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: campaignName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    campaignName = value;
                                    campaignId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                       // width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(

                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");

                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&model=utm.campaign"),
                                    headers: {

                                      'Authorization': 'Bearer $token',
                                      //'type': 'lead',
                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["record"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),

                                          ),
                                        ),
                                      ))
                                      .toList();
                                  return (Tuple2<List<DropdownMenuItem>, int>(
                                      results, nbResults));
                                },
                              ),
                            ),
                            //company

                            //medium
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Medium',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: mediumName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    mediumName = value;
                                    mediumId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                        //width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");

                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&model=utm.medium"),
                                    headers: {

                                      'Authorization': 'Bearer $token',
                                      //'type': 'lead',
                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["record"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                                          ),
                                        ),
                                      ))
                                      .toList();
                                  return (Tuple2<List<DropdownMenuItem>, int>(
                                      results, nbResults));
                                },
                              ),
                            ),
                            //source
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: SearchChoices.single(
                                icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

                                //items: items,
                                fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                  return Container(
                                    padding: const EdgeInsets.all(0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        enabledBorder:  UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                        ),
                                        labelText:'Source',
                                        isDense: true,
                                        labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                        fillColor: Colors.white,

                                      ),
                                      child: fieldWidget,
                                    ),
                                  );
                                },

                                value: sourceName,

                                searchHint: null,
                                autofocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    print(value['capital']);
                                    print("value");
                                    sourceName = value;
                                    sourceId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints: BoxConstraints.tight(
                                    const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                        //width: 320,
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Text(item["name"], style: TextStyle(
                                            fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
                                      )));
                                },
                                futureSearchFn: (String? keyword, String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  print(keyword);
                                  print("lalalalalla");
                                  String filtersString = "";


                                  print(filters);
                                  print(filtersString);
                                  print(keyword);
                                  print("afna");

                                  Response response = await get(Uri.parse(
                                      "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                          1}&count=10${keyword == null
                                          ? ""
                                          : "&filter=$keyword"}&model=utm.source"),
                                    headers: {

                                      'Authorization': 'Bearer $token',

                                    },
                                  )
                                      .timeout(const Duration(
                                    seconds: 10,
                                  ));


                                  print(response.toString());
                                  print("datatatapassss");
                                  if (response.statusCode != 200) {
                                    throw Exception("failed to get data from internet");
                                  }
                                  print("fjbnkdttthgfgyv");
                                  dynamic data = jsonDecode(response.body);
                                  print(data);
                                  print("fjbnkdttt");
                                  int nbResults = data["length"];
                                  print("fjbnkd");
                                  List<DropdownMenuItem> results = (data["record"] as List<
                                      dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(

                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(
                                                " ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),

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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                controller: refferedbyController,
                                decoration: const InputDecoration(
                                    enabledBorder:  UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                                    // border: UnderlineInputBorder(),
                                    labelText: 'Reffered by',
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                                ),
                              ),),




                            Padding(
                              padding: const EdgeInsets.only(left: 25,right: 25,bottom: 10),
                              child: Container(
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    1,


                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0),
                                  child: TextField(
                                      textAlignVertical:
                                      TextAlignVertical.top,
                                      style: TextStyle(
                                          fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500
                                      ),


                                      maxLines: null,
                                      controller: internalnotesController,


                                      decoration: const InputDecoration(
                                  enabledBorder:  UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                              ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                                // border: UnderlineInputBorder(),
                                labelText: 'Internal Notes',
                                labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)
                            ),


                                  ),
                                ),
                              ),
                            ),







                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 15, right: 25,bottom: 30),
                    child: SizedBox(
                      //width: 360,
                      height: 47,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,

                      child: ElevatedButton(

                          child: Text("Save", style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.57,
                              color: Colors.white,fontFamily: 'Proxima Nova'),),

                          onPressed: () async {



                            if (_formKey.currentState!.validate() && leadnameController.text.trim().isNotEmpty) {


                              setState(() {
                                _isInitialized = false;
                              });

                              String resmessage;

                              widget.leadId==0 ?  resmessage=await leadCreate() :resmessage= await leadEdit();


                              print(resmessage);

                              print("titleId");



                              int resmessagevalue = int.parse(resmessage);
                              if(resmessagevalue != 0){

                                setState(() {
                                  _isInitialized = true;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LeadDetail(resmessagevalue)),);

                              }

                              print("finalalalalalalal");
                            }
                            else{
                              print("finalalalalalalal11111");
                            }


                          },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13), // <-- Radius
                          ),
                          primary:  Color(0xFF043565),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar:MyBottomNavigationBar(1),
      );
    }
  }

  void defaultvalues() async{

    try{

    token = await getUserJwt();
     baseUrl= await getUrlString();
    var data =  await defaultDropdown("crm.lead");
    setState(() {
      print(data);

      campanyName = data['company_id'];
      companyId = data['company_id']['id']??null;

      salesteamName = data['team_id'];
      salesteamId = data['team_id']['id']??null;

      salespersonName = data['user_id'];
      salespersonId = data['user_id']['id']??null;

      probabilityController.text = data['probability'].toString()??"0.0";
      _isInitialized = true;

    });

    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();

    print(token);

    }catch (e) {
      // Handle the exception and show the API error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to load default values. Error: ${e.toString()}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeadMainPage()));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  void getLeadDetails() async{

    token = await getUserJwt();
     baseUrl= await getUrlString();
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    var data =  await getLeadData(widget.leadId,"");
    setState(() {

      leadnameController.text=data['name'].toString();
      probabilityController.text = data['probability'].toString()??"0";
      companynameController.text = data["partner_name"]??"";
      titleName=data['title']??"";
      titleId=data['title']['id']??null;
      print("title idsassss");
      print(titleName);
      print(titleId);
      contactnameController.text = data['contact_name']??"";
      streetController.text = data['street']??"";
      streettwoController.text = data['street2']??"";
      cityController.text = data['city']??"";
      stateName=data['state_id']??"";
      stateId=data['state_id']['id']??null;
      zipController.text = data['zip']??"";
      countryName=data['country_id']??"";
      countryId=data['country_id']['id']??null;
      websiteController.text = data['website']??"";
      languageName=data['lang_id']??"";
      languageId=data['lang_id']['id']??null;
      emailController.text = data['email_from']??"";
      emailccController.text = data['email_cc']??"";
      jobpositionController.text=data['function']??"";
      phoneController.text = data['phone']??"";
      mobileController.text =data['mobile']??"";
      salespersonName=data['user_id']??"";
      salespersonId=data['user_id']['id']??null;
      salesteamName=data['team_id']??"";
      salesteamId=data['team_id']['id']??null;
      //priorityController.text=data['priority'].toString();
      campaignName=data['campaign_id']??"";
      campaignId=data['campaign_id']['id']??null;
      campanyName=data['company_id']??"";
      companyId=data['company_id']['id']??null;
      mediumName=data['medium_id']??"";
      mediumId=data['medium_id']['id']??null;
      sourceName=data['source_id']??"";
      sourceId=data['source_id']['id']??null;
      refferedbyController.text = data['referred']??"";
      internalnotesController.text = data['description'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')??"";
      rtaingValue = data['priority']??"0";

      for(int i=0;i<data['tag_ids'].length;i++)
      {
        seectedTag.add(data['tag_ids'][i]);
      }


      for(int i=0;i<seectedTag.length;i++){
        editTagName.add(new ValueItem(label: seectedTag[i]['name'],value:seectedTag[i]['id'].toString() ));
      }

      tags = editTagName.map((item) => item.value).toList();




      _isInitialized = true;

    });


    print(token);


  }

  leadCreate() async {
    try{
    String value= await createLead(leadnameController.text, emailController.text, emailccController.text, contactnameController.text,
        companynameController.text, phoneController.text, rtaingValue, languageId, streetController.text, streettwoController.text,
        cityController.text, websiteController.text, jobpositionController.text, refferedbyController.text, internalnotesController.text,
        companyId, salespersonId, salesteamId, double.parse(probabilityController.text), stateId, zipController.text,
        countryId, mobileController.text, tags, titleId, mediumId, sourceId, campaignId);

    return value;
    }catch (e) {
      // Handle the exception and show the API error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('${e.toString()}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeadMainPage()));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }


  }

  leadEdit() async{


try{
    String value =await editLead(leadnameController.text, emailController.text, emailccController.text, contactnameController.text,
        companynameController.text, phoneController.text, rtaingValue, languageId, streetController.text, streettwoController.text,
        cityController.text, websiteController.text, jobpositionController.text, refferedbyController.text, internalnotesController.text,
        companyId, salespersonId, salesteamId, double.parse(probabilityController.text), stateId, zipController.text,
        countryId, mobileController.text, tags, titleId, mediumId, sourceId, campaignId,widget.leadId);

    return value;
}catch (e) {
  // Handle the exception and show the API error message to the user
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text('${e.toString()}'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeadMainPage()));
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

  }

//leadCreate() async {}

}
