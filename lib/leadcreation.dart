import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'drawer.dart';
import 'lead_detail.dart';
import 'leadmainpage.dart';
import 'globals.dart' as globals;


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

  final _formKey = GlobalKey<FormState>();

  late String rtaingValue = "0";
  String? token;

  bool _isInitialized = false;
  List tags = [];
  List seectedTag = [];
  List<ValueItem> editTagName = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    widget.leadId==0 ? defaultvalues() : getLeadDetails();



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
              Text("New", style: TextStyle(
                  fontFamily: 'Mulish',
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
        body: Form(
          key: _formKey,
          child: WillPopScope(
            onWillPop: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LeadMainPage()));
              return true;
            },
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              //color: Colors.cyan,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
                      child: SizedBox(
                        width: 93,
                        height: 33,
                        child: ElevatedButton(child: Text("Save", style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.57,
                            color: Colors.white),),

                            onPressed: () async {

                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );

                              setState(() {
                                _isInitialized = false;
                              });

                              String resmessage;
                              print(leadnameController.text);
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
                              print(companyId);
                              print(salespersonId);
                              print(salesteamId);
                              print(rtaingValue);
                              print(campaignId);
                              print(mediumId);
                              print(sourceId);
                              print(internalnotesController.text);
                              print(tags);
                              print("tagsss");

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
                              primary: Color(0xFFF04254),
                            )
                        ),
                      ),
                    ),
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
                        style: TextStyle(fontSize: 12),
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Lead Name',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: probabilityController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            labelText: 'Probability',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: companynameController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            // border: UnderlineInputBorder(),
                            labelText: 'Company Name',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),

                    //title

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,

                        value: titleName,
                        hint: Text("Title",
                          style: TextStyle(fontSize: 10, color: Colors.black),),
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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        "${item["name"]}"),

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
                        style: TextStyle(fontSize: 12),
                        controller: contactnameController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Contact Name',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      child: Text(
                        "Address", style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF000000)),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: streetController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Street',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: streettwoController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Street2',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: cityController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'City',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    //country

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: countryName,
                        hint: Text("Country",
                          style: TextStyle(fontSize: 10, color: Colors.black),),


                        searchHint: null,
                        autofocus: false,
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
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),
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
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(

                        value: stateName,
                        hint: Text("State",
                          style: TextStyle(fontSize: 10, color: Colors.black),),


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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),

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
                        style: TextStyle(fontSize: 12),
                        controller: zipController,
                        maxLength: 6,
                        decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Zip',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),


                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: websiteController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Website',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),

                    //language

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: languageName,
                        hint: Text("Language",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),
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
                        style: TextStyle(fontSize: 12),
                        controller: emailController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            // border: UnderlineInputBorder(),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: emailccController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            // border: UnderlineInputBorder(),
                            labelText: 'Email cc',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: jobpositionController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Job Position',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: phoneController,
                        decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),


                            labelText: 'Phone',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: mobileController,
                        decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            labelText: 'Mobile',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),


                    //company
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: campanyName,
                        hint: Text("Company",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),
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
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: salespersonName,
                        hint: Text("Salesperson",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),
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
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: salesteamName,
                        hint: Text("Sales Team",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),

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

                        "Priority", style: TextStyle(fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),),
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

                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: MultiSelectDropDown.network(
                           hint: 'Tags',
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
                        chipConfig: const ChipConfig(wrapType: WrapType.wrap),

                        responseParser: (response) {
                          debugPrint('Response: $response');

                          final list = (response['records'] as List<
                              dynamic>).map((e) {
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


                    //campaign

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: campaignName,
                        hint: Text("Campaign",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),

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
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: mediumName,
                        hint: Text("Medium",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),
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
                          horizontal: 15, vertical: 0),
                      child: SearchChoices.single(
                        //items: items,
                        value: sourceName,
                        hint: Text("Source",
                          style: TextStyle(fontSize: 10, color: Colors.black),),

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
                        menuConstraints: BoxConstraints.tight(
                            const Size.fromHeight(350)),
                        itemsPerPage: 10,
                        currentPage: currentPage,
                        selectedValueWidgetFn: (item) {
                          return (Center(
                              child: Container(
                                width: 300,
                                child: Text(item["name"], style: TextStyle(
                                    fontSize: 10, color: Colors.black),),
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
                                        " ${item["name"]}"),

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
                        style: TextStyle(fontSize: 12),
                        controller: refferedbyController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            // border: UnderlineInputBorder(),
                            labelText: 'Reffered by',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),


                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 0),
                      child: TextFormField(
                        style: TextStyle(fontSize: 12),
                        controller: internalnotesController,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),),

                            // border: UnderlineInputBorder(),
                            labelText: 'Internal Notes',
                            labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                        ),
                      ),),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  void defaultvalues() async{

    token = await getUserJwt();
    var data =  await defaultDropdown("lead.lead");
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


    print(token);


  }


  void getLeadDetails() async{

    token = await getUserJwt();
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


      print(editTagName);
      print(campanyName);
      print(tags);
      print(countryName);
      print("datatatatta");




      _isInitialized = true;

    });


    print(token);


  }

  leadCreate() async {
    String value= await createLead(leadnameController.text, emailController.text, emailccController.text, contactnameController.text,
        companynameController.text, phoneController.text, rtaingValue, languageId, streetController.text, streettwoController.text,
        cityController.text, websiteController.text, jobpositionController.text, refferedbyController.text, internalnotesController.text,
        companyId, salespersonId, salesteamId, double.parse(probabilityController.text), stateId, zipController.text,
        countryId, mobileController.text, tags, titleId, mediumId, sourceId, campaignId);

    return value;
  }

  leadEdit() async{



    String value =await editLead(leadnameController.text, emailController.text, emailccController.text, contactnameController.text,
        companynameController.text, phoneController.text, rtaingValue, languageId, streetController.text, streettwoController.text,
        cityController.text, websiteController.text, jobpositionController.text, refferedbyController.text, internalnotesController.text,
        companyId, salespersonId, salesteamId, double.parse(probabilityController.text), stateId, zipController.text,
        countryId, mobileController.text, tags, titleId, mediumId, sourceId, campaignId,widget.leadId);

    return value;

  }

//leadCreate() async {}

}
