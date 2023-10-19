import 'dart:convert';

import 'package:crm_project/opportunity_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'drawer.dart';
import 'globals.dart';
import 'notification.dart';
import 'notificationactivity.dart';

class OpportunityCreation extends StatefulWidget {
  var opportunityId;
  OpportunityCreation(this.opportunityId);

  @override
  State<OpportunityCreation> createState() => _OpportunityCreationState();
}

class _OpportunityCreationState extends State<OpportunityCreation> {
  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  dynamic titleName,
      titleId,
      customerName,
      customerId,
      countryName,
      countryId,
      stateName,
      stateId,
      languageName,
      languageId,
      salespersonName,
      salespersonId,
      salesteamName,
      salesteamId,
      campaignName,
      campaignId,
      campanyName,
      companyId,
      mediumName,
      mediumId,
      sourceName,
      sourceId,
      pricelistName,
      pricelistId;

  dynamic productTiltleName, productTiltleId, productUomName, productUomId;
  double? productSubTotal;
  int? productId = null;
  bool _isSavingData = false;

  String notificationCount = "0";
  String messageCount = "0";
  TextEditingController opportunitynameController = TextEditingController();
  TextEditingController expectedrevenueController = TextEditingController();
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
  TextEditingController refferedbyController = TextEditingController();
  TextEditingController internalnotesController = TextEditingController();

  TextEditingController productDescription = TextEditingController();
  TextEditingController productUnitPrice = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  List orderLineProducts = [];
  final _formKey = GlobalKey<FormState>();
  final _formKeyalert = GlobalKey<FormState>();

  Map<String, dynamic>? orderLineProductsData;

  late String rtaingValue = "0";
  String? token;
  bool _isInitialized = false;

  bool _isInitialized1 = false;

  List tags = [];
  List selctedTag = [];
  List<ValueItem> editTagName = [];

  List productTax = [];
  List selectedProductTax = [];
  List<ValueItem> editProductTaxName = [];
  List<dynamic> selectedtaxesIdFinal = [];

  List productDatas = [];


