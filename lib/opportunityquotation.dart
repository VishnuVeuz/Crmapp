import 'dart:convert';

import 'package:crm_project/quotation_detail.dart';
import 'package:crm_project/quotationcreation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'drawer.dart';
import 'globals.dart';
import 'notification.dart';
import 'notificationactivity.dart';
import 'opportunitymainpage.dart';
class OpportunityQuotation extends StatefulWidget {
  var opportunityId;
  OpportunityQuotation(this.opportunityId);


  @override
  State<OpportunityQuotation> createState() => _OpportunityQuotationState();
}

class _OpportunityQuotationState extends State<OpportunityQuotation> {
  String? dropdownValue, dropdownValueId = "direct";
  String? dropdownCustomerData = "";
  String notificationCount="0";
  String messageCount="0";
  TextEditingController deliveryDateTime = TextEditingController();
  TextEditingController expirationDateTime = TextEditingController();
  TextEditingController customerreference = TextEditingController();
  TextEditingController sourcedocument = TextEditingController();
  TextEditingController quotationDateTime = TextEditingController();

  TextEditingController productDescription = TextEditingController();
  TextEditingController productUnitPrice = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController leadtime = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List orderLineProducts = [];
  List optionalProducts = [];

  Map<String, dynamic>? orderLineProductsData;
  Map<String, dynamic>? optionalProductsData;
  String? productData="",productTotal="";
  List productDatas = [];

  DateTime? _selectedDate;
  var QuotationDateTimefinal, deliveryDateTimefinal, expirationDateTimefinal;

  DateTime selectedDateTime = DateTime.now();

  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  dynamic customerName,
      customerId,
      quotationtemplateName,
      quotationtemplateId,
      pricelistName,
      pricelistId,
      paymenttermsName,
      paymenttermsId,
      salespersonName,
      salespersonId,
      salesteamName,
      salesteamId,
      companyName,
      companyId,
      fiscalpositionName,
      fiscalpositionId,
      mediumName,
      mediumId,
      sourceName,
      sourceId,
      campaignName,
      campaignId;
  String? token,  baseUrl;
  List tags = [];
  List selctedTag = [];
  List<ValueItem> editTagName = [];
  bool isCheckedSignature = false;
  bool isCheckedPayment = false;
  bool _isInitialized = false;
  String picking_policy = "";




  dynamic productTiltleName, productTiltleId, productUomName, productUomId;
  double? productSubTotal;
  int? productId = null;

  List productTax = [];
  List selectedProductTax = [];
  List<ValueItem> editProductTaxName = [];
  List<dynamic> selectedtaxesIdFinal = [];

  bool optvisibility = false,ordervisibility = true;
  bool _isSavingData = false;

