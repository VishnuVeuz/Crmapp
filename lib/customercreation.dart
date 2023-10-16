import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'customerdetail.dart';
import 'drawer.dart';
import 'notification.dart';
import 'notificationactivity.dart';

class CustomerCreation extends StatefulWidget {
  var customnerId;
  CustomerCreation(this.customnerId);

  @override
  State<CustomerCreation> createState() => _CustomerCreationState();
}

class _CustomerCreationState extends State<CustomerCreation> {
  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  String notificationCount="0";
  String messageCount = "0";

  dynamic companyName,
      companyId,
      titleName,
      titleId,
      countryName,
      countryId,
      stateName,
      stateId,
      salespersonName,
      salespersonId,
      paymenttermsName,
      paymenttermsId,
      pricelistName,
      pricelistId,
      fiscalpositionName,
      fiscalpositionId,
      customerCampanyName,
      customerCampanyId,
      languageName,
      languageId;

  dynamic alertCountryName,
      alertCountryId,
      alertStateName,
      alertStateId,
      alerTitleName,
      alertTitleId;

  int? addCustomerId = null;
  List addNewCustomer = [];
  Map<String, dynamic>? addNewCustomerData;

  TextEditingController alertCompanyNameController = TextEditingController();
  TextEditingController alertStreetController = TextEditingController();
  TextEditingController alertStreetTwoController = TextEditingController();
  TextEditingController alertCityController = TextEditingController();
  TextEditingController alertZipController = TextEditingController();
  TextEditingController alertEmailController = TextEditingController();
  TextEditingController alertPhoneController = TextEditingController();
  TextEditingController alertMobileController = TextEditingController();
  TextEditingController alertNotesController = TextEditingController();
  TextEditingController alertJobController = TextEditingController();

  TextEditingController customerController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController streettwoController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController taxidController = TextEditingController();
  TextEditingController jobpositionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController customerrankController = TextEditingController();
  TextEditingController supplierrankController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController referenceController = TextEditingController();
  TextEditingController internalnotesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? token;
  List tags = [];
  List selctedTag = [];
  List<ValueItem> editTagName = [];

  String alertradioSelect = "other";
  String radioInput = "person";
  bool cmpVisibility = true;
  bool cmpbasedVisible = true;
  bool alertRadioAddressVisibile = true;
  bool alertRadiotitleVisibile = false;
  bool _isInitialized = false;