  final FocusNode _textFieldFocusNode = FocusNode();


  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    productQuantity.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.opportunityId == 0 ? defaultvalues() : getOpportunityDetails();
  }

  Widget build(BuildContext context) {
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
              Text(
                "New",
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.none),
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
                    child: Stack(alignment: Alignment.center, children: [
                      IconButton(
                        icon: SvgPicture.asset("images/messages.svg"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Notifications()));
                        },
                      ),
                      Positioned(
                        bottom: 25,
                        right: 28,
                        child: Container(
                          width: 18.0,
                          height: 18.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFA256B),
                          ),
                          child: Center(
                              child: Text(
                            messageCount,
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          )),
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    child: Stack(alignment: Alignment.center, children: [
                      IconButton(
                        icon: SvgPicture.asset("images/clock2.svg"),
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
                            shape: BoxShape.circle,
                            color: Color(0xFFFA256B),
                          ),
                          child: Center(
                              child: Text(
                            notificationCount,
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          )),
                        ),
                      ),
                    ]),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 0),
                  //   child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                  //     onPressed: () {
                  //
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
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
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.only(left: 25, top: 20, right: 25),
                child: SizedBox(
                  width: 93,
                  height: 33,
                  child: ElevatedButton(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.57,
                            color: Colors.white,
                            fontFamily: 'Mulish'),
                      ),
                      onPressed: () async {
                        // if(opportunitynameController.text!=""){
                        //   setState(() {
                        //    // isLoadingSave = true;
                        //   });
                        // }

                        if (_formKey.currentState!.validate() &&
                            opportunitynameController.text
                                .trim()
                                .isNotEmpty) {
                          setState(() {
                            _isInitialized = false;
                          });
                          String resmessage;
                          print(opportunitynameController.text);
                          print(probabilityController.text);
                          print(companynameController.text);
                          print(titleId);
                          print(contactnameController.text);
                          print(streetController.text);
                          print(streettwoController.text);
                          print(cityController.text);
                          print(countryId);
                          print(stateId);
                          print(zipController.text);
                          print(websiteController.text);
                          print(languageId);
                          print(emailController.text);
                          print(emailccController.text);
                          print(jobpositionController.text);
                          print(phoneController.text);
                          print(mobileController.text);
                          print(pricelistId);
                          print(companyId);
                          print(salespersonId);
                          print(salesteamId);
                          print(rtaingValue);
                          print(campaignId);
                          print(mediumId);
                          print(sourceId);
                          print(internalnotesController.text);
                          print(tags);

                          //resmessage=await opportunityCreate();

                          widget.opportunityId == 0
                              ? resmessage = await opportunityCreate()
                              : resmessage = await opportunityEdit();
                          print(resmessage);
                          int resmessagevalue = int.parse(resmessage);
                          if (resmessagevalue != 0) {
                            setState(() {
                              _isInitialized = true;
                            });
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => LeadFirst()),);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OpportunityDetail(resmessagevalue)),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9246A),
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the name';
                              }
                              return null;
                            },
                            controller: opportunitynameController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Opportunity Name',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: expectedrevenueController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Expected Revenue',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: probabilityController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Probability',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            validator: (value) {
                              if (value == null) {
                                return 'please select customer';
                              }
                              return null;
                            },
                            //items: items,

                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Customer',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: customerName,
                            // hint: Text(
                            //   "Customer",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                print("customer");
                                customerName = value;
                                customerId = value["id"];
                              });
                            },

                            dialogBox: false,
                            isExpanded: true,
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["display_name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              //     /api/customers?filter='lakshmi'&count=10&page_no=1&model=lead

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/customers?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=lead"),
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

                              // print(data);
                              // print("customer data");
                              int nbResults = data["length"];

                              List<DropdownMenuItem> results = (data["records"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text("${item["display_name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: companynameController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),

                                // border: UnderlineInputBorder(),
                                labelText: 'Company Name',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),

                        //title

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
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
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: titleName,
                            // hint: Text(
                            //   "Title",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                titleName = value;
                                titleId = value["id"];
                              });
                            },

                            dialogBox: false,
                            isExpanded: true,
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=res.partner.title"),
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

                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: contactnameController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Contact Name',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          child: Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: streetController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Street',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: streettwoController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Street2',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: cityController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'City',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        //country

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Country',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: countryName,
                            // hint: Text(
                            //   "Country",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                countryName = value;
                                countryId = value['id'];
                              });
                            },

                            dialogBox: false,
                            isExpanded: true,
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              print(keyword);
                              print("lalalalalla");
                              String filtersString = "";

                              print(filters);
                              print(filtersString);
                              print(keyword);

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=res.country"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(

                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'State',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: stateName,
                            // hint: Text(
                            //   "State",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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
                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/states?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${countryId == null ? "" : "&country_id=$countryId"}"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["records"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: zipController,
                            maxLength: 6,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Zip',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: websiteController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Website',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),

                        //language

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Language',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: languageName,
                            // hint: Text(
                            //   "Language",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=res.lang"),
                                headers: {
                                  //"Content-Type": "application/json",
                                  'Authorization': 'Bearer $token',
                                  //'type': 'lead',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),

                                // border: UnderlineInputBorder(),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //       const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                        //   child: TextFormField(
                        //     style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                        //     controller: emailccController,
                        //     decoration: const InputDecoration(
                        //         enabledBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                        //         ),
                        //         focusedBorder: UnderlineInputBorder(
                        //           borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        //         ),
                        //
                        //         // border: UnderlineInputBorder(),
                        //         labelText: 'EmailCc',
                        //         labelStyle: TextStyle(
                        //             color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                        //   ),
                        // ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: jobpositionController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Job Position',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                           // maxLength: 10,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Phone',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
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

                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: mobileController,
                            keyboardType: TextInputType.phone,
                          //  maxLength: 10,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Mobile',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
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




                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Pricelist',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: pricelistName,
                            // hint: Text(
                            //   "Pricelist",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                pricelistName = value;
                                pricelistId = value["id"];
                              });
                            },

                            dialogBox: false,
                            isExpanded: true,
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              //     /api/customers?filter='lakshmi'&count=10&page_no=1&model=lead
                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword${companyId == null ? "" : "&company_id=$companyId"}"}&model=product.pricelist"),
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
                              // print(data);
                              // print("customer data");
                              int nbResults = data["length"];

                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Company',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: campanyName,
                            // hint: Text(
                            //   "Company",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/companies?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&company_ids=[1]"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["records"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Salesperson',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },


                            value: salespersonName,
                            // hint: Text(
                            //   "Salesperson",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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
                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/salespersons?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${companyId == null ? "" : "&company_id=$companyId"}"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["records"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Sales Team',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: salesteamName,
                            // hint: Text(
                            //   "Sales Team",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/sales_teams?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword${companyId == null ? "" : "&company_id=$companyId"}"}"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["records"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                            "Priority",
                            style: TextStyle(
                                color: Color(0xFF666666), fontSize: 11,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20, top: 10),
                            child: RatingBar.builder(
                              initialRating: 0,
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
                              ),
                              onRatingUpdate: (rating) {
                                rtaingValue = rating.toInt().toString();
                                print(rtaingValue);
                                print("rating");
                              },
                            )),

                        SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,bottom: 0),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal:17, vertical:5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:8),
                                child: Text(
                                  'Tags',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 12,
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w500,

                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                  height: 30,
                                  child: MultiSelectDropDown.network(
                                    hint: '',
                                    borderColor: Colors.transparent,
                                    backgroundColor: Colors.grey[50],
                                    borderWidth: 0,
                                    hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    selectedOptions: editTagName
                                        .map((tag) =>
                                            ValueItem(label: tag.label, value: tag.value))
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
                                    chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                                    responseParser: (response) {
                                      debugPrint('Response: $response');

                                      final list =
                                          (response['records'] as List<dynamic>).map((e) {
                                        final item = e as Map<String, dynamic>;
                                        return ValueItem(
                                          label: item['name'],
                                          value: item['id'].toString(),
                                        );
                                      }).toList();

                                      return Future.value(list);
                                    },
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Campaign',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: campaignName,
                            // hint: Text(
                            //   "Campaign",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=utm.campaign"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                  //'type': 'lead',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Medium',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: mediumName,
                            // hint: Text(
                            //   "Medium",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=utm.medium"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                  //'type': 'lead',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                          padding:
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Source',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: sourceName,
                            // hint: Text(
                            //   "Source",
                            //   style: TextStyle(
                            //       fontSize: 12,
                            //       color: Colors.black,
                            //       fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
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
                            menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                            itemsPerPage: 10,
                            currentPage: currentPage,
                            selectedValueWidgetFn: (item) {
                              return (Center(
                                  child: Container(
                                width: 320,
                                child: Text(
                                  item["name"],
                                  style: TextStyle(
                                      fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
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

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=utm.source"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                },
                              ).timeout(const Duration(
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
                              List<DropdownMenuItem> results = (data["record"]
                                      as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                              const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                            controller: refferedbyController,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),

                                // border: UnderlineInputBorder(),
                                labelText: 'Reffered by',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),



                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25),
                          child: Container(
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                1,

                            // height: 40,
                            //color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0),
                              child: TextField(
                                  textAlignVertical:
                                  TextAlignVertical.top,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Mulish',
                                    fontSize: 11,
                                    color: Color(0xFF000000),
                                  ),


                                  maxLines: null,
                                  controller: internalnotesController,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                    ),

                                    // border: UnderlineInputBorder(),
                                    labelText: 'Internal Notes',
                                    labelStyle: TextStyle(
                                        color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 25,right: 25,bottom: 20),
                        //   child: Divider(
                        //     color: Colors.grey,
                        //     thickness: 0.5,
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 30),
                          child: Center(
                            child: SizedBox(
                              width: 346,
                              height: 33,
                              child: ElevatedButton(
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white,
                                        fontFamily: 'Mulish'),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      productId = null;
                                    });

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildOrderPopupDialog(context, -1),
                                    ).then((value) => setState(() {}));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFF9246A),
                                  )),
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
                              itemCount: orderLineProducts.length,
                              itemBuilder: (BuildContext context, int index) {
                                orderLineProductsData = orderLineProducts[index];

                                return InkWell(
                                    onTap: () {
                                      print(index);
                                      print("listindex");
                                      print(orderLineProducts[index]);
                                      print(orderLineProducts[index]['product_id']
                                          ["id"]);
                                      setState(() {
                                        productTiltleName =
                                            orderLineProducts[index]['product_id'];
                                        productTiltleId = orderLineProducts[index]
                                            ['product_id']["id"];
                                        productQuantity.text =
                                            (orderLineProducts[index]
                                                        ['product_uom_qty'] ??
                                                    "0")
                                                .toString();
                                        productUnitPrice.text =
                                            (orderLineProducts[index]['price_unit'] ??
                                                    "0")
                                                .toString();
                                        productUomName =
                                            orderLineProducts[index]['product_uom'];
                                        productUomId = orderLineProducts[index]
                                            ['product_uom']['id'];
                                        productDescription.text =
                                            orderLineProducts[index]['name'];
                                        productId = orderLineProducts[index]['id'];
                                        print(productId);
                                        print("productIdproductId");

                                        for (int i = 0;
                                            i <
                                                orderLineProducts[index]['tax_id']
                                                    .length;
                                            i++) {
                                          selectedProductTax.add(
                                              orderLineProducts[index]['tax_id'][i]);
                                        }

                                        for (int i = 0;
                                            i < selectedProductTax.length;
                                            i++) {
                                          editProductTaxName.add(new ValueItem(
                                              label: selectedProductTax[i]['name'],
                                              value: selectedProductTax[i]['id']
                                                  .toString()));
                                        }

                                        productTax = editProductTaxName
                                            .map((item) => item.value)
                                            .toList();
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildOrderPopupDialog(context, index),
                                      ).then((value) => setState(() {}));

                                      print("orderLineProducts[index];");
                                    },
                                    child: Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Container(
                                            width: 490,
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 25),
                                                              child: Container(
                                                                width: 230,
                                                                child: Text(
                                                                  orderLineProductsData![
                                                                          'name'] ??
                                                                      "no dataaaaa",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Mulish'),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5,
                                                                      left: 30,
                                                                      right: 25),
                                                              child: Container(
                                                                width: 72,
                                                                child: Text(
                                                                  "sum: ${orderLineProductsData!['price_subtotal']}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),
                                                                      fontFamily:
                                                                          'Mulish'),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                                                "Quantity : ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 12,
                                                                    color: Color(
                                                                        0xFF787878),
                                                                    fontFamily:
                                                                        'Mulish'),
                                                              ),
                                                              Text(
                                                                orderLineProductsData![
                                                                            "product_uom_qty"]
                                                                        .toString() ??
                                                                    "",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 12,
                                                                    color: Color(
                                                                        0xFF787878),
                                                                    fontFamily:
                                                                        'Mulish'),
                                                              ),
                                                              Text(
                                                                " " +
                                                                        orderLineProductsData![
                                                                                    "product_uom"]
                                                                                [
                                                                                'name']
                                                                            .toString() ??
                                                                    "",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 12,
                                                                    color: Color(
                                                                        0xFF787878),
                                                                    fontFamily:
                                                                        'Mulish'),
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 0,
                                                                      left: 25),
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
                                                                            0xFF787878),
                                                                        fontFamily:
                                                                            'Mulish'),
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
                                                                            0xFF787878),
                                                                        fontFamily:
                                                                            'Mulish'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 200,
                                                                      right: 25,
                                                                      bottom: 0),
                                                              child: Container(
                                                                width: 30,
                                                                height: 30,
                                                                //color: Colors.green,
                                                                child: IconButton(
                                                                  icon: SvgPicture.asset(
                                                                      "images/trash.svg"),
                                                                  onPressed:
                                                                      () async {
                                                                    print(index);

                                                                    orderLineProducts
                                                                        .removeAt(
                                                                            index);

                                                                    await productSum(
                                                                        orderLineProducts);
                                                                    setState(() {});
                                                                    // orderLineProductsData?.removeAt(index);
                                                                    print(orderLineProducts[
                                                                            index]
                                                                        .toString());
                                                                    print(
                                                                        orderLineProducts);
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
                                    ));
                              }),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.only(left: 160, right: 25, top: 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            //height: MediaQuery.of(context).size.height / 1.8,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productDatas.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Container(
                                          // width: 490,
                                          // height:
                                          // MediaQuery.of(context).size.height / 7,
                                          color: Colors.white,
                                          child: Text(
                                            productDatas[index].toString(),
                                            style: TextStyle(fontFamily: 'Mulish'),
                                          )),
                                    ),
                                  );
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void defaultvalues() async {
    token = await getUserJwt();
    var notificationMessage = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    var data = await defaultDropdown("crm.lead");
    setState(() {
      print(data);

      campanyName = data['company_id'];
      companyId = data['company_id']['id'] ?? null;

      salesteamName = data['team_id'];
      salesteamId = data['team_id']['id'] ?? null;

      salespersonName = data['user_id'];
      salespersonId = data['user_id']['id'] ?? null;

      probabilityController.text = data['probability'].toString() ?? "0.0";
      _isInitialized = true;
    });

    print(token);
  }

  opportunityCreate() async {
    String value = await createOpportunity(
        opportunitynameController.text,
        emailController.text,
        emailccController.text,
        contactnameController.text,
        companynameController.text,
        phoneController.text,
        rtaingValue,
        languageId,
        streetController.text,
        streettwoController.text,
        cityController.text,
        websiteController.text,
        jobpositionController.text,
        refferedbyController.text,
        internalnotesController.text,
        pricelistId,
        companyId,
        salespersonId,
        salesteamId,
        double.parse(probabilityController.text),
        stateId,
        zipController.text,
        countryId,
        mobileController.text,
        tags,
        titleId,
        mediumId,
        sourceId,
        campaignId,
        customerId,
        expectedrevenueController.text == ""
            ? double.parse("0")
            : double.parse(expectedrevenueController.text),
        orderLineProducts);

    return value;
  }

  opportunityEdit() async {
    String value = await editOpportunity(
        opportunitynameController.text,
        emailController.text,
        emailccController.text,
        contactnameController.text,
        companynameController.text,
        phoneController.text,
        mobileController.text,
        rtaingValue,
        languageId,
        streetController.text,
        streettwoController.text,
        cityController.text,
        zipController.text,
        websiteController.text,
        jobpositionController.text,
        refferedbyController.text,
        internalnotesController.text,
        pricelistId,
        companyId,
        salespersonId,
        salesteamId,
        double.parse(probabilityController.text),
        stateId,
        countryId,
        tags,
        titleId,
        mediumId,
        sourceId,
        campaignId,
        customerId,
        widget.opportunityId,
        expectedrevenueController.text == ""
            ? double.parse("0")
            : double.parse(expectedrevenueController.text),
        orderLineProducts);

    return value;
  }

  void getOpportunityDetails() async {
    token = await getUserJwt();
    var notificationMessage = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    var data = await getOpportunityData(widget.opportunityId, "");
    setState(() {
      opportunitynameController.text = data['name'].toString();
      expectedrevenueController.text =
          data['expected_revenue'].toString() ?? "";
      probabilityController.text = data['probability'].toString() ?? "0";
      companynameController.text = data["partner_name"] ?? "";
      customerName = data['partner_id'] ?? "";
      customerId = data['partner_id']['id'] ?? null;
      titleName = data['title'] ?? "";
      titleId = data['title']['id'] ?? null;
      contactnameController.text = data['contact_name'] ?? "";
      streetController.text = data['street'] ?? "";
      streettwoController.text = data['street2'] ?? "";
      cityController.text = data['city'] ?? "";
      stateName = data['state_id'] ?? "";
      stateId = data['state_id']['id'] ?? null;
      zipController.text = data['zip'] ?? "";
      countryName = data['country_id'] ?? "";
      countryId = data['country_id']['id'] ?? null;
      websiteController.text = data['website'] ?? "";
      languageName = data['lang_id'] ?? "";
      languageId = data['lang_id']['id'] ?? null;
      emailController.text = data['email_from'] ?? "";
      emailccController.text = data['email_cc'] ?? "";
      jobpositionController.text = data['function'] ?? "";
      phoneController.text = data['phone'] ?? "";
      mobileController.text = data['mobile'] ?? "";
      salespersonName = data['user_id'] ?? "";
      salespersonId = data['user_id']['id'] ?? null;
      salesteamName = data['team_id'] ?? "";
      salesteamId = data['team_id']['id'] ?? null;
      campaignName = data['campaign_id'] ?? "";
      campaignId = data['campaign_id']['id'] ?? null;
      pricelistName = data['pricelist_id'] ?? "";
      pricelistId = data['pricelist_id']['id'] ?? null;
      campanyName = data['company_id'] ?? "";
      companyId = data['company_id']['id'] ?? null;
      mediumName = data['medium_id'] ?? "";
      mediumId = data['medium_id']['id'] ?? null;
      sourceName = data['source_id'] ?? "";
      sourceId = data['source_id']['id'] ?? null;
      refferedbyController.text = data['referred'] ?? "";
      internalnotesController.text =
          data['description'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ') ?? "";
      rtaingValue = data['priority'] ?? "0";

      for (int i = 0; i < data['tag_ids'].length; i++) {
        selctedTag.add(data['tag_ids'][i]);
      }

      for (int i = 0; i < selctedTag.length; i++) {
        editTagName.add(new ValueItem(
            label: selctedTag[i]['name'],
            value: selctedTag[i]['id'].toString()));
      }

      tags = editTagName.map((item) => item.value).toList();

      for (int i = 0; i < data['crm_lead_line'].length; i++) {
        orderLineProducts.add(data['crm_lead_line'][i]);
      }

      print(editTagName);
      print(campanyName);
      print(tags);
      print(countryName);
      data['tax_totals_json'].forEach((key, value) {
        print('Key: $key, Value: $value');
        productDatas.add("$key : $value");
      });

      _isInitialized = true;
    });

    print(token);
  }

  _buildOrderPopupDialog(BuildContext context, int type) {
    print(productId);
    print("idtype");
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Form(
          key: _formKeyalert,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            //color: Colors.green,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 260, right: 20),
                    child: IconButton(
                      icon: SvgPicture.asset("images/cr.svg"),
                      onPressed: () {
                        setState(() {
                          productTiltleName = null;
                          productTiltleId = null;
                          productUomName = null;
                          productUomId = null;

                          productDescription.text = "";
                          productUnitPrice.text = "";
                          productQuantity.text = "";

                          productTax.clear();
                          selectedProductTax.clear();
                          editProductTaxName.clear();
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: SearchChoices.single(
                      //items: items,
                      validator: (value) {
                        if (value == null) {
                          return 'please select product';
                        }
                        return null;
                      },

                      fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                        return Container(
                          padding: const EdgeInsets.all(0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText:'Product',
                              isDense: true,
                              labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                              fillColor: Colors.white,

                            ),
                            child: fieldWidget,
                          ),
                        );
                      },

                      value: productTiltleName,
                      // hint: Text(
                      //   "Product",
                      //   style: TextStyle(
                      //       fontSize: 13.6,
                      //       color: Colors.black,
                      //       fontFamily: 'Mulish'),
                      // ),
                      searchHint: null,
                      autofocus: false,
                      onChanged: (value) async {
                        setState(() {
                          print(value['capital']);

                          // productTax.clear();
                          // editProductTaxName.clear();
                          // selectedProductTax.clear();
                          print(productTax);
                          print(editProductTaxName);
                          print(selectedProductTax);
                          print("product valursss");

                          productTiltleName = value;
                          productTiltleId = value["id"];
                        });
                        await productDefaultDetails();
                        FocusScope.of(context).requestFocus(_textFieldFocusNode);
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
                            item["display_name"],
                            style: TextStyle(
                                fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                              "${baseUrl}api/products?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${companyId == null ? "" : "&company_id=$companyId"}"),
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

                        List<DropdownMenuItem> results = (data["records"]
                                as List<dynamic>)
                            .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                  value: item,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text("${item["display_name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
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
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),

                      focusNode: _textFieldFocusNode,
                      controller: productQuantity,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          labelText: 'Quantity',
                          labelStyle: TextStyle(
                              color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextFormField(
                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),

                      controller: productUnitPrice,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          labelText: 'Unit Price',
                          labelStyle: TextStyle(
                              color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: SearchChoices.single(
                      //items: items,
                      fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                        return Container(
                          padding: const EdgeInsets.all(0),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText:'Uom',
                              isDense: true,
                              labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                              fillColor: Colors.white,

                            ),
                            child: fieldWidget,
                          ),
                        );
                      },

                      value: productUomName,
                      // hint: Text(
                      //   "Uom",
                      //   style: TextStyle(
                      //       fontSize: 13.6,
                      //       color: Colors.black,
                      //       fontFamily: 'Mulish'),
                      // ),
                      searchHint: null,
                      autofocus: false,
                      onChanged: (value) {
                        setState(() {
                          print(value['capital']);
                          print("value");
                          productUomName = value;
                          productUomId = value["id"];
                        });
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
                                fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                              "${baseUrl}api/uom?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${productTiltleId == null ? "" : "&product_id=$productTiltleId"}"),
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

                        List<DropdownMenuItem> results = (data["records"]
                                as List<dynamic>)
                            .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                  value: item,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ))
                            .toList();
                        return (Tuple2<List<DropdownMenuItem>, int>(
                            results, nbResults));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Taxes',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 12,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w500,

                              ),
                            ),
                            Container(
                              height:30,
                              child: MultiSelectDropDown.network(
                                hint: '',
                                borderColor: Colors.transparent,
                                borderWidth: 0,
                                hintStyle:
                                    TextStyle(fontSize: 13.6, fontFamily: 'Mulish'),
                                selectedOptions: editProductTaxName
                                    .map((tag) =>
                                        ValueItem(label: tag.label, value: tag.value))
                                    .toList(),
                                onOptionSelected: (options) {
                                  print(options);
                                  productTax.clear();
                                  editProductTaxName.clear();

                                  for (var options in options) {
                                    productTax.add(options.value);

                                    editProductTaxName.add(new ValueItem(
                                        label: options.label,
                                        value: options.value.toString()));

                                    print('Label: ${options.label}');
                                    print('Value: ${options.value}');
                                    print(productTax);
                                    print(editProductTaxName);
                                    print(selectedProductTax);
                                    print('tax valuessss');
                                  }
                                },
                                networkConfig: NetworkConfig(
                                  url:
                                      "${baseUrl}api/tax?${companyId == null ? "" : "&company_id=$companyId"}",
                                  method: RequestMethod.get,
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                ),
                                chipConfig: const ChipConfig(
                                  wrapType: WrapType.scroll,
                                  autoScroll: true,
                                ),
                                responseParser: (response) {
                                  debugPrint('Response: $response');

                                  final list =
                                      (response['records'] as List<dynamic>).map((e) {
                                    final item = e as Map<String, dynamic>;
                                    return ValueItem(
                                      label: item['name'],
                                      value: item['id'].toString(),
                                    );
                                  }).toList();

                                  return Future.value(list);
                                },
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15,bottom: 0),
                        child: Divider(
                          color:  Color(0xFFAFAFAF),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextFormField(
                      controller: productDescription,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          labelText: 'Description',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 13.6,
                              fontFamily: 'Mulish')),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 8),
                        child: Center(
                          child: SizedBox(
                            width: 146,
                            height: 38,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    "Save & Close",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white,
                                        fontFamily: 'Mulish'),
                                  ),
                                ),
                                onPressed: _isSavingData
                                    ? null // Disable the button if saving is in progress
                                    : () async {
                                        print("clickkkkkkk");

                                        if (_formKeyalert.currentState!
                                            .validate()) {
                                          setState(() {
                                            _isSavingData = true;
                                          });
                                          productUnitPrice.text == ""
                                              ? productUnitPrice.text = "0"
                                              : productUnitPrice.text =
                                                  productUnitPrice.text;

                                          productQuantity.text == ""
                                              ? productQuantity.text = "1"
                                              : productQuantity.text =
                                                  productQuantity.text;

                                          String productName =
                                              productDescription.text
                                                  .toString();
                                          print(productName);
                                          print(productTax.length);
                                          print(selectedtaxesIdFinal);
                                          print(editProductTaxName);
                                          print("productnamee");

                                          for (int i = 0;
                                              i < productTax.length;
                                              i++) {
                                            String dataoTaxes =
                                                '{"id":${editProductTaxName[i].value},"name":"${editProductTaxName[i].label}"}';

                                            Map<String, dynamic> jsondata =
                                                jsonDecode(dataoTaxes);

                                            selectedtaxesIdFinal
                                                .add(dataoTaxes);

                                            print("taxesssssss");
                                          }

                                          double quantity, price;

                                          quantity = double.parse(
                                              productQuantity.text);
                                          price = double.parse(
                                              productUnitPrice.text);

                                          productSubTotal = price * quantity;

                                          String dataone =
                                              '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription.text}","product_uom_qty":${double.parse(productQuantity.text)},"product_uom":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double.parse(productUnitPrice.text)},"tax_id":${selectedtaxesIdFinal},"price_subtotal":${productSubTotal}}';

                                          Map<String, dynamic> jsondata =
                                              jsonDecode(dataone);
                                          print(dataone);
                                          print("demo datatatata");

                                          type == -1
                                              ? orderLineProducts.add(jsondata)
                                              : orderLineProducts[type] =
                                                  jsondata;
                                          print(productUomName['name']);
                                          print("demo datatatata1");
                                          // for app side

                                          print(orderLineProducts);
                                          print("orderLineProducts");

                                          await productSum(orderLineProducts);

                                          setState(() {
                                            _isSavingData = false;
                                            productTiltleName = null;
                                            productTiltleId = null;
                                            productUomName = null;
                                            productUomId = null;

                                            productDescription.text = "";
                                            productUnitPrice.text = "";
                                            productQuantity.text = "";

                                            productTax.clear();
                                            selectedProductTax.clear();
                                            editProductTaxName.clear();
                                            selectedtaxesIdFinal.clear();
                                          });

                                          Navigator.pop(context);
                                        } else {
                                          print("not validate");
                                        }
                                      },

                                // if(_formKeyalert.currentState!.validate() ) {
                                //   print(_isSavingData);
                                //   print("jkjdfkj");
                                //
                                //   if(_isSavingData == false){
                                //     print("findal adfjsf");
                                //   }
                                //
                                //
                                //   _isSavingData
                                //       ? null // Disable the button if saving is in progress
                                //       : () async{
                                //     print("clickkkkkkk");
                                //
                                //     setState(() {
                                //       _isSavingData=true;
                                //     });
                                //     productUnitPrice.text == ""
                                //         ? productUnitPrice.text = "0"
                                //         : productUnitPrice.text =
                                //         productUnitPrice.text;
                                //
                                //
                                //
                                //     productQuantity.text==""
                                //         ? productQuantity.text = "1"
                                //         : productQuantity.text =
                                //         productQuantity.text;
                                //
                                //     String productName =
                                //     productDescription.text.toString();
                                //     print(productName);
                                //     print(productTax.length);
                                //     print(selectedtaxesIdFinal);
                                //     print(editProductTaxName);
                                //     print("productnamee");
                                //
                                //     for (int i = 0; i < productTax.length; i++) {
                                //       String dataoTaxes =
                                //           '{"id":${editProductTaxName[i].value},"name":"${editProductTaxName[i].label}"}';
                                //
                                //       Map<String, dynamic> jsondata =
                                //       jsonDecode(dataoTaxes);
                                //
                                //       selectedtaxesIdFinal.add(dataoTaxes);
                                //       // print(selectedtaxesIdFinal);
                                //       // print(editProductTaxName);
                                //       print("taxesssssss");
                                //     }
                                //
                                //     double quantity, price;
                                //
                                //     quantity = double.parse(productQuantity.text);
                                //     price = double.parse(productUnitPrice.text);
                                //
                                //     productSubTotal = price * quantity;
                                //
                                //
                                //     String dataone =
                                //         '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription.text}","product_uom_qty":${double.parse(productQuantity.text)},"product_uom":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double.parse(productUnitPrice.text)},"tax_id":${selectedtaxesIdFinal},"price_subtotal":${productSubTotal}}';
                                //
                                //     Map<String, dynamic> jsondata =
                                //     jsonDecode(dataone);
                                //     print(dataone);
                                //     print("demo datatatata");
                                //
                                //
                                //
                                //     type == -1 ?
                                //     orderLineProducts.add(jsondata) :
                                //
                                //     orderLineProducts[type] = jsondata;
                                //     print(productUomName['name']);
                                //     print("demo datatatata1");
                                //     // for app side
                                //
                                //     print(orderLineProducts);
                                //     print("orderLineProducts");
                                //
                                //     await productSum(orderLineProducts);
                                //
                                //     setState(() {
                                //       _isSavingData=false;
                                //       productTiltleName = null;
                                //       productTiltleId = null;
                                //       productUomName = null;
                                //       productUomId = null;
                                //
                                //       productDescription.text = "";
                                //       productUnitPrice.text = "";
                                //       productQuantity.text = "";
                                //
                                //       productTax.clear();
                                //       selectedProductTax.clear();
                                //       editProductTaxName.clear();
                                //       selectedtaxesIdFinal.clear();
                                //     });
                                //
                                //     Navigator.pop(context);
                                //   };
                                // }
                                //

                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF9246A),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 8),
                        child: Center(
                          child: SizedBox(
                            width: 146,
                            height: 38,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    "Save & New",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white,
                                        fontFamily: 'Mulish'),
                                  ),
                                ),
                                onPressed: _isSavingData
                                    ? null // Disable the button if saving is in progress
                                    : () async {
                                  print(_formKeyalert.currentState!
                                      .validate());
                                  print("formkey validation");

                                  //_formKeyalert.currentState!.reset();

                                        if (_formKeyalert.currentState!
                                            .validate()) {
                                          setState(() {
                                            _isSavingData = true;

                                          });

                                          print(productUnitPrice.text);
                                          print("productUnitPrice.text");
                                          productUnitPrice.text == ""
                                              ? productUnitPrice.text = "0"
                                              : productUnitPrice.text =
                                                  productUnitPrice.text;


                                          productQuantity.text == ""
                                              ? productQuantity.text = "1"
                                              : productQuantity.text =
                                              productQuantity.text;


                                          String productName =
                                              productDescription.text
                                                  .toString();
                                          print(productName);
                                          print(productTax.length);
                                          print(selectedtaxesIdFinal);
                                          print(editProductTaxName);
                                          print("productnamee");

                                          for (int i = 0;
                                              i < productTax.length;
                                              i++) {
                                            String dataoTaxes =
                                                '{"id":${editProductTaxName[i].value},"name":"${editProductTaxName[i].label}"}';

                                            Map<String, dynamic> jsondata =
                                                jsonDecode(dataoTaxes);

                                            selectedtaxesIdFinal
                                                .add(dataoTaxes);
                                            print(selectedtaxesIdFinal);
                                            print(editProductTaxName);
                                            print("taxesssssss");
                                          }

                                          double quantity, price;

                                          quantity = double.parse(
                                              productQuantity.text);
                                          price = double.parse(
                                              productUnitPrice.text);

                                          productSubTotal = price * quantity;

                                          String dataone =
                                              '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription.text}","product_uom_qty":${double.parse(productQuantity.text)},"product_uom":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double.parse(productUnitPrice.text)},"tax_id":${selectedtaxesIdFinal},"price_subtotal":${productSubTotal}}';


                                          Map<String, dynamic> jsondata =
                                              jsonDecode(dataone);

                                          print(dataone);
                                          print(jsondata);
                                          print(type);
                                          print("demo datatatata");

                                          type == -1
                                              ? orderLineProducts.add(jsondata)
                                              : orderLineProducts[type] =
                                                  jsondata;
                                          print(productUomName['name']);
                                          print("demo datatatata1");
                                          // for app side

                                          print(orderLineProducts);
                                          print("orderLineProducts");


                                          await productSum(orderLineProducts);



                                          setState(() {
                                            _isSavingData = false;
                                            productTiltleName = null;
                                            productTiltleId = null;
                                            productUomName = null;
                                            productUomId = null;

                                            productDescription.text = "";
                                            productUnitPrice.text = "";
                                            productQuantity.text = "";

                                            productTax.clear();
                                            selectedProductTax.clear();
                                            editProductTaxName.clear();
                                            selectedtaxesIdFinal.clear();

                                          });

                                          // demo

                                          Future.delayed(Duration(seconds: 2), () {

                                            _formKeyalert.currentState?.reset();

                                          });

                                        }
                                        else {
                                          _formKeyalert.currentState!.reset();

                                          print("valid checkk");
                                        }

                                        // setState(() {
                                        //   _isSavingData = true;
                                        // });
                                        //
                                        // productUnitPrice.text == ""
                                        //     ? productUnitPrice.text = "0"
                                        //     : productUnitPrice.text =
                                        //         productUnitPrice.text;
                                        //
                                        // String productName =
                                        //     productDescription.text.toString();
                                        // print(productName);
                                        // print(productTax.length);
                                        // print(selectedtaxesIdFinal);
                                        // print(editProductTaxName);
                                        // print("productnamee");
                                        //
                                        // for (int i = 0;
                                        //     i < productTax.length;
                                        //     i++) {
                                        //   String dataoTaxes =
                                        //       '{"id":${editProductTaxName[i].value},"name":"${editProductTaxName[i].label}"}';
                                        //
                                        //   Map<String, dynamic> jsondata =
                                        //       jsonDecode(dataoTaxes);
                                        //
                                        //   selectedtaxesIdFinal.add(dataoTaxes);
                                        //   print(selectedtaxesIdFinal);
                                        //   print(editProductTaxName);
                                        //   print("taxesssssss");
                                        // }
                                        //
                                        // double quantity, price;
                                        //
                                        // quantity =
                                        //     double.parse(productQuantity.text);
                                        // price =
                                        //     double.parse(productUnitPrice.text);
                                        //
                                        // productSubTotal = price * quantity;
                                        //
                                        // String dataone =
                                        //     '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription.text}","product_uom_qty":${double.parse(productQuantity.text)},"product_uom":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double.parse(productUnitPrice.text)},"tax_id":${selectedtaxesIdFinal},"price_subtotal":${productSubTotal}}';
                                        //
                                        // Map<String, dynamic> jsondata =
                                        //     jsonDecode(dataone);
                                        // print(dataone);
                                        // print("demo datatatata");
                                        //
                                        // type == -1
                                        //     ? orderLineProducts.add(jsondata)
                                        //     : orderLineProducts[type] =
                                        //         jsondata;
                                        // print(productUomName['name']);
                                        // print("demo datatatata1");
                                        // // for app side
                                        //
                                        // print(orderLineProducts);
                                        // print("orderLineProducts");
                                        //
                                        // await productSum(orderLineProducts);
                                        //
                                        // setState(() {
                                        //   _isSavingData = false;
                                        //   productTiltleName = null;
                                        //   productTiltleId = null;
                                        //   productUomName = null;
                                        //   productUomId = null;
                                        //
                                        //   productDescription.text = "";
                                        //   productUnitPrice.text = "";
                                        //   productQuantity.text = "";
                                        //
                                        //   productTax.clear();
                                        //   selectedProductTax.clear();
                                        //   editProductTaxName.clear();
                                        //   selectedtaxesIdFinal.clear();
                                        // });

                                        // Navigator.pop(context);
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF9246A),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Center(
                      child: SizedBox(
                        width: 306,
                        height: 38,
                        child: ElevatedButton(
                            child: Center(
                              child: Text(
                                "Discard",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.black),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                productTiltleName = null;
                                productTiltleId = null;
                                productUomName = null;
                                productUomId = null;

                                productDescription.text = "";
                                productUnitPrice.text = "";
                                productQuantity.text = "";

                                productTax.clear();
                                selectedProductTax.clear();
                                editProductTaxName.clear();
                              });

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  productDefaultDetails() async {
    var data = await getOpportunityProductDefaultData(productTiltleId);
    setState(() {
      print("finnknkj");
      productTax.clear();
      editProductTaxName.clear();
      selectedProductTax.clear();

      productDescription.text = data['name'].toString();
      productUnitPrice.text = data['price_unit'].toString();
      productUomName = data['product_uom'][0] ?? "";
      productUomId = data['product_uom'][0]['id'] ?? null;

      for (int i = 0; i < data['tax_id'].length; i++) {
        selectedProductTax.add(data['tax_id'][i]);
      }

      for (int i = 0; i < selectedProductTax.length; i++) {
        editProductTaxName.add(new ValueItem(
            label: selectedProductTax[i]['name'],
            value: selectedProductTax[i]['id'].toString()));
      }

      productTax = editProductTaxName.map((item) => item.value).toList();
      print(productTax);
      _isInitialized = true;
    });

    //print(token);
  }

  productSum(List orderLineProductsData) async {
    productDatas.clear();
    var data = await getProductSum(orderLineProductsData, 1);
    setState(() {
      data['result']["data"].forEach((key, value) {
        print('Key: $key, Value: $value');
        productDatas.add("$key : $value");
      });

      _isInitialized = true;
    });

    //print(token);
  }
}