  final _formKeyalert = GlobalKey<FormState>();
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
    //defaultvalues();
     getOpportunityDetails();
  }


  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {

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
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                    decoration: TextDecoration.none,fontFamily: 'Mulish'),
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
                              width: 15.0,
                              height: 15.0,
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
              Expanded(

                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.cyan,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) async {
                              setState(() {
                                print("customer");
                                customerName = value;
                                customerId = value["id"];
                              });

                              await getQuotationCustomerDetail();
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["display_name"], style: TextStyle(
                                        fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600)
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
                                    "${baseUrl}api/customers?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=sale"),
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
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                value: item,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Text("${item["display_name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600),),
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
                          child: Container(
                            child: Text(dropdownCustomerData!),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
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
                                    labelText:'Quotation Template',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            //items: items,

                            value: quotationtemplateName,
                            // hint: Text(
                            //   "Quotation Template",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                quotationtemplateName = value;
                                quotationtemplateId = value["id"];
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"], style: TextStyle(
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
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=sale.order.template&company_id=$companyId"),
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
                              print(data);

                              int nbResults = data["length"];

                              List<DropdownMenuItem> results =
                              (data["record"] as List<dynamic>)
                                  .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                value: item,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w600),),
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
                          child: SizedBox(
                            child: InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: TextField(
                                  enabled: false,
                                  controller: expirationDateTime,
                                  style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Expiration Date",
                                      hintStyle: TextStyle(
                                        //fontFamily: "inter",
                                          color: Color(0xFF666666), fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w500))),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
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
                                    labelText:'Pricelist',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            //items: items,

                            value: pricelistName,
                            // hint: Text(
                            //   "Pricelist",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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

                              int nbResults = data["length"];

                              List<DropdownMenuItem> results =
                              (data["record"] as List<dynamic>)
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
                                    labelText:'Payment Terms',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            //items: items,

                            value: paymenttermsName,
                            // hint: Text(
                            //   "Payment Terms",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                paymenttermsName = value;
                                paymenttermsId = value["id"];
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
                                   // width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),                            ),
                                  )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword${companyId == null ? "" : "&company_id=$companyId"}"}&model=account.payment.term"),
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
                              (data["record"] as List<dynamic>)
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
                          child: Text(
                            "Sales",
                            style:TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
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
                                    labelText:'Salesperson',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            //items: items,
                            value: salespersonName,
                            // hint: Text(
                            //   "Salesperson",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                                   // width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(  fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                    ),
                                  )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              String token = await getUserJwt();

                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/salespersons?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${companyId == null ? "" : "&company_id=$companyId"}"),
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
                            icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
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
                                   // width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(  fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                                    "${baseUrl}api/sales_teams?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword${companyId == null ? "" : "&company_id=$companyId"}"}"),
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
                            icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
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
                            value: companyName,
                            // hint: Text(
                            //   "Company",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                print(value['capital']);
                                print("value");
                                companyName = value;
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(  fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                                    "${baseUrl}api/companies?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&company_ids=[1]"),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: Text(
                                "Online Signature",
                                style: TextStyle(
                                    color: Color(0xFF666666), fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Checkbox(
                                activeColor:  Color(0xFF043565),
                                value: isCheckedSignature,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedSignature = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: Text(
                                "Online Payment",
                                style: TextStyle(
                                    color: Color(0xFF666666), fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Checkbox(
                                activeColor:  Color(0xFF043565),
                                value: isCheckedPayment,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isCheckedPayment = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),                    controller: customerreference,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),

                                // border: UnderlineInputBorder(),
                                labelText: 'Customer Reference',
                                labelStyle:
                                TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 17, vertical: 1),
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
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w500,

                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Container(
                                  height:30,
                                  child: MultiSelectDropDown.network(
                                    hint: '',
                                    borderColor: Colors.transparent,
                                    backgroundColor: Colors.grey[50],
                                    borderWidth: 0,
                                    hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
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
                                    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
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
                          padding: const EdgeInsets.only(left: 25,right: 25,bottom: 0,top: 10),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          child: Text(
                            "Delivery",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                    ),
                                    labelText:'Shipping policy',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            // hint: Text(
                            //   "Shipping policy",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            items: list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(  fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList(),
                            value: dropdownValue,
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SizedBox(
                            child: InkWell(
                              onTap: () {
                                selectDateTime(context);
                              },
                              child: TextField(
                                  style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                  enabled: false,
                                  controller: deliveryDateTime,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Delivery Date",
                                      hintStyle: TextStyle(
                                        //fontFamily: "inter",
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10,
                                          color: Colors.black,fontFamily: 'Mulish'))),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: Text(
                            "Invoicing",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
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
                                    labelText:'Fiscal Position',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            //items: items,
                            value: fiscalpositionName,
                            // hint: Text(
                            //   "Fiscal Position",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                print(value['capital']);
                                print("value");
                                fiscalpositionName = value;
                                fiscalpositionId = value["id"];
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=account.fiscal.position&company_id=$companyId"),
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
                              print(data);
                              int nbResults = data["length"];
                              List<DropdownMenuItem> results =
                              (data["record"] as List<dynamic>)
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
                          child: Text(
                            "Tracking",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
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
                                    labelText:'Campaign',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },
                            //items: items,
                            value: campaignName,
                            // hint: Text(
                            //   "Campaign",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=utm.campaign"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                  //'type': 'lead',
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
                              (data["record"] as List<dynamic>)
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
                            icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,

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
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
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
                                    //width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
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
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=utm.medium"),
                                headers: {
                                  'Authorization': 'Bearer $token',
                                  //'type': 'lead',
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
                              (data["record"] as List<dynamic>)
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
                            icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
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
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
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
                                   // width: 320,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Text(
                                      item["name"],
                                      style: TextStyle(fontSize: 14,fontFamily: 'Mulish',color: Colors.black,fontWeight: FontWeight.w600),
                                    ),
                                  )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              // String token = await getUserJwt();
                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=utm.source"),
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
                              (data["record"] as List<dynamic>)
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
                            controller: sourcedocument,
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),

                                // border: UnderlineInputBorder(),
                                labelText: 'Source Document',
                                labelStyle:
                                TextStyle(color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500)),
                          ),
                        ),





                        Container(
                          color: Color(0xFFF6F6F6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0, bottom: 0,left: 10,right: 5),
                                child: Center(

                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: TextButton(
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
                                          primary:Color(0xFFF6F6F6),
                                        )),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 0, bottom: 0,left: 5,right: 10),
                                child: Center(

                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: TextButton(
                                        child: Text(
                                          "Optional products",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.57,
                                              color: Colors.black),
                                        ),
                                        onPressed: () {

                                          setState(() {
                                            productId = null;
                                            optvisibility = true;
                                            ordervisibility = false;
                                          });


                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFF6F6F6),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),



                        Visibility(
                          visible: ordervisibility,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1, bottom: 30,left: 25,right: 25),
                            child: Center(
                              child: SizedBox(
                                //width: 360,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 47,

                                child: ElevatedButton(
                                    child: Text(
                                      "Add orderlines",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.57,
                                          color: Colors.white),
                                    ),
                                    onPressed: () {

                                      setState(() {
                                        productId = null;
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildOrderPopupDialog(
                                                context,-1,"order"
                                            ),
                                      ).then((value) => setState(() {}));
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
                          ),
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

                                  return InkWell(
                                      onTap: () {
                                        print(index);
                                        print("listindex");
                                        print(orderLineProducts[index]);
                                        print(orderLineProducts[index]['product_id']["id"]);
                                        setState(() {
                                          productTiltleName = orderLineProducts[index]['product_id'];
                                          productTiltleId = orderLineProducts[index]['product_id']["id"];
                                          productQuantity.text = (orderLineProducts[index]['product_uom_qty']??"0").toString();
                                          productUnitPrice.text = (orderLineProducts[index]['price_unit']??"0").toString();
                                          productUomName=orderLineProducts[index]['product_uom'];
                                          productUomId = orderLineProducts[index]['product_uom']['id'];
                                          productDescription.text = orderLineProducts[index]['name'];
                                          productId = orderLineProducts[index]['id'];
                                          print(productId);
                                          print("productIdproductId");

                                          for (int i = 0; i < orderLineProducts[index]['tax_id'].length; i++) {
                                            selectedProductTax.add(orderLineProducts[index]['tax_id'][i]);
                                          }

                                          for (int i = 0; i < selectedProductTax.length; i++) {
                                            editProductTaxName.add(new ValueItem(
                                                label: selectedProductTax[i]['name'],
                                                value: selectedProductTax[i]['id'].toString()));
                                          }

                                          productTax = editProductTaxName.map((item) => item.value).toList();







                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildOrderPopupDialog(
                                                  context,index,"order"),
                                        ).then((value) => setState(() {}));

                                        print("orderLineProducts[index];");
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 1),
                                          child: Container(

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
                                                                    top: 0,
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
                                                                        Colors.black,fontFamily: 'Mulish'),
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                top: 0, left: 25),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Quantity : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),fontFamily: 'Mulish'),
                                                                ),
                                                                Text(
                                                                  orderLineProductsData![
                                                                  "product_uom_qty"]
                                                                      .toString() ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),fontFamily: 'Mulish'),
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
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),fontFamily: 'Mulish'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                top: 0, left: 25),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Container(
                                                                  // color: Colors.red,
                                                                  width: 120,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Unit Price :",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                            fontSize: 12,
                                                                            color: Color(
                                                                                0xFF787878),fontFamily: 'Mulish'),
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
                                                                            fontSize: 12,
                                                                            color: Color(
                                                                                0xFF787878),fontFamily: 'Mulish'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),


                                                                Padding(
                                                                  padding: const EdgeInsets.only(left:170,right: 25),
                                                                  child: Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    //color: Colors.green,
                                                                    child: IconButton(
                                                                      icon: SvgPicture.asset("images/trash.svg"),
                                                                      onPressed: () async{
                                                                        print(index);

                                                                        orderLineProducts
                                                                            .removeAt(
                                                                            index);

                                                                        await productSum(orderLineProducts);
                                                                        setState(() {});
                                                                        // orderLineProductsData?.removeAt(index);
                                                                        print(
                                                                            orderLineProducts[
                                                                            index]
                                                                                .toString());
                                                                        print(
                                                                            orderLineProducts);
                                                                        print(
                                                                            "datatatatatattata");
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
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
                        ),


                        // code change for products


                        Visibility(
                          visible: optvisibility,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 1, bottom: 30,left: 25,right: 25),
                            child: Center(
                              child: SizedBox(
                                //width: 346,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                height: 47,

                                child: ElevatedButton(
                                    child: Text(
                                      "Add optional products",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.57,
                                          color: Colors.white,fontFamily: 'Mulish'),
                                    ),
                                    onPressed: () {

                                      setState(() {
                                        productId = null;
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildOrderPopupDialog(
                                                context,-1,"optionjal"
                                            ),
                                      ).then((value) => setState(() {}));
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
                          ),
                        ),

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

                                  return InkWell(
                                      onTap: () {
                                        print(index);
                                        print("listindex");
                                        print(optionalProducts[index]);
                                        print(optionalProducts[index]['product_id']["id"]);
                                        setState(() {


                                          productTiltleName = optionalProducts[index]['product_id'];
                                          productTiltleId = optionalProducts[index]['product_id']["id"];
                                          productQuantity.text = (optionalProducts[index]['quantity']??"0").toString();
                                          productUnitPrice.text = (optionalProducts[index]['price_unit']??"0").toString();
                                          productUomName=optionalProducts[index]['uom_id'];
                                          productUomId = optionalProducts[index]['uom_id']['id'];
                                          productDescription.text = optionalProducts[index]['name'];
                                          productId = optionalProducts[index]['id'];
                                          print(productId);
                                          print("productIdproductId");



                                        });
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildOrderPopupDialog(
                                                  context,index,"optionjal"),
                                        ).then((value) => setState(() {}));

                                        print("orderLineProducts[index];");
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 1),
                                          child: Container(

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
                                                                    top: 0,
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
                                                                        Colors.black,fontFamily: 'Mulish'),
                                                                  ),
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                top: 0, left: 25),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  "Quantity : ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),fontFamily: 'Mulish'),
                                                                ),
                                                                Text(
                                                                  optionalProductsData![
                                                                  "quantity"]
                                                                      .toString() ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                      FontWeight.w500,
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),fontFamily: 'Mulish'),
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
                                                                      fontSize: 12,
                                                                      color: Color(
                                                                          0xFF787878),fontFamily: 'Mulish'),
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
                                                                    top: 0, left: 25),
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
                                                                          fontSize: 12,
                                                                          color: Color(
                                                                              0xFF787878),fontFamily: 'Mulish'),
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
                                                                          fontSize: 12,
                                                                          color: Color(
                                                                              0xFF787878),fontFamily: 'Mulish'),
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
                                                                    icon:SvgPicture.asset("images/trash.svg"),
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
                                      ));
                                }),
                          ),
                        ),


                        Visibility(
                          visible: ordervisibility,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 160,right: 25,top: 10),
                            child: Container(

                              width: MediaQuery.of(context).size.width/1.5,
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

                                            color: Colors.white,
                                            child: Text(
                                                productDatas[index].toString()
                                            )),
                                      ),
                                    );
                                  }),
                            ),

                          ),
                        )



                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 20, right: 25,bottom: 30),
                child: SizedBox(
                  //width: 360,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 47,
                  child: ElevatedButton(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.57,
                            color: Colors.white,fontFamily: 'Mulish'),
                      ),
                      onPressed: () async {
                        var resmessage;
                        int resmessagevalue;
                        print(customerId);
                        print(quotationtemplateId);
                        print(pricelistId);
                        print(paymenttermsId);
                        print(salespersonId);
                        print(salesteamId);
                        print(companyId);
                        print(tags);
                        print(fiscalpositionId);
                        print(campaignId);
                        print(mediumId);
                        print(sourceId);
                        print(customerreference.text);
                        print(sourcedocument.text);
                        print(expirationDateTime.text);
                        print(deliveryDateTime.text);
                        print(isCheckedSignature);
                        print(isCheckedPayment);



                        resmessage = await quotationCreate();

                        resmessage['result']['message'].toString() == "success"?
                        resmessagevalue = int.parse(resmessage['result']['data']['id'].toString()):
                        resmessage['result']['message'].toString() == "error"?
                        resmessagevalue = 0: resmessagevalue = 0;

                        // int resmessagevalue = int.parse(resmessage);
                        if (resmessagevalue != 0) {
                          setState(() {});

                          print("gggggggg");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    QuotationDetail(resmessagevalue)),
                          );
                        }
                        else{
                          String textmsg = resmessage['result']['data'].toString()??"";
                          var snackBar = SnackBar(  content: Text(textmsg),
                            backgroundColor: Colors.blueGrey,);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      );
    }
  }

