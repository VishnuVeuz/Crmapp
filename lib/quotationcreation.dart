import 'dart:convert';

import 'package:crm_project/quotation_detail.dart';
import 'package:crm_project/scrolling/quotationscrolling.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'bottomnavigation.dart';
import 'drawer.dart';
import 'globals.dart';
import 'notification.dart';
import 'notificationactivity.dart';

const List<String> list = <String>[
  "As soon as possible",
  "when all products are ready"
];

class QuotationCreation extends StatefulWidget {
  var quotationId;
  QuotationCreation(this.quotationId);

  @override
  State<QuotationCreation> createState() => _QuotationCreationState();
}

class _QuotationCreationState extends State<QuotationCreation> {
  String? dropdownValue, dropdownValueId = "direct";
  String? dropdownCustomerData = "";

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
  final _formKeyalert = GlobalKey<FormState>();

  String notificationCount="0";
  String  messageCount="0";

  List orderLineProducts = [];
  List optionalProducts = [];

  Map<String, dynamic>? orderLineProductsData;
  Map<String, dynamic>? optionalProductsData;
  String? productData="",productTotal="";
  List productDatas = [];
  bool _isSavingData = false;

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
  String? token, baseUrl;
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
    productQuantity.text = "1";
    leadtime.text = "0";
    widget.quotationId == 0 ? defaultvalues() : getQuotationDetails();
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
                "Create Quotation",
                style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                    decoration: TextDecoration.none)
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            child: SearchChoices.single(
                              icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
                              //items: items,
                              validator: (value) {
                                if(value==null){
                                  return 'please select customer';
                                }
                                return null;
                              },

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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },


                              value: customerName,

                              searchHint: null,
                              autofocus: true,
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
                                        item["display_name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text("${item["display_name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                              child: Text(dropdownCustomerData!,style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),),
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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },

                              value: quotationtemplateName,

                              searchHint: null,
                              autofocus: true,
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
                                        item["name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                    style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Expiration Date",
                                        hintStyle: TextStyle(
                                          //fontFamily: "inter",
                                            color: Color(0xFF666666), fontSize: 12,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500))),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                            child: SearchChoices.single(
                              icon:Icon(Icons.arrow_drop_down,color: Colors.grey,size: 30,) ,
                              //items: items,
                              validator: (value) {
                                if(value==null){
                                  return 'please select pricelist';
                                }
                                return null;
                              },
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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },

                              value: pricelistName,

                              searchHint: null,
                              autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  pricelistName = value;
                                  pricelistId = value["id"];
                                });
                                print(pricelistName);
                                print(pricelistId);
                                print("fhjj");
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
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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

                                int nbResults = data["length"];

                                List<DropdownMenuItem> results =
                                (data["record"] as List<dynamic>)
                                    .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                  value: item,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },

                              value: paymenttermsName,

                              searchHint: null,
                              autofocus: true,
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
                                      //width: 320,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Text(
                                        item["name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text("${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                            const EdgeInsets.symmetric(horizontal: 25, vertical:10),
                            child: Text(
                              "Sales",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),fontFamily: 'Proxima Nova'),
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
                                        style: TextStyle(  fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                        style: TextStyle(  fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                              validator: (value) {
                                if(value==null){
                                  return 'please select company';
                                }
                                return null;
                              },
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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },

                              value: companyName,

                              searchHint: null,
                              autofocus: true,
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
                                     // width: 320,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Text(
                                        item["name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                      color: Color(0xFF666666), fontSize: 12,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 17),
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
                                      color: Color(0xFF666666), fontSize: 12,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right:17),
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
                              style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                              controller: customerreference,
                              decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFAFAFAF),width:0.5),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFAFAFAF),),
                                  ),

                                  // border: UnderlineInputBorder(),
                                  labelText: 'Customer Reference',
                                  labelStyle:
                                  TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal:17, vertical: 1),
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
                                    height:30,
                                    child: MultiSelectDropDown.network(
                                      hint: '',
                                      borderColor: Colors.transparent,
                                      backgroundColor: Colors.grey[50],
                                      borderWidth: 0,
                                      hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
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
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            child: Text(
                              "Delivery",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),fontFamily: 'Proxima Nova'),
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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },


                              items: list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(  fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                  ),
                                );
                              }).toList(),
                              autofocus: true,
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
                                    enabled: false,
                                    controller: deliveryDateTime,
                                    style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Delivery Date",
                                        hintStyle: TextStyle(
                                          //fontFamily: "inter",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Colors.black,fontFamily: 'Proxima Nova'))),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            child: Text(
                              "Invoicing",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),fontFamily: 'Proxima Nova'),
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
                                      labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },

                              value: fiscalpositionName,


                              searchHint: null,
                              autofocus: true,
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
                                     // width: 320,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Text(
                                        item["name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                            child: Text(
                              "Tracking",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),fontFamily: 'Proxima Nova'),
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
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                     // width: 320,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      child: Text(
                                        item["name"],
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                        style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                      child: Text(" ${item["name"]}",style: TextStyle(color: Colors.black, fontSize: 14,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                              style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                  TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                            ),
                          ),





                          Container(
                            color: Color(0xFFF6F6F6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0,left: 10,right: 5),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width/2.5,
                                    child: TextButton(
                                        child: Text(
                                          "Orderlines",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14.57,
                                              color: Colors.black,fontFamily: 'Proxima Nova'),
                                        ),
                                        onPressed: () {

                                          setState(() {

                                            optvisibility = false;
                                            ordervisibility = true;

                                          });


                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFF6F6F6),
                                        )),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 0, bottom: 0,left: 5,right: 30),
                                  child: Center(

                                    child: Container(
                                      width: MediaQuery.of(context).size.width/2.5,
                                      child: TextButton(
                                          child: Text(
                                            "Optional products",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.57,
                                                color: Colors.black,fontFamily: 'Proxima Nova'),
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
                              padding: const EdgeInsets.only(top: 1, bottom: 10,left: 25,right: 25),
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
                                        style:TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.57,
                                            color: Colors.white,fontFamily: 'Proxima Nova'),
                                      ),
                                      onPressed: () {

                                        setState(() {
                                          productId = null;
                                          leadtime.text = "0";
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

                                    print(orderLineProductsData);
                                    print("orderLineProductsData");

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
                                            leadtime.text = (orderLineProducts[index]['customer_lead']??"0").toString();
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
                                                                          Colors.black,fontFamily: 'Proxima Nova'),
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
                                                                  top: 2, left: 25),
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
                                                                            0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                            0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                            0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                                  0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                                  0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                        onPressed: ()async {
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
                              padding: const EdgeInsets.only(top: 1, bottom: 10,left: 25,right: 25),
                              child: Center(
                                child: SizedBox(
                                 // width: 360,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: 47,

                                  child: ElevatedButton(
                                      child: Text(
                                        "Add optional products",
                                        style:TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.57,
                                            color: Colors.white,fontFamily: 'Proxima Nova'),
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
                                    print(optionalProductsData);
                                    print("optionalProductsData");

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

                                            // for (int i = 0; i < optionalProducts[index]['tax_id'].length; i++) {
                                            //   selectedProductTax.add(optionalProducts[index]['tax_id'][i]);
                                            // }
                                            //
                                            // for (int i = 0; i < selectedProductTax.length; i++) {
                                            //   editProductTaxName.add(new ValueItem(
                                            //       label: selectedProductTax[i]['name'],
                                            //       value: selectedProductTax[i]['id'].toString()));
                                            // }
                                            //
                                            // productTax = editProductTaxName.map((item) => item.value).toList();
                                            //
                                            //





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
                                                                          Colors.black,fontFamily: 'Proxima Nova'),
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                  top: 2, left: 25),
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
                                                                            0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                            0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                            0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                                0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                                0xFF787878),fontFamily: 'Proxima Nova'),
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
                                                                      icon:  SvgPicture.asset("images/trash.svg"),
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
                                                  productDatas[index].toString(),
                                                style: TextStyle(fontFamily: 'Proxima Nova'),
                                              )),
                                        ),
                                      );
                                    }),
                              ),

                            ),
                          ),




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
                              fontSize: 15.57,
                              color: Colors.white,fontFamily: 'Proxima Nova'),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //       content: Text('Processing Data')),
                            // );


                            setState(() {
                              _isInitialized = false;
                            });

                            String resmessage;
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

                            //resmessage=await quotationCreate() ;

                            print("lakshmiiiiiii");

                            widget.quotationId == 0
                                ? resmessage = await quotationCreate()
                                : resmessage = await quotationEdit();

                            int resmessagevalue = int.parse(resmessage);
                            if (resmessagevalue != 0) {
                              setState(() {
                                _isInitialized = true;
                              });

                              print("gggggggg");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuotationDetail(resmessagevalue)),
                              );
                            }
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
        bottomNavigationBar:MyBottomNavigationBar(3),
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
    try{

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
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();


    print(token);
    print("final token ");

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
                          builder: (context) => QuotationScrolling("","")));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

  }

  quotationCreate() async {


    try{
    dropdownValue == "As soon as possible"
        ? dropdownValueId = "direct"
        : dropdownValueId = "one";

    print(dropdownValueId);
    print("dropdownValue");
    var value = await createQuotation(
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
                          builder: (context) =>    QuotationScrolling("","")));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }



  }

  quotationEdit() async {

    try{
    dropdownValue == "As soon as possible"
        ? dropdownValueId = "direct"
        : dropdownValueId = "one";

    String value = await editQuotation(
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
      expirationDateTime.text,
      deliveryDateTime.text,
      isCheckedSignature,
      isCheckedPayment,
      widget.quotationId,
      dropdownValueId!,
      orderLineProducts,
      optionalProducts,

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
                          builder: (context) =>    QuotationScrolling("","")));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

  }

  void getQuotationDetails() async {
    token = await getUserJwt();
     baseUrl= await getUrlString();
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    var data = await getQuotationData(widget.quotationId, "");

    print(data);
    print("default data");

    setState(() {
      customerName = data['partner_id'] ?? "";
      customerId = data['partner_id']['id'] ?? null;
      quotationtemplateName = data['sale_order_template_id'] ?? "";
      quotationtemplateId = data['sale_order_template_id']['id'] ?? null;
      expirationDateTime.text = data['validity_date'].toString();
      pricelistName = data['pricelist_id'] ?? "";
      pricelistId = data['pricelist_id']['id'] ?? null;
      paymenttermsName = data['payment_term_id'] ?? "";
      paymenttermsId = data['payment_term_id']['id'] ?? null;
      salespersonName = data['user_id'] ?? "";
      salespersonId = data['user_id']['id'] ?? null;
      salesteamName = data['team_id'] ?? "";
      salesteamId = data['team_id']['id'] ?? null;
      companyName = data['company_id'] ?? "";
      companyId = data['company_id']['id'] ?? null;
      isCheckedSignature = data['require_signature'] ?? false;
      isCheckedPayment = data['require_payment'] ?? false;
      customerreference.text = (data['client_order_ref'] ?? "").toString();

      for (int i = 0; i < data['tag_ids'].length; i++) {
        selctedTag.add(data['tag_ids'][i]);
      }

      for (int i = 0; i < selctedTag.length; i++) {
        editTagName.add(new ValueItem(
            label: selctedTag[i]['name'],
            value: selctedTag[i]['id'].toString()));
      }

      tags = editTagName.map((item) => item.value).toList();
      deliveryDateTime.text = data['commitment_date'].toString();
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


      for (int i = 0; i < data['sale_order_option_ids'].length; i++) {
        optionalProducts.add(data['sale_order_option_ids'][i]);
      }


      print(orderLineProducts);
      print(optionalProducts);
      print("initial data");

      data['tax_totals_json'].forEach((key, value) {
        print('Key: $key, Value: $value');
        productDatas.add("$key : $value");
      });

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


      return StatefulBuilder(builder: (context, setState) {

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            insetPadding: EdgeInsets.all(10),
            content: Form(
            key: _formKeyalert,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,

                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 290),
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
                                  labelStyle:  TextStyle(
                                      color: Color(0xFF868686),
                                      fontSize: 15,
                                      fontFamily: 'Proxima Nova',
                                      fontWeight: FontWeight.w500),
                                  fillColor: Colors.white,

                                ),
                                child: fieldWidget,
                              ),
                            );
                          },

                          value: productTiltleName,

                          searchHint: null,
                          autofocus: true,
                          onChanged: (value) async {
                            setState(() {

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
                                  //width: 300,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: Text(
                                    item["display_name"],
                                    style: TextStyle(
                                        color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
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
                                  "${baseUrl}api/products?page_no=${pageNb ??
                                      1}&count=10${keyword == null
                                      ? ""
                                      : "&filter=$keyword"}${companyId == null
                                      ? ""
                                      : "&company_id=$companyId"}"),
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
                          style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                  color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                  color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
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
                                  labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),
                                  fillColor: Colors.white,

                                ),
                                child: fieldWidget,
                              ),
                            );
                          },

                          value: productUomName,

                          searchHint: null,
                          autofocus: true,
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
                                 // width: 300,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: Text(
                                    item["name"],
                                    style:  TextStyle(
                                        fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
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
                                  "${baseUrl}api/uom?page_no=${pageNb ??
                                      1}&count=10${keyword == null
                                      ? ""
                                      : "&filter=$keyword"}${productTiltleId ==
                                      null
                                      ? ""
                                      : "&product_id=$productTiltleId"}"),
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

                      Visibility(
                        visible: tvisibility,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          child: TextFormField(
                            controller: leadtime,
                            style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova',color: Colors.black,fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Lead Time',
                                labelStyle: TextStyle(
                                    color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: tvisibility,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Taxes',
                                 style:     TextStyle(
                                          color: Color(0xFF666666), fontSize: 13,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500)

                                  ),
                                  Container(
                                    height:30,
                                    child: MultiSelectDropDown.network(

                                      hint: '',
                                      borderColor: Colors.transparent,
                                      borderWidth: 0,
                                      hintStyle: TextStyle(fontSize: 12,fontFamily: 'Proxima Nova'),
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
                                          //editProductTaxName.add(options.value);
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
                                        "${baseUrl}api/tax?${companyId == null
                                            ? ""
                                            : "&company_id=$companyId"}",
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

                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: TextFormField(
                          controller: productDescription,
                          style: TextStyle(fontSize: 14,fontFamily: 'Proxima Nova'),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Description',
                            labelStyle: TextStyle(color: Color(0xFF666666), fontSize: 15,fontFamily: 'Proxima Nova',fontWeight: FontWeight.w500),),
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
                                            color: Colors.white,fontFamily: 'Proxima Nova'),
                                      ),
                                    ),
                                    onPressed:_isSavingData
                                        ? null // Disable the button if saving is in progress
                                        :  () async {

                           if (_formKeyalert.currentState!.validate()) {
                                       setState(() {
                                        _isSavingData = true;
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
              _isSavingData = false;
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

          Navigator.pop(context);
        }

                                     else{

                                           }


                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Color(0xFF043565),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(width: 0,),
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
                                            color: Colors.white,fontFamily: 'close-icon'),
                                      ),
                                    ),
                                    onPressed:  _isSavingData
                                        ? null // Disable the button if saving is in progress
                                        :() async{

        if (_formKeyalert.currentState!
            .validate()) {
          setState(() {
            _isSavingData = true;
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

            _isSavingData = false;
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
                                      primary: Color(0xFF043565),
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
                                        color: Colors.black,
                                    fontFamily: 'Proxima Nova'),
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
                                    leadtime.text = "0";

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
    print("demooooossss");
    print(pricelistId);


   // var data = await getProductSum(orderLineProductsData,pricelistId);
    var data = await getProductSum(orderLineProductsData,1);

    setState(() {


      data['result']["data"].forEach((key, value) {
        print('Key: $key, Value: $value');
        productDatas.add("$key : $value");
      });
print(productDatas);
print("productData11");



      productData = (data['result']["data"]['data']??"").toString();
      productTotal = (data['result']["data"]['total']??"").toString();

      print(productData);
      print("productData");

      _isInitialized = true;
    });

    //print(token);
  }
}


