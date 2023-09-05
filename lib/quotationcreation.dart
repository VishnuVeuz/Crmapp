import 'dart:convert';

import 'package:crm_project/quotation_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';
import 'package:intl/intl.dart';
import 'api.dart';
import 'drawer.dart';

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
  String? token;
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
                "New",
                style: TextStyle(
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
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: Colors.cyan,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
                    child: SizedBox(
                      width: 93,
                      height: 33,
                      child: ElevatedButton(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.57,
                                color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );


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
                            primary: Color(0xFFF04254),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,
                      validator: (value) {
                        if(value==null){
                          return 'please select customer';
                        }
                        return null;
                      },
                      value: customerName,
                      hint: Text(
                        "Customer",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["display_name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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

                        // print(data);
                        // print("customer data");
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Container(
                      child: Text(dropdownCustomerData!),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,

                      value: quotationtemplateName,
                      hint: Text(
                        "Quotation Template",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                    child: SizedBox(
                      child: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: TextField(
                            enabled: false,
                            controller: expirationDateTime,
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Expiration Date",
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
                      validator: (value) {
                        if(value==null){
                          return 'please select pricelist';
                        }
                        return null;
                      },

                      value: pricelistName,
                      hint: Text(
                        "Pricelist",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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

                        List<DropdownMenuItem> results =
                        (data["record"] as List<dynamic>)
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
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,

                      value: paymenttermsName,
                      hint: Text(
                        "Payment Terms",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: Text(
                      "Sales",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000)),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,
                      value: salespersonName,
                      hint: Text(
                        "Salesperson",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),

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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      value: salesteamName,
                      hint: Text(
                        "Sales Team",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      validator: (value) {
                        if(value==null){
                          return 'please select company';
                        }
                        return null;
                      },
                      value: companyName,
                      hint: Text(
                        "Company",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Checkbox(
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
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF000000)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: Checkbox(
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
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: TextFormField(
                      style: TextStyle(fontSize: 12),
                      controller: customerreference,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),

                          // border: UnderlineInputBorder(),
                          labelText: 'Customer Reference',
                          labelStyle:
                          TextStyle(color: Colors.black, fontSize: 10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: MultiSelectDropDown.network(
                      hint: 'Tags',
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
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      "Delivery",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000)),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      hint: Text(
                        "Shipping policy",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 10, color: Colors.black),
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
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: SizedBox(
                      child: InkWell(
                        onTap: () {
                          selectDateTime(context);
                        },
                        child: TextField(
                            enabled: false,
                            controller: deliveryDateTime,
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Delivery Date",
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
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: Text(
                      "Invoicing",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000)),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,
                      value: fiscalpositionName,
                      hint: Text(
                        "Fiscal Position",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),

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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000000)),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,
                      value: campaignName,
                      hint: Text(
                        "Campaign",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),

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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      value: mediumName,
                      hint: Text(
                        "Medium",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      value: sourceName,
                      hint: Text(
                        "Source",
                        style: TextStyle(fontSize: 10, color: Colors.black),
                      ),
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
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(fontSize: 10, color: Colors.black),
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
                              child: Text(" ${item["name"]}"),
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
                      style: TextStyle(fontSize: 12),
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
                          TextStyle(color: Colors.black, fontSize: 10)),
                    ),
                  ),





                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 30,left: 10,right: 5),
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
                        padding: const EdgeInsets.only(top: 20, bottom: 30,left: 5,right: 10),
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
                                    productId = null;
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 30),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/2,

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
                                primary: Color(0xFFF04254),
                              )),
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
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                          top: 5, left: 25),
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


                                                          Padding(
                                                            padding: const EdgeInsets.only(left:170,right: 25),
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              //color: Colors.green,
                                                              child: IconButton(
                                                                icon: Icon(
                                                                    Icons.delete),
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
                      padding: const EdgeInsets.only(top: 1, bottom: 30),
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width/2,

                          child: ElevatedButton(
                              child: Text(
                                "Add optional products",
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
                                          context,-1,"optionjal"
                                      ),
                                ).then((value) => setState(() {}));
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF04254),
                              )),
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
                                    // width: 490,
                                    // height:
                                    // MediaQuery.of(context).size.height / 7,
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
    dropdownValue == "As soon as possible"
        ? dropdownValueId = "direct"
        : dropdownValueId = "one";

    print(dropdownValueId);
    print("dropdownValue");
    String value = await createQuotation(
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
  }

  quotationEdit() async {
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
  }

  void getQuotationDetails() async {
    token = await getUserJwt();
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
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: SearchChoices.single(
                        //items: items,

                        value: productTiltleName,
                        hint: Text(
                          "Product",
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
                        searchHint: null,
                        autofocus: false,
                        onChanged: (value) async {
                          setState(() {
                            print(value['capital']);

                            print("xfgchvjbknm");
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
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
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
                                color: Colors.black, fontSize: 10)),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
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
                                color: Colors.black, fontSize: 10)),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: SearchChoices.single(
                        //items: items,

                        value: productUomName,
                        hint: Text(
                          "Uom",
                          style: TextStyle(fontSize: 10, color: Colors.black),
                        ),
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
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        child: TextFormField(
                          controller: leadtime,
                          style: TextStyle(fontSize: 12),
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
                                  color: Colors.black, fontSize: 10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: tvisibility,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: MultiSelectDropDown.network(
                          hint: 'Taxes',
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
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: TextFormField(
                        controller: productDescription,
                        style: TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            labelText: 'Description',
                            labelStyle: TextStyle(
                                color: Colors.black, fontSize: 10)),
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
                                      "Save & Close",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.57,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (productType == "order") {
                                      productUnitPrice.text == ""
                                          ? productUnitPrice.text = "0"
                                          : productUnitPrice.text =
                                          productUnitPrice.text;

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
                                      "Save & New",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13.57,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async{
                                    if (productType == "order") {
                                      productUnitPrice.text == ""
                                          ? productUnitPrice.text = "0"
                                          : productUnitPrice.text =
                                          productUnitPrice.text;

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

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFF04254),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 10),
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


    var data = await getProductSum(orderLineProductsData,pricelistId);
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