Future<void> selectDateTime(BuildContext context) async {
  final DateTime? pickedDateTime = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime(2025),
  );

  if (pickedDateTime != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final DateTime combinedDateTime = DateTime(
        pickedDateTime.year,
        pickedDateTime.month,
        pickedDateTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      selectedDateTime = combinedDateTime;
      String formattedDate =
      DateFormat('yyyy-MM-dd kk:mm:ss').format(selectedDateTime);

      setState(() {
        deliveryDateTimefinal = formattedDate;
        deliveryDateTime.text = formattedDate.toString();
      });
    }
  }
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

      expirationDateTimefinal = expirationDate;
      expirationDateTime.text = expirationDate;

      print(expirationDate);
      print('expiration date');
    });
  }
}

void defaultvalues() async {
  token = await getUserJwt();
   baseUrl= await getUrlString();
  var data = await defaultDropdown("sale.order");

  print(data);
  print("default data");

  setState(() {
    print(data);

    companyName = data['company_id'];
    companyId = data['company_id']['id'] ?? null;

    salesteamName = data['team_id'];
    salesteamId = data['team_id']['id'] ?? null;

    salespersonName = data['user_id'];
    salespersonId = data['user_id']['id'] ?? null;

    isCheckedSignature = data['require_signature'] ?? false;
    isCheckedPayment = data['require_payment'] ?? false;

    picking_policy = data['picking_policy'] ?? "";

    (picking_policy == "direct")
        ? dropdownValue = list.first
        : (picking_policy == "one")
        ? dropdownValue = list.last
        : dropdownValue = list.first;

    //robabilityController.text = data['probability'].toString()??"0.0";
    _isInitialized = true;
  });

  print(token);
  print("final token ");
}


  quotationCreate() async {

    try {
      dropdownValue == "As soon as possible"
          ? dropdownValueId = "direct"
          : dropdownValueId = "one";

      print(dropdownValueId);
      print("dropdownValue");
      var value = await createQuotationOpp(
          customerId,
          quotationtemplateId,
          pricelistId,
          paymenttermsId,
          salespersonId,
          salesteamId,
          companyId,
          tags,
          fiscalpositionId,
          campaignId,
          mediumId,
          sourceId,
          customerreference.text,
          sourcedocument.text,
          expirationDateTimefinal,
          deliveryDateTimefinal,
          isCheckedSignature,
          isCheckedPayment,
          dropdownValueId!,
          orderLineProducts,
          optionalProducts,
          null

      );
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
                          builder: (context) =>   OpportunityMainPage(null,"","","","")));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

  }