  final ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];
  String imagepath = "";
  String personImg="";
  String base64string = "";
  List base64string1 = [];
  bool isLoading = true;

  bool _isSavingData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    tokendata();

    widget.customnerId != 0 ? getCustomerDetails() : null;


  }

  @override
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
                            color: Colors.white,fontFamily: 'Mulish'),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && customerController.text.trim().isNotEmpty) {




                          setState(() {
                            _isInitialized = false;
                          });
                          String resmessage;

                          print("tagsss");

                          widget.customnerId == 0
                              ? resmessage = await customerCreate()
                              : resmessage = await customerEdit();

                          print(resmessage);

                          print("titleId");

                          int resmessagevalue = int.parse(resmessage);
                          if (resmessagevalue != 0) {
                            setState(() {
                              _isInitialized = true;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerDetail(resmessagevalue)),
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

                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    title: Text(
                                      "Individual",
                                      style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                                    ),
                                    value: "person",
                                    groupValue: radioInput,
                                    onChanged: (value) {
                                      setState(() {
                                        radioInput = value.toString();
                                        cmpVisibility = true;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: Text(
                                      "Company",
                                      style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                                    ),
                                    value: "company",
                                    groupValue: radioInput,
                                    onChanged: (value) {
                                      setState(() {
                                        radioInput = value.toString();
                                        cmpVisibility = false;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Container(
                                width: 80,
                                height: 87,
                                // color: Colors.black,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                    Border.all(color: Color(0xFFF5F5F5), width: 1)),
                                child: Column(
                                  children: [

                                    personImg !=""
                                        ?
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1),
                                      child: Container(
                                        width: 70,
                                        height: 55,

                                        child: ClipRRect(
                                          // borderRadius: BorderRadius
                                          //     .circular(0),
                                          child: Image.memory(
                                            base64Decode(personImg!),
                                            fit: BoxFit.cover,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            height: 300,
                                          ),
                                        ),
                                      ),
                                    ):Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Image.asset("images/cam.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              width: 37,
                                              height: 18,
                                              child: ElevatedButton(
                                                child: Image.asset("images/pencil.png"),
                                                onPressed: () {
                                                  myAlert();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF3D418E),
                                                ),
                                              )),
                                          SizedBox(
                                              width: 41,
                                              height: 18,
                                              child: ElevatedButton(
                                                  child: Image.asset("images/del.png"),
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedImages.clear();
                                                      personImg="";
                                                    });
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: Color(0xFFB8000B),
                                                  )))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the name';
                              }
                              return null;
                            },
                            controller: customerController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Customer Name',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Visibility(
                          visible: cmpVisibility,
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                            child: SearchChoices.single(
                              //items: items,
                              fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                                return Container(
                                  padding: const EdgeInsets.all(0),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      labelText:'Company Name',
                                      isDense: true,
                                      labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                      fillColor: Colors.white,

                                    ),
                                    child: fieldWidget,
                                  ),
                                );
                              },

                              value: companyName,
                              // hint: Text(
                              //   "Company Name",
                              //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                              // ),
                              searchHint: null,
                              autofocus: false,
                              onClear: () {
                                setState(() {
                                  cmpbasedVisible = true;
                                });
                              },
                              onChanged: (value) async {
                                setState(() {
                                  cmpbasedVisible = false;
                                  companyName = value;
                                  companyId = value["id"];
                                });

                                await getCustomerCompanyDetail(companyId);
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
                                        style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                                      ),
                                    )));
                              },
                              futureSearchFn: (String? keyword,
                                  String? orderBy,
                                  bool? orderAsc,
                                  List<Tuple2<String, String>>? filters,
                                  int? pageNb) async {
                                token = await getUserJwt();
                                Response response = await get(
                                  Uri.parse(
                                      "${baseUrl}api/customers?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=partner"),
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
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            enabled: cmpbasedVisible,
                            controller: streetController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Street',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            enabled: cmpbasedVisible,
                            controller: streettwoController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Street2',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            enabled: cmpbasedVisible,
                            controller: cityController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'City',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
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
                                    labelText:'Country',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: countryName,
                            // hint: Text(
                            //   "Country",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
                            onChanged: cmpbasedVisible
                                ? (value) {
                              setState(() {
                                print(value['capital']);
                                print("value");
                                countryName = value;
                                countryId = value['id'];
                              });
                            }
                                : null,

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
                                      style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText:'State',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: stateName,
                            // hint: Text(
                            //   "State",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: cmpbasedVisible
                                ? (value) {
                              setState(() {
                                print(value['capital']);
                                print("value");
                                stateName = value;
                                stateId = value["id"];
                              });
                            }
                                : null,
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
                                      style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            enabled: cmpbasedVisible,
                            controller: zipController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            maxLength: 6,
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Zip',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            enabled: cmpbasedVisible,
                            controller: taxidController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Tax ID',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
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
                                    labelText:'Company',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },


                            value: customerCampanyName,
                            // hint: Text(
                            //   "Company",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),

                            searchHint: null,
                            autofocus: false,
                            onChanged: cmpbasedVisible
                                ? (value) {
                              setState(() {
                                print(value['capital']);
                                print("value");
                                customerCampanyName = value;
                                customerCampanyId = value["id"];
                              });
                            }
                                : null,

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
                                      style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            controller: jobpositionController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Job Position',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            controller: phoneController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Phone',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
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
                            keyboardType: TextInputType.phone,
                            //maxLength: 10,
                            controller: mobileController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                counterText: "",
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Mobile',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            controller: customerrankController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Customer Rank',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            controller: supplierrankController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Supplier Rank',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Email',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            controller: websiteController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Website',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
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
                                    labelText:'Language',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },


                            value: languageName,
                            // hint: Text(
                            //   "Language",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
                            onChanged: cmpbasedVisible
                                ? (value) {
                              setState(() {
                                print(value['capital']);
                                print("value");
                                languageName = value;
                                languageId = value["id"];
                              });
                            }
                                : null,

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
                                      style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                                    ),
                                  )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              token = await getUserJwt();
                              Response response = await get(
                                Uri.parse(
                                    "${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=res.lang"),
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
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText:'Title',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

                            value: titleName,
                            // hint: Text(
                            //   "Title",
                            //   style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                            // ),
                            searchHint: null,
                            autofocus: false,
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
                                      style: TextStyle(fontSize: 12, color: Colors.black,fontFamily: 'Mulish'),
                                    ),
                                  )));
                            },
                            futureSearchFn: (String? keyword,
                                String? orderBy,
                                bool? orderAsc,
                                List<Tuple2<String, String>>? filters,
                                int? pageNb) async {
                              token = await getUserJwt();
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
                        SizedBox(
                          height: 0,
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tags',
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

                                  hintStyle: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
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
                                    url:
                                    "${baseUrl}api/common_dropdowns?model=res.partner.category",
                                    method: RequestMethod.get,
                                    headers: {
                                      'Authorization': 'Bearer $token',
                                    },
                                  ),
                                  chipConfig: const ChipConfig(wrapType: WrapType.scroll),
                                  responseParser: (response) {
                                    debugPrint('Response: $response');

                                    final list =
                                    (response['record'] as List<dynamic>).map((e) {
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
                          padding: const EdgeInsets.only(left: 25,right: 25,bottom: 0),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: Text(
                            "Sales",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
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
                                    labelText:'Salesperson',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

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
                                    width: 320,
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

                              if (response.statusCode != 200) {
                                throw Exception("failed to get data from internet");
                              }

                              dynamic data = jsonDecode(response.body);
                              print(data);

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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText:'Payment Terms',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

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
                                    width: 320,
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
                          child: SearchChoices.single(
                            //items: items,
                            fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                              return Container(
                                padding: const EdgeInsets.all(0),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText:'Pricelist',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

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
                                    width: 320,
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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: Text(
                            "Fiscal Information",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
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
                                    labelText:'Fiscal Position',
                                    isDense: true,
                                    labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                    fillColor: Colors.white,

                                  ),
                                  child: fieldWidget,
                                ),
                              );
                            },

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
                                    width: 320,
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
                              Response response = await get(Uri.parse(
                                  "${baseUrl}api/common_dropdowns?page_no=${pageNb ??
                                      1}&count=10${keyword == null
                                      ? ""
                                      : "&filter=$keyword"}&model=account.fiscal.position&company_id=${companyId == null ? "" : "&company_id=$companyId"}"),
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
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          child: Text(
                            "Misc",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),fontFamily: 'Mulish'),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                          child: TextFormField(
                            controller: referenceController,
                            style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                                ),
                                labelText: 'Reference',
                                labelStyle:
                                TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, top: 10),
                          child: Text(

                            "Internal Notes", style: TextStyle(fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,fontFamily: 'Mulish'),),
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
                                  decoration:
                                  const InputDecoration(
                                      border:
                                      InputBorder.none,
                                      hintText:
                                      "Internal Notes",
                                      hintStyle: TextStyle(
                                        //fontFamily: "inter",
                                          fontWeight:
                                          FontWeight
                                              .w400,
                                          fontFamily:
                                          'Mulish',
                                          fontSize: 11,
                                          color: Color(
                                              0xFFAFAFAF)))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25,right: 25,bottom: 20),
                          child: Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 30),
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
                                        color: Colors.white,fontFamily: 'Mulish'),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _buildSchedulePopupDialog(context, -1),
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
                              itemCount: addNewCustomer.length,
                              itemBuilder: (BuildContext context, int index) {
                                addNewCustomerData = addNewCustomer[index];
                                return InkWell(
                                    onTap: () {
                                      print(index);
                                      print("listindex");

                                      setState(() {
                                        addCustomerId = addNewCustomer[index]['id']??null;
                                        alertradioSelect = addNewCustomer[index]['type']??"";
                                        alertCompanyNameController.text = addNewCustomer[index]['name']??"";
                                        alertStreetController.text = addNewCustomer[index]['street']??"";
                                        alertStreetTwoController.text = addNewCustomer[index]['street2']??"".toString();
                                        alertCityController.text = addNewCustomer[index]['city']??"".toString();
                                        alertCountryName=addNewCustomer[index]['country_id']??"";
                                        alertCountryId = addNewCustomer[index]['country_id']['id']??null;
                                        alertStateName = addNewCustomer[index]['state_id']??"";
                                        alertStateId = addNewCustomer[index]['state_id']['id']??null;
                                        alertZipController.text = addNewCustomer[index]['zip']??"";
                                        alerTitleName = addNewCustomer[index]['title']??"";
                                        alertTitleId = addNewCustomer[index]['title']['id']??null;
                                        alertJobController.text = addNewCustomer[index]['function']??"";
                                        alertEmailController.text  = addNewCustomer[index]['email']??"";
                                        alertMobileController.text =  addNewCustomer[index]['mobile']??"";
                                        alertPhoneController.text = addNewCustomer[index]['phone']??"";
                                        alertNotesController.text =  addNewCustomer[index]['comment']??"";







                                      });
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildSchedulePopupDialog(context, index),
                                      ).then((value) => setState(() {}));

                                      print("orderLineProducts[index];");
                                    },
                                    child: Card(
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        //height: MediaQuery.of(context).size.height/8.5,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10),
                                              child: Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  addNewCustomerData!['image_1920']!=""?

                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(left: 10),
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
                                                        child:Image.network("${addNewCustomerData!['image_1920']}?token=${token}"),


                                                      ),
                                                    ),
                                                  )
                                                      :

                                                  Container(
                                                    height: 100,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        4,
                                                    // color: Colors.red,
                                                    child: Icon(
                                                      Icons.person,
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
                                                                    fontSize: 14,
                                                                    color: Colors.black,  fontFamily: 'Mulish'),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 0, right: 20),
                                                            child: InkWell(
                                                              onTap: (){
                                                                addNewCustomer
                                                                    .removeAt(
                                                                    index);
                                                                setState(() {});
                                                              },
                                                              child: Container(
                                                                width: 30,
                                                                height: 30,

                                                                child: Icon(
                                                                  Icons.delete,
                                                                  size: 20,
                                                                  color: Colors.black,
                                                                ),
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
                                                              fontSize: 12,
                                                              color: Colors.black,  fontFamily: 'Mulish'),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 15, top: 4),
                                                            child: Text(
                                                              addNewCustomerData!['state_id'][1]??"",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  fontSize: 12,
                                                                  color: Colors.black,  fontFamily: 'Mulish'),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 5, top: 4),
                                                            child: Text(
                                                              addNewCustomerData!['country_id'][1]??"",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w400,
                                                                  fontSize: 12,
                                                                  color: Colors.black,  fontFamily: 'Mulish'),
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
                                                              fontSize: 12,
                                                              color: Colors.black,  fontFamily: 'Mulish'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 15, top: 4),
                                                        child: Text(
                                                          addNewCustomerData!['mobile']??"",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 12,
                                                              color: Colors.black,  fontFamily: 'Mulish'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        ),
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

  _buildSchedulePopupDialog(BuildContext context, int type) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          RadioListTile(
                            title: Text(
                              "Contact",
                              style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                            ),
                            value: "contact",
                            groupValue: alertradioSelect,
                            onChanged: (value) {
                              setState(() {
                                alertradioSelect = value.toString();
                                alertRadioAddressVisibile = false;
                                alertRadiotitleVisibile = true;

                                alertStreetController.text = "";
                                alertStreetTwoController.text = "";
                                alertCityController.text = "";
                                alertZipController.text = "";
                                alertJobController.text = "";
                                alertCountryName = null;
                                alertCountryId = null;
                                alertStateName = null;
                                alertStateId = null;
                                alerTitleName = null;
                                alertTitleId = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: IconButton(
                        icon: SvgPicture.asset("images/cr.svg"),
                        onPressed: () {

                          setState((){
                            alertCompanyNameController.text = "";
                            alertStreetController.text = "";
                            alertStreetTwoController.text = "";
                            alertCityController.text = "";
                            alertCountryName = null;
                            alertCountryId = null;
                            alertStateName = null;
                            alertStateId = null;
                            alertZipController.text ="";
                            alertEmailController.text = "";
                            alertPhoneController.text = "";
                            alertMobileController.text= "";
                            alertNotesController.text="";
                            alertJobController.text = "";

                          });

                          Navigator.pop(context);

                        },
                      ),
                    ),
                  ],
                ),
                RadioListTile(
                  title: Text(
                    "Other Address",
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                  ),
                  value: "other",
                  groupValue: alertradioSelect,
                  onChanged: (value) {
                    setState(() {
                      alertradioSelect = value.toString();
                      alertRadioAddressVisibile = true;
                      alertRadiotitleVisibile = false;

                      alertStreetController.text = "";
                      alertStreetTwoController.text = "";
                      alertCityController.text = "";
                      alertZipController.text = "";
                      alertJobController.text = "";
                      alertCountryName = null;
                      alertCountryId = null;
                      alertStateName = null;
                      alertStateId = null;
                      alerTitleName = null;
                      alertTitleId = null;
                    });
                  },
                ),
                RadioListTile(
                  title: Text(
                    "Private Address",
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                  ),
                  value: "private",
                  groupValue: alertradioSelect,
                  onChanged: (value) {
                    setState(() {
                      alertradioSelect = value.toString();
                      alertRadioAddressVisibile = true;
                      alertRadiotitleVisibile = false;

                      alertStreetController.text = "";
                      alertStreetTwoController.text = "";
                      alertCityController.text = "";
                      alertZipController.text = "";
                      alertJobController.text = "";
                      alertCountryName = null;
                      alertCountryId = null;
                      alertStateName = null;
                      alertStateId = null;
                      alerTitleName = null;
                      alertTitleId = null;
                    });
                  },
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextFormField(
                    controller: alertCompanyNameController,
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Contact Name',
                        labelStyle:
                        TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                  ),
                ),
                Visibility(
                  visible: alertRadioAddressVisibile,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),fontFamily: 'Mulish'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: TextFormField(
                          controller: alertStreetController,
                          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Street',
                              labelStyle:
                              TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: TextFormField(
                          controller: alertStreetTwoController,
                          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Street2',
                              labelStyle:
                              TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: TextFormField(
                          controller: alertCityController,
                          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'City',
                              labelStyle:
                              TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                        ),
                      ),
                      //country

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: SearchChoices.single(
                          //items: items,
                          fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                            return Container(
                              padding: const EdgeInsets.all(0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText:'Country',
                                  isDense: true,
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                  fillColor: Colors.white,

                                ),
                                child: fieldWidget,
                              ),
                            );
                          },


                          value: alertCountryName,
                          // hint: Text(
                          //   "Country",
                          //   style: TextStyle(fontSize: 10, color: Colors.black,fontFamily: 'Mulish'),
                          // ),

                          searchHint: null,
                          autofocus: false,
                          onTap: cmpbasedVisible ? () {} : null,
                          onChanged: (value) {
                            setState(() {
                              print(value['capital']);
                              print("value");
                              alertCountryName = value;
                              alertCountryId = value['id'];
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
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black,fontFamily: 'Mulish'),
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
                              throw Exception(
                                  "failed to get data from internet");
                            }
                            print("fjbnkdttthgfgyv");
                            dynamic data = jsonDecode(response.body);
                            print(data);
                            print("fjbnkdttt");
                            int nbResults = data["length"];
                            print("fjbnkd");
                            List<DropdownMenuItem> results = (data["record"]
                            as List<dynamic>)
                                .map<DropdownMenuItem>(
                                    (item) => DropdownMenuItem(
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

                      //state

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: SearchChoices.single(
                          fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                            return Container(
                              padding: const EdgeInsets.all(0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText:'State',
                                  isDense: true,
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                  fillColor: Colors.white,

                                ),
                                child: fieldWidget,
                              ),
                            );
                          },

                          value: alertStateName,
                          // hint: Text(
                          //   "State",
                          //   style: TextStyle(fontSize: 10, color: Colors.black,fontFamily: 'Mulish'),
                          // ),
                          searchHint: null,
                          autofocus: false,
                          onChanged: (value) {
                            setState(() {
                              print(value['capital']);
                              print("value");
                              alertStateName = value;
                              alertStateId = value["id"];
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
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black,fontFamily: 'Mulish'),
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
                              throw Exception(
                                  "failed to get data from internet");
                            }
                            print("fjbnkdttthgfgyv");
                            dynamic data = jsonDecode(response.body);
                            print(data);
                            print("fjbnkdttt");
                            int nbResults = data["length"];
                            print("fjbnkd");
                            List<DropdownMenuItem> results = (data["records"]
                            as List<dynamic>)
                                .map<DropdownMenuItem>(
                                    (item) => DropdownMenuItem(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: alertZipController,
                          maxLength: 6,
                          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                          decoration: const InputDecoration(
                              counterText: "",
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Zip',
                              labelStyle:
                              TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: alertRadiotitleVisibile,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: SearchChoices.single(
                          //items: items,
                          fieldPresentationFn: (Widget fieldWidget, {bool? selectionIsValid}) {
                            return Container(
                              padding: const EdgeInsets.all(0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText:'Title',
                                  isDense: true,
                                  labelStyle: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                                  fillColor: Colors.white,

                                ),
                                child: fieldWidget,
                              ),
                            );
                          },

                          value: alerTitleName,
                          // hint: Text(
                          //   "Title",
                          //   style: TextStyle(fontSize: 10, color: Colors.black,fontFamily: 'Mulish'),
                          // ),
                          searchHint: null,
                          autofocus: false,
                          onChanged: (value) {
                            setState(() {
                              print(value['capital']);
                              print("value");
                              alerTitleName = value;
                              alertTitleId = value["id"];
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
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black,fontFamily: 'Mulish'),
                                  ),
                                )));
                          },
                          futureSearchFn: (String? keyword,
                              String? orderBy,
                              bool? orderAsc,
                              List<Tuple2<String, String>>? filters,
                              int? pageNb) async {
                            token = await getUserJwt();
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
                              throw Exception(
                                  "failed to get data from internet");
                            }

                            dynamic data = jsonDecode(response.body);

                            int nbResults = data["length"];

                            List<DropdownMenuItem> results = (data["record"]
                            as List<dynamic>)
                                .map<DropdownMenuItem>(
                                    (item) => DropdownMenuItem(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: TextFormField(
                          controller: alertJobController,
                          style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Job Position',
                              labelStyle:
                              TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextFormField(
                    controller: alertEmailController,
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Email',
                        labelStyle:
                        TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextFormField(
                    controller: alertPhoneController,
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                    keyboardType: TextInputType.phone,
                   // maxLength: 10,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Phone',
                        labelStyle:
                        TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
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
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                   // maxLength: 10,
                    controller: alertMobileController,
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Mobile',
                        labelStyle:
                        TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),

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
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextFormField(
                    controller: alertNotesController,
                    style: TextStyle(fontSize: 12,fontFamily: 'Mulish'),
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Internal Notes',
                        labelStyle:
                        TextStyle(color: Colors.black, fontSize: 10,fontFamily: 'Mulish')),
                  ),
                ),
                // TextButton(
                //     onPressed: () {
                //       print(alertCountryName);
                //       print(alertCountryId);
                //       print(alertStateName);
                //       print(alertStateId);
                //       print(alerTitleName);
                //       print(alertTitleId);
                //
                //       print(alertCompanyNameController.text);
                //       print(alertStreetController.text);
                //       print(alertStreetTwoController.text);
                //       print(alertCityController.text);
                //       print(alertZipController.text);
                //       print(alertEmailController.text);
                //
                //       print(alertPhoneController.text);
                //       print(alertMobileController.text);
                //       print(alertNotesController.text);
                //       print(alertJobController.text);
                //
                //       print("alertdataaaa");
                //
                //       String dataone =
                //           '{"id":${addCustomerId},"type":"${alertradioSelect}","name":"${alertCompanyNameController.text}","street":"${alertStreetController.text}","street2":"${alertStreetTwoController.text}","city":"${alertCityController.text}","function":"${alertJobController.text}","email":"${alertEmailController.text}","mobile":"${alertMobileController.text}","phone":"${alertPhoneController.text}","title":{"id":${alertTitleId},"name":"${alerTitleName != null ? alerTitleName['name'] : ""}"},"state_id":{"id":${alertStateId},"name":"${alertStateName != null ? alertStateName['name'] : ""}"},"zip":"${alertZipController.text}","country_id":{"id":${alertCountryId},"name":"${alertCountryName != null ? alertCountryName['name'] : ""}"},"comment":"${alertNotesController.text}"}';
                //
                //       Map<String, dynamic> jsondata = jsonDecode(dataone);
                //       print(dataone);
                //       print("demodatatatata");
                //
                //       type == -1
                //           ? addNewCustomer.add(jsondata)
                //           : addNewCustomer[type] = jsondata;
                //
                //       print(addNewCustomer);
                //       print("orderLineProducts");
                //
                //       setState((){
                //         alertCompanyNameController.text = "";
                //         alertStreetController.text = "";
                //         alertStreetTwoController.text = "";
                //         alertCityController.text = "";
                //         alertCountryName = null;
                //         alertCountryId = null;
                //         alertStateName = null;
                //         alertStateId = null;
                //         alertZipController.text ="";
                //         alertEmailController.text = "";
                //         alertPhoneController.text = "";
                //         alertMobileController.text= "";
                //         alertNotesController.text="";
                //         alertJobController.text = "";
                //
                //       });
                //
                //         Navigator.pop(context);
                //
                //     },
                //     child: Text("Save")),

                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 146,
                        height: 33,
                        child: ElevatedButton(
                            child: Text(
                              "Save & Close",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white,fontFamily: 'Mulish'),
                            ),
                            onPressed:_isSavingData
                                ? null // Disable the button if saving is in progress
                                :  () {

                              setState(() {
                                _isSavingData = true;
                              });

                              String dataone =
                                  '{"id":${addCustomerId},"type":"${alertradioSelect}","name":"${alertCompanyNameController.text}","street":"${alertStreetController.text}","street2":"${alertStreetTwoController.text}","city":"${alertCityController.text}","function":"${alertJobController.text}","email":"${alertEmailController.text}","mobile":"${alertMobileController.text}","phone":"${alertPhoneController.text}","title":{"id":${alertTitleId},"name":"${alerTitleName != null ? alerTitleName['name'] : ""}"},"state_id":{"id":${alertStateId},"name":"${alertStateName != null ? alertStateName['name'] : ""}"},"zip":"${alertZipController.text}","country_id":{"id":${alertCountryId},"name":"${alertCountryName != null ? alertCountryName['name'] : ""}"},"comment":"${alertNotesController.text}"}';

                              Map<String, dynamic> jsondata = jsonDecode(dataone);
                              print(dataone);
                              print("demodatatatata");

                              type == -1
                                  ? addNewCustomer.add(jsondata)
                                  : addNewCustomer[type] = jsondata;

                              print(addNewCustomer);
                              print("orderLineProducts");

                              setState((){
                                _isSavingData = false;
                                alertCompanyNameController.text = "";
                                alertStreetController.text = "";
                                alertStreetTwoController.text = "";
                                alertCityController.text = "";
                                alertCountryName = null;
                                alertCountryId = null;
                                alertStateName = null;
                                alertStateId = null;
                                alertZipController.text ="";
                                alertEmailController.text = "";
                                alertPhoneController.text = "";
                                alertMobileController.text= "";
                                alertNotesController.text="";
                                alertJobController.text = "";

                              });

                              Navigator.pop(context);

                            },

                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF9246A),
                            )),
                      ),
                      SizedBox(
                        width: 146,
                        height: 33,
                        child: ElevatedButton(
                            child: Text(
                              "Save & New",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white,fontFamily: 'Mulish'),
                            ),
                            onPressed: _isSavingData
                                ? null // Disable the button if saving is in progress
                                : () {

                              setState(() {
                                _isSavingData = true;
                              });


                              String dataone =
                                  '{"id":${addCustomerId},"type":"${alertradioSelect}","name":"${alertCompanyNameController.text}","street":"${alertStreetController.text}","street2":"${alertStreetTwoController.text}","city":"${alertCityController.text}","function":"${alertJobController.text}","email":"${alertEmailController.text}","mobile":"${alertMobileController.text}","phone":"${alertPhoneController.text}","title":{"id":${alertTitleId},"name":"${alerTitleName != null ? alerTitleName['name'] : ""}"},"state_id":{"id":${alertStateId},"name":"${alertStateName != null ? alertStateName['name'] : ""}"},"zip":"${alertZipController.text}","country_id":{"id":${alertCountryId},"name":"${alertCountryName != null ? alertCountryName['name'] : ""}"},"comment":"${alertNotesController.text}"}';

                              Map<String, dynamic> jsondata = jsonDecode(dataone);
                              print(dataone);
                              print("demodatatatata");

                              type == -1
                                  ? addNewCustomer.add(jsondata)
                                  : addNewCustomer[type] = jsondata;

                              print(addNewCustomer);
                              print("orderLineProducts");

                              setState((){
                                _isSavingData = false;
                                alertCompanyNameController.text = "";
                                alertStreetController.text = "";
                                alertStreetTwoController.text = "";
                                alertCityController.text = "";
                                alertCountryName = null;
                                alertCountryId = null;
                                alertStateName = null;
                                alertStateId = null;
                                alertZipController.text ="";
                                alertEmailController.text = "";
                                alertPhoneController.text = "";
                                alertMobileController.text= "";
                                alertNotesController.text="";
                                alertJobController.text = "";

                              });



                            },

                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF9246A),
                            )),
                      ),
                    ],
                  ),

                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20,bottom: 30),
                    child: SizedBox(
                      width: 304,
                      height: 33,
                      child: ElevatedButton(
                          child: Text(
                            "Discard",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.57,
                                color: Color(0xFFF9246A),fontFamily: 'Mulish'),
                          ),
                          onPressed: () {

                            setState((){
                              alertCompanyNameController.text = "";
                              alertStreetController.text = "";
                              alertStreetTwoController.text = "";
                              alertCityController.text = "";
                              alertCountryName = null;
                              alertCountryId = null;
                              alertStateName = null;
                              alertStateId = null;
                              alertZipController.text ="";
                              alertEmailController.text = "";
                              alertPhoneController.text = "";
                              alertMobileController.text= "";
                              alertNotesController.text="";
                              alertJobController.text = "";

                            });

                            Navigator.pop(context);

                          },

                          style: ElevatedButton.styleFrom(
                            primary:Colors.white,
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

  void tokendata() async {
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    token = await getUserJwt();

    setState(() {
      _isInitialized = true;
    });
  }

  customerCreate() async {
    print(customerController.text);
    print(streetController.text);
    print(streettwoController.text);
    print(cityController.text);
    print(websiteController.text);

    print(emailController.text);
    print(jobpositionController.text);
    print(referenceController.text);
    print(internalnotesController.text);
    print(zipController.text);

    print(taxidController.text);
    print(phoneController.text);
    print(mobileController.text);
    print(companyId);
    print(customerCampanyId);

    print(titleId);
    print(stateId);
    print(countryId);
    print(customerrankController.text);
    print(supplierrankController.text);
    print(salespersonId);
    print(paymenttermsId);
    print("demoooo");

    String value = await createCustomer(
        radioInput,
        customerController.text,
        streetController.text,
        streettwoController.text,
        cityController.text,
        websiteController.text,
        emailController.text,
        jobpositionController.text,
        referenceController.text,
        internalnotesController.text,
        zipController.text,
        taxidController.text,
        phoneController.text,
        mobileController.text,
        companyId,
        customerCampanyId,
        titleId,
        stateId,
        countryId,
        customerrankController.text,
        supplierrankController.text,
        tags,
        salespersonId,
        paymenttermsId,
        languageId,
        pricelistId,
        fiscalpositionId,
        personImg,
        addNewCustomer);

    return value;
  }


  customerEdit() async{

print(addNewCustomer);
print("addNewCustomer");

    String value = await EditCustomer(
        radioInput,
        customerController.text,
        streetController.text,
        streettwoController.text,
        cityController.text,
        websiteController.text,
        emailController.text,
        jobpositionController.text,
        referenceController.text,
        internalnotesController.text,
        zipController.text,
        taxidController.text,
        phoneController.text,
        mobileController.text,
        companyId,
        customerCampanyId,
        titleId,
        stateId,
        countryId,
        customerrankController.text,
        supplierrankController.text,
        tags,
        salespersonId,
        paymenttermsId,
        languageId,
        pricelistId,
        fiscalpositionId,
        addNewCustomer,
        widget.customnerId,
        personImg);
    return value;

  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImages();
                      //getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                      style: ElevatedButton.styleFrom(

                        primary: Color(0xFFF9246A),
                      )                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      print("system 2");
                      getImage(ImageSource.camera);

                      //getImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                      style: ElevatedButton.styleFrom(

                        primary: Color(0xFFF9246A),
                      )
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Future getImages() async {
  //   final pickedFile = await picker.pickMultiImage(
  //       imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
  //   List<XFile> xfilePick = pickedFile;
  //
  //   setState(
  //         () {
  //       if (xfilePick.isNotEmpty) {
  //         for (var i = 0; i < xfilePick.length; i++) {
  //           selectedImages[0] = (File(xfilePick[i].path));
  //         }
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Nothing is selected')));
  //       }
  //     },
  //   );
  // }


  Future getImages() async {
    XFile? img = await picker.pickImage(source: ImageSource.gallery);
    List imageData = [];
    imageData.add(img);
    print(imageData);
    print("system 2");
    // var img = await picker.pickMultiImage();


    if (img != null) {
      if (imageData.isNotEmpty) {
        selectedImages.insert(0, (File(img.path)));


        imagepath = selectedImages[0].path.toString();
        File imagefile = File(imagepath); //convert Path to File
        Uint8List imagebytes =
        await imagefile.readAsBytes(); //convert to bytes
        setState(() {
          personImg = base64.encode(imagebytes);
          print(personImg);
          print("system 3");
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing is selected')));
      }


      //   final pickedFile = await picker.pickImage(
      //     imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
      // List<XFile> xfilePick = pickedFile;
      //
      // setState(
      //       () {
      //     if (xfilePick.isNotEmpty) {
      //       for (var i = 0; i < xfilePick.length; i++) {
      //         selectedImages[0] = (File(xfilePick[i].path));
      //       }
      //     } else {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(content: Text('Nothing is selected')));
      //     }
      // },
    }

  }


  Future getImage(ImageSource media) async {
    print(selectedImages);
    print("selectedImages");

    setState(() {
      isLoading = true;
    });
    print("system 1");
    // var img = await picker.pickImage(source: media));
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print(imageData);
    print("system 2");
    // var img = await picker.pickMultiImage();


    if (img != null) {

      if (imageData.isNotEmpty) {
        selectedImages.insert(0, (File(img.path)));


        imagepath = selectedImages[0].path.toString();
        File imagefile = File(imagepath); //convert Path to File
        Uint8List imagebytes =
        await  imagefile.readAsBytes() ; //convert to bytes
        setState(() {
          personImg = base64.encode(imagebytes);
          print(personImg);
          print("system 3");
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nothing is selected')));
      }


    }



    // if (img != null) {
    //   setState(
    //     () {
    //       if (imageData.isNotEmpty) {
    //         selectedImages.insert(0, (File(img.path)));
    //         //  selectedImages[1]=(File(img.path));
    //
    //         print("system 3");
    //         // for (var i = 0; i < imageData.length; i++) {
    //         //   selectedImages[1]=(File(imageData[i].path));
    //         //
    //         // }
    //         //
    //       } else {
    //         ScaffoldMessenger.of(context).showSnackBar(
    //             const SnackBar(content: Text('Nothing is selected')));
    //       }
    //     },
    //   );
    // }
    print("system 4");

    setState(() {
      isLoading = false;
    });
  }

  getCustomerCompanyDetail(companyId) async {
    var data = await getCustomerCompanyData(companyId);
    print(data);
    print("dropdown valuesss");

    setState(() {
      streetController.text = data["street"] ?? "";
      streettwoController.text = data["street2"] ?? "";
      cityController.text = data["city"] ?? "";
      zipController.text = data["zip"] ?? "";
      countryName = data["country_id"] ?? "";
      countryId = data["country_id"]['id'] ?? null;
      stateName = data["state_id"] ?? "";
      stateId = data["state_id"]['id'] ?? null;
      languageName = data["lang"] ?? "";
      languageId = data["lang"]['id'] ?? null;
      customerCampanyName = data["company_id"] ?? "";
      customerCampanyId = data["company_id"]['id'] ?? null;
      taxidController.text = data["vat"]??"";

      //dropdownCustomerData = data;
    });
  }




  void getCustomerDetails() async {
    token = await getUserJwt();
    var data = await getCustomerDefaultData(widget.customnerId, "");
    setState(() {
      personImg= (data['image_1920']??"").toString();

      print("imagedataaaa");
      radioInput =data['company_type'].toString();
      customerController.text= data['name'].toString();
      companyId = data['parent_id']['id']??null;
      companyName = data['parent_id']??"";
      streetController.text = data['street']??"";
      streettwoController.text= data['street2']??"";
      cityController.text =data['city']??"";
      stateName= data['state_id']??"";
      stateId= data['state_id']['id']??null;
      countryName = data['country_id']??"";
      countryId = data['country_id']['id']??null;
      zipController.text =data['zip']??"";
      taxidController.text = data['vat']??"";
      customerCampanyName = data['company_id']??"";
      customerCampanyId= data['company_id']['id']??null;

      jobpositionController.text = data['function']??"";
      phoneController.text =data['phone']??"";
      mobileController.text =data['mobile']??"";
      customerrankController.text =(data['customer_rank']??"").toString();
      supplierrankController.text =(data['supplier_rank']??"").toString();
      emailController.text =data['email']??"";
      websiteController.text =data['website']??"";
      titleName = data['title']??"";
      titleId= data['title']['id']??null;
      salespersonName = data['user_id']??"";
      salespersonId =data['user_id']['id']??null;

      paymenttermsName = data['property_payment_term_id']??"";
      paymenttermsId= data['property_payment_term_id']['id']??null;
      pricelistName = data['property_product_pricelist']??"";
      pricelistId = data['property_product_pricelist']['id']??null;
      fiscalpositionName = data['property_account_position_id']??"";
      fiscalpositionId = data['property_account_position_id']['id']??null;

      languageName = data['lang']??"";
      languageId=data['lang']['id']??null;
      referenceController.text = data['ref']??"";
      internalnotesController.text = data['comment'] .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
          .toString() ??
          "";

      for (int i = 0; i < data['child_ids'].length; i++) {
        addNewCustomer.add(data['child_ids'][i]);
      }




      for (int i = 0; i < data['category_id'].length; i++) {
        selctedTag.add(data['category_id'][i]);
      }

      for (int i = 0; i < selctedTag.length; i++) {
        editTagName.add(new ValueItem(
            label: selctedTag[i]['name'],
            value: selctedTag[i]['id'].toString()));
      }

      tags = editTagName.map((item) => item.value).toList();






      _isInitialized = true;
    });

    print(token);
  }

}