void getOpportunityDetails() async {
  token = await getUserJwt();
   baseUrl= await getUrlString();
  var notificationMessage  = await getNotificationCount();

  notificationCount = notificationMessage['activity_count'].toString();

  messageCount = notificationMessage['message_count'].toString();
  var data = await getOpportunityQuotationData(widget.opportunityId, "");
  print(data);
  print("default data");

  setState(() {
    customerName = data['partner_id'] ?? "";
    customerId = data['partner_id']['id'] ?? null;
    // quotationtemplateName = data['sale_order_template_id'] ?? "";
    // quotationtemplateId = data['sale_order_template_id']['id'] ?? null;
    //expirationDateTime.text = data['validity_date'].toString();
    pricelistName = data['pricelist_id'] ?? "";
    pricelistId = data['pricelist_id']['id'] ?? null;
    print("fkjdbjksa");
    print(pricelistId);
    // paymenttermsName = data['payment_term_id'] ?? "";
    // paymenttermsId = data['payment_term_id']['id'] ?? null;
    salespersonName = data['user_id'] ?? "";
    salespersonId = data['user_id']['id'] ?? null;
    salesteamName = data['team_id'] ?? "";
    salesteamId = data['team_id']['id'] ?? null;
    companyName = data['company_id'] ?? "";
    companyId = data['company_id']['id'] ?? null;
    isCheckedSignature = data['require_signature'] ?? false;
    isCheckedPayment = data['require_payment'] ?? false;
    // customerreference.text = (data['client_order_ref'] ?? "").toString();

    for (int i = 0; i < data['tag_ids'].length; i++) {
      selctedTag.add(data['tag_ids'][i]);
    }

    for (int i = 0; i < selctedTag.length; i++) {
      editTagName.add(new ValueItem(
          label: selctedTag[i]['name'],
          value: selctedTag[i]['id'].toString()));
    }

    tags = editTagName.map((item) => item.value).toList();
    // deliveryDateTime.text = data['commitment_date'].toString();
    fiscalpositionName = data['fiscal_position_id'] ?? "";
    fiscalpositionId = data['fiscal_position_id']['id'] ?? null;
    campaignName = data['campaign_id'] ?? "";
    campaignId = data['campaign_id']['id'] ?? null;
    mediumName = data['medium_id'] ?? "";
    mediumId = data['medium_id']['id'] ?? null;
    sourceName = data['source_id'] ?? "";
    sourceId = data['source_id']['id'] ?? null;
    sourcedocument.text = (data['origin'] ?? "").toString();

    picking_policy = data['picking_policy'] ?? "";

    (picking_policy == "direct")
        ? dropdownValue = list.first
        : (picking_policy == "one")
        ? dropdownValue = list.last
        : dropdownValue = list.first;


    for (int i = 0; i < data['order_line'].length; i++) {
      orderLineProducts.add(data['order_line'][i]);
    }


    // for (int i = 0; i < data['sale_order_option_ids'].length; i++) {
    //   optionalProducts.add(data['sale_order_option_ids'][i]);
    // }


    print(orderLineProducts);
    print(optionalProducts);
    print("initial data");

    _isInitialized = true;
  });

  print(token);
}

getQuotationCustomerDetail() async {
  var data = await getQuotationCustomerData(customerId);
  setState(() {
    dropdownCustomerData = data;
  });
}

_buildOrderPopupDialog(BuildContext context,int type, String productType) {
  print(productId);
  print("idtype");
  bool tvisibility = true;

  productType == "order" ? tvisibility = true : tvisibility = false;
  productQuantity.text = "1";

  return StatefulBuilder(builder: (context, setState) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      insetPadding: EdgeInsets.all(10),
      content: Form(
        key: _formKeyalert,
        child: Container(
          width: MediaQuery.of(context).size.width,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right:8),
                  child: IconButton(
                    icon:SvgPicture.asset("images/cr.svg"),
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
                    //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                           // width: 300,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Text(
                              item["display_name"],
                              style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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

                      List<DropdownMenuItem> results =
                      (data["records"] as List<dynamic>)
                          .map<DropdownMenuItem>((item) => DropdownMenuItem(
                        value: item,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text("${item["display_name"]}"),
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
                    focusNode: _textFieldFocusNode,
                    style:  TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                    controller: productQuantity,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Quantity',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style:  TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                    controller: productUnitPrice,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Unit Price',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: SearchChoices.single(
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
                    //items: items,

                    value: productUomName,
                    // hint: Text(
                    //   "Uom",
                    //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                            //width: 300,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Text(
                              item["name"],
                              style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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

                      List<DropdownMenuItem> results =
                      (data["records"] as List<dynamic>)
                          .map<DropdownMenuItem>((item) => DropdownMenuItem(
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

                Visibility(
                  visible: tvisibility,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextFormField(
                      style:  TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                      controller: leadtime,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          labelText: 'Lead Time',
                          labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Visibility(
                  visible: tvisibility,
                  child: Padding(
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
                            hintStyle:
                            TextStyle(fontSize: 13.6, fontFamily: 'Mulish'),
                            selectedOptions: editProductTaxName
                                .map((tag) =>
                                ValueItem(label: tag.label, value: tag.value))
                                .toList(),
                            onOptionSelected: (options) {
                              print(options);
                              productTax.clear();

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
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style:  TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                    controller: productDescription,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
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
                                      color: Colors.white,fontFamily: 'Mulish'),
                                ),
                              ),
                              onPressed:_isSavingData
                                  ? null // Disable the button if saving is in progress
                                  : () async{

    if (_formKeyalert.currentState!.validate()) {
      setState(() {
        _isSavingData=true;
      });


      if( productType == "order") {
        productUnitPrice.text == ""
            ? productUnitPrice.text = "0"
            : productUnitPrice.text =
            productUnitPrice.text;

        productQuantity.text == ""
            ? productQuantity.text = "1"
            : productQuantity.text =
            productQuantity.text;


        leadtime.text == ""?
        leadtime.text = "0"
            :leadtime.text = leadtime.text;



        String productName =
        productDescription.text.toString();
        print(productName);
        print("productnamee");

        for (int i = 0; i < productTax.length; i++) {
          String dataoTaxes =
              '{"id":${editProductTaxName[i].value},"name":"${editProductTaxName[i].label}"}';

          Map<String, dynamic> jsondata =
          jsonDecode(dataoTaxes);

          selectedtaxesIdFinal.add(dataoTaxes);
          print(selectedtaxesIdFinal);
          print(editProductTaxName);
          print("taxesssssss");
        }

        double quantity, price;

        quantity = double.parse(productQuantity.text);
        price = double.parse(productUnitPrice.text);

        productSubTotal = price * quantity;

        String dataone =
            '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription.text}","product_uom_qty":${double.parse(productQuantity.text)},"customer_lead":${double.parse(leadtime.text)},"product_uom":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double.parse(productUnitPrice.text)},"tax_id":${selectedtaxesIdFinal}}';

        Map<String, dynamic> jsondata =
        jsonDecode(dataone);
        print(dataone);
        print("demo datatatata");

        type == -1 ?
        orderLineProducts.add(jsondata) :

        orderLineProducts[type] = jsondata;
        print(productUomName['name']);
        print("demo datatatata1");
        // for app side

        print(orderLineProducts);
        print("orderLineProducts");



        _isInitialized = false;
        await productSum(orderLineProducts);


      }



      if( productType == "optionjal") {
        productUnitPrice.text == ""
            ? productUnitPrice.text = "0"
            : productUnitPrice.text =
            productUnitPrice.text;


        productQuantity.text == ""
            ? productQuantity.text = "1"
            : productQuantity.text =
            productQuantity.text;


        leadtime.text == ""?
        leadtime.text = "0"
            :leadtime.text = leadtime.text;


        String productName =
        productDescription.text.toString();
        print(productName);
        print("productnamee");




        String datatwo =
            '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription.text}","quantity":${double.parse(productQuantity.text)},"uom_id":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double.parse(productUnitPrice.text)}}';


        Map<String, dynamic> jsondatatwo =
        jsonDecode(datatwo);
        print(datatwo);
        print("demo datatatatatwo");

        type == -1 ?
        optionalProducts.add(jsondatatwo) :

        optionalProducts[type] = jsondatatwo;
        print(productUomName['name']);
        print("demo datatatata1");
        // for app side

        print(optionalProducts);
        print("orderLineProducts");





      }





      setState(() {
        _isSavingData=false;
        productTiltleName = null;
        productTiltleId = null;
        productUomName = null;
        productUomId = null;

        productDescription.text = "";
        productUnitPrice.text = "";
        productQuantity.text = "";
        leadtime.text = "";

        productTax.clear();
        selectedProductTax.clear();
        editProductTaxName.clear();
        selectedtaxesIdFinal.clear();
      });

      Navigator.pop(context);
    }
    else{

    }


                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF9246A),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
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
                                      color: Colors.white,fontFamily: 'Mulish'),
                                ),
                              ),
                              onPressed: _isSavingData
                                  ? null // Disable the button if saving is in progress
                                  :() async{



    if (_formKeyalert.currentState!
        .validate()) {


      setState(() {
        _isSavingData=true;
      });
      if (productType == "order") {
        productUnitPrice.text == ""
            ? productUnitPrice.text = "0"
            : productUnitPrice.text =
            productUnitPrice.text;

        productQuantity.text == ""
            ? productQuantity.text = "1"
            : productQuantity.text =
            productQuantity.text;


        leadtime.text == ""?
        leadtime.text = "0"
            :leadtime.text = leadtime.text;




        String productName =
        productDescription.text.toString();
        print(productName);
        print("productnamee");
        print(productTax.length);
        print(editProductTaxName);
        print(productTax);

        for (int i = 0; i <
            productTax.length; i++) {
          String dataoTaxes =
              '{"id":${editProductTaxName[i]
              .value},"name":"${editProductTaxName[i]
              .label}"}';

          Map<String, dynamic> jsondata =
          jsonDecode(dataoTaxes);

          selectedtaxesIdFinal.add(dataoTaxes);
          print(selectedtaxesIdFinal);
          print(editProductTaxName);
          print("taxesssssss");
        }

        double quantity, price;

        quantity =
            double.parse(productQuantity.text);
        price =
            double.parse(productUnitPrice.text);

        productSubTotal = price * quantity;

        String dataone =
            '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription
            .text}","product_uom_qty":${double
            .parse(productQuantity
            .text)},"customer_lead":${double
            .parse(
            leadtime
                .text)},"product_uom":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double
            .parse(productUnitPrice
            .text)},"tax_id":${selectedtaxesIdFinal}}';

        Map<String, dynamic> jsondata =
        jsonDecode(dataone);
        print(dataone);
        print("demo datatatata");

        type == -1 ?
        orderLineProducts.add(jsondata) :

        orderLineProducts[type] = jsondata;
        print(productUomName['name']);
        print("demo datatatata1");
        // for app side

        print(orderLineProducts);
        print("orderLineProducts");


        _isInitialized = false;
        await productSum(orderLineProducts);
      }


      if (productType == "optionjal") {
        productUnitPrice.text == ""
            ? productUnitPrice.text = "0"
            : productUnitPrice.text =
            productUnitPrice.text;

        productQuantity.text == ""
            ? productQuantity.text = "1"
            : productQuantity.text =
            productQuantity.text;


        leadtime.text == ""?
        leadtime.text = "0"
            :leadtime.text = leadtime.text;



        String productName =
        productDescription.text.toString();
        print(productName);
        print("productnamee");


        String datatwo =
            '{"id":${productId},"product_id":{"id":${productTiltleId},"display_name":"${productTiltleName['display_name']}"},"name":"${productDescription
            .text}","quantity":${double.parse(
            productQuantity
                .text)},"uom_id":{"id":${productUomId},"name":"${productUomName['name']}"},"price_unit":${double
            .parse(productUnitPrice.text)}}';


        Map<String, dynamic> jsondatatwo =
        jsonDecode(datatwo);
        print(datatwo);
        print("demo datatatatatwo");

        type == -1 ?
        optionalProducts.add(jsondatatwo) :

        optionalProducts[type] = jsondatatwo;
        print(productUomName['name']);
        print("demo datatatata1");
        // for app side

        print(optionalProducts);
        print("orderLineProducts");
      }


      setState(() {
        _isSavingData=false;
        productTiltleName = null;
        productTiltleId = null;
        productUomName = null;
        productUomId = null;

        productDescription.text = "";
        productUnitPrice.text = "";
        productQuantity.text = "";
        leadtime.text = "0";

        productTax.clear();
        selectedProductTax.clear();
        editProductTaxName.clear();
        selectedtaxesIdFinal.clear();
      });
      Future.delayed(Duration(seconds: 2), () {

        _formKeyalert.currentState?.reset();

      });


    }
    else{
      _formKeyalert.currentState!.reset();
    }



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
                  padding: const EdgeInsets.only(top: 40,bottom: 10),
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
                              selectedtaxesIdFinal.clear();
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

    _isInitialized = true;
  });

  //print(token);
}


productSum(List orderLineProductsData) async {
  productDatas.clear();
 // var data = await getProductSum(orderLineProductsData,pricelistId);
  var data = await getProductSum(orderLineProductsData,1);
 print(data);
 print("bug data");

  setState(() {
    // data['result']["data"].forEach((key, value) {
    //   print('Key: $key, Value: $value');
    //   productDatas.add("$key : $value");
    // });
    //
    // productData = (data['result']["data"]['data']??"").toString();
    // productTotal = (data['result']["data"]['total']??"").toString();


    data['result']["data"].forEach((key, value) {
      print('Key: $key, Value: $value');
      productDatas.add("$key : $value");
    });

    _isInitialized = true;
  });

  //print(token);
}
}
