import 'dart:convert';
import 'dart:ui';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:crm_project/drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'leadmainpage.dart';
import 'model/mergeopportunity.dart';
import 'opportunity_detail.dart';


class LeadConvert extends StatefulWidget {
  int leadId;

  LeadConvert(this.leadId);

  @override
  State<LeadConvert> createState() => _LeadConvertState();
}

class _LeadConvertState extends State<LeadConvert> {

  String? nameType,customerAction;
  int tabIds = 0;
  String? conversioActions;
  String? conversionType,custType;
  bool isLoading = false;
  bool _isInitialized = false;
  String? convertType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    convertLeadData();

  }


  @override
  Widget build(BuildContext context) {
    print(widget.leadId);
    print("daaaataaaaaaaa");

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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        drawer: MainDrawer(),
        appBar: AppBar(
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("Convert to opportunity",
              style: TextStyle(fontSize: 20, color: Colors.black),),
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          actions: [

            Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(icon: Image.asset("images/cross.png"),
                  onPressed: () {
                    Navigator.pop(context);
                  },),
              );
            })
          ],

        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  decoration: BoxDecoration(
                    color: Colors.white,

                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Divider(),

                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text("Conversion Action",
                            style: TextStyle(fontSize: 15),),
                        ),


                        SingleChildScrollView(
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 1.1,
                            //color: Colors.orange,
                            child: DefaultTabController(
                              initialIndex: tabIds,
                              length: 2,
                              child:
                              Column(
                                children: <Widget>[

                                  Column(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top: 18),
                                        child: ButtonsTabBar(


                                          backgroundColor: Color(0xFFF04254),

                                          //elevation: 0,


                                          unselectedBackgroundColor: Colors
                                              .white,
                                          unselectedLabelStyle: TextStyle(
                                              color: Color(0xFF212121)),
                                          labelStyle:
                                          TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,),
                                          tabs: const [
                                            Tab(text: "Convert to opportunity"),
                                            Tab(
                                              text: "Merge with existing opportunity",),
                                            //Tab( text: "Schedule Activity",),


                                          ],
                                        ),
                                      ),


                                    ],
                                  ),
                                  Expanded(
                                    child: TabBarView(

                                      children: <Widget>[
                                        Center(
                                          // child:  ConvertToOpportunity(widget.leadId,conversionType!,custType!),
                                          child: ConvertToOpportunity(
                                              widget.leadId),
                                        ),
                                        Center(
                                          //child: MergeOpportunity(widget.leadId,conversionType!,custType!),
                                          //child: MergeOpportunity(widget.leadId,"",""),
                                            child: MergeOpportunity(
                                                widget.leadId),

                                          // child: Container(
                                          //   child: Text("namesss"),
                                          // ),

                                        ),
                                        // Center(
                                        //   child: ScheduleActivity(),
                                        // ),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      );
    }
  }

  convertLeadData() async{

    var data =  await convertleadDataGet(widget.leadId,"convert");
    setState(() {
      convertType = data['name']??'';
      _isInitialized = true;

      convertType == "convert"?tabIds=0:tabIds=1;
    });
    return convertType;
  }

}


// lead convert to opportunity


class ConvertToOpportunity extends StatefulWidget {

  int leadId;

  // String tabOpt;
  // String custOpt;


   // ConvertToOpportunity(this.leadId,this.tabOpt,this.custOpt);
  ConvertToOpportunity(this.leadId);



  @override
  State<ConvertToOpportunity> createState() => _ConvertToOpportunityState();
}

class _ConvertToOpportunityState extends State<ConvertToOpportunity> {



  bool isLoading = true;

  bool existing_customer_conmdition = false;
  String? radioValue;
  String? conversioActions,customerAction;
  List companyIdData = [];


  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);

  dynamic salespersonName,salespersonId,salesteamName,customerName,customerId,
      salesteamId,companyId,leadconvertId;

  String? token;


  @override
  void initState() {
    super.initState();

    // print(widget.customerAction);
    print("jbvjdvhdjebdvh");

    if(widget.leadId != 0){
      convertLeadData();
      setState(() {
        isLoading = true;
      });


    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,

     // color: Colors.blue,
      child: Stack(
          children: [SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15,left: 25),
                  child: Text("Assign this opportunity to",style: TextStyle(fontWeight: FontWeight.w500),),
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10),
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
                              : "&filter=$keyword"}${companyId == null
                              ? ""
                              : "&company_id=$companyId"}"),
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
                      horizontal: 15, vertical: 1),
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
                Divider(),

                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 25),
                  child: Text("Customer",style: TextStyle(fontWeight: FontWeight.w500),),
                ),


                RadioListTile(
                  title: Text("Create a new customer",

                    style: TextStyle(fontSize: 14),),
                  value: "create",
                  groupValue: conversioActions,
                  onChanged: (value){
                    setState(() {
                      conversioActions = value.toString();
                      existing_customer_conmdition = false;
                      print(conversioActions);
                      print("drop values");
                    });
                  },
                ),

                RadioListTile(
                  title: Text("Link to an existing customer"
                    ,style: TextStyle(fontSize: 14),
                  ),
                  value: "exist",
                  groupValue: conversioActions,
                  onChanged: (value){
                    setState(() {
                      conversioActions = value.toString();

                      existing_customer_conmdition = true;
                      print(conversioActions);
                      print("drop values");
                    });
                  },
                ),

                RadioListTile(
                  title: Text("Do not link to a customer"
                    ,style: TextStyle(fontSize: 14),
                  ),
                  value: "nothing",
                  groupValue: conversioActions,
                  onChanged: (value){
                    setState(() {
                      conversioActions = value.toString();
                      existing_customer_conmdition = false;
                      print(conversioActions);
                      print("drop values");
                    });
                  },
                ),



                Visibility(
                  visible: existing_customer_conmdition,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 5),
                    child: SearchChoices.single(
                      //items: items,
                      label: 'Customer',
                      value: customerName,
                      hint: Text("Customer",
                        style: TextStyle(fontSize: 10, color: Colors.black),),

                      searchHint: null,
                      autofocus: false,
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          print("value");
                          customerName = value;
                          customerId = value["id"];
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
                              child: Text(item["display_name"], style: TextStyle(
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
                        print("afnademo");


                        Response response = await get(Uri.parse(
                            "${baseUrl}api/customers?count=10${keyword == null? ""
                                : "&filter=$keyword&page_no=${pageNb ??
                                1}&model='lead'${companyIdData == null
                                ? []
                                : "&company_id=$companyIdData"}"}"),
                          headers: {

                            'Authorization': 'Bearer $token',

                          },
                        )
                            .timeout(const Duration(
                          seconds: 10,
                        ));

                        String datata =  ("${baseUrl}api/customers?count=10${keyword == null? ""
                            : "&filter=$keyword&page_no=${pageNb ??
                            1}&model='lead'${companyIdData == null
                            ? []
                            : "&company_id=$companyIdData"}"}");

                        print(datata);
                        print("dstatata");
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
                                      " ${item["display_name"]}"),

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



                Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 13, left: 25),
                      child: SizedBox(
                        width: 170,
                        height: 43,
                        child: ElevatedButton(
                            child: Center(
                              child: Text(
                                "Create Opportunity",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () async {
                              String leadconvert = await  leadconvertion(leadconvertId,"convert",salespersonId,salesteamId,conversioActions!,customerId,[]);

                              print(leadconvert);
                              print("final complete data");
                              int resmessagevalue = int.parse(leadconvert);
                               if(leadconvert != "0"){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpportunityDetail(resmessagevalue)));
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF04254),
                            ),
                        ),
                      ),
                    ),


                    SizedBox(width: 10,),

                    Padding(
                      padding: const EdgeInsets.only(top: 13,right: 25),
                      child: SizedBox(
                        width: 160,
                        height: 43,
                        child: ElevatedButton(
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.black),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFFFFFF),
                            )),
                      ),
                    ),

                  ],

                ),

              ],
            ),
          ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ]
      ),
    );





  }



  void convertLeadData() async{

    token = await getUserJwt();
    var data =  await convertleadDataGet(widget.leadId,"convert");
    setState(() {
      leadconvertId = data['id']??null;
      salespersonName=data['user_id']??"";
      salespersonId=data['user_id']['id']??null;
      salesteamName=data['team_id']??"";
      salesteamId=data['team_id']['id']??null;
      customerName=data['partner_id']??"";
      customerId=data['partner_id']['id']??null;

      conversioActions = data['action']??'create';

      conversioActions == 'exist'?existing_customer_conmdition=true:existing_customer_conmdition=false;

      print(data['company_id']);
      print(data['company_id'].length);
      print("company data");
      data['company_id'].length>0? companyIdData = data['company_id']:companyIdData = [];

      companyIdData.length>0?  companyId = companyIdData[0]:companyId="";
      isLoading=false;
    });
    print(token);


  }

}



// lead merge to opportunity



class MergeOpportunity extends StatefulWidget {
  int leadId;

  MergeOpportunity(this.leadId);
  @override
  State<MergeOpportunity> createState() => _MergeOpportunityState();
}


class _MergeOpportunityState extends State<MergeOpportunity> {
  // bool isLoading = true;
  // int? mainId;
  //
  // List results = [];
  // var salesTeam;
  // var salespersonTeam;
  // late int ?salesId;
  // late int? salespersonId;
  // String? salespersonTeamTitle = "Sales Person", salesTeamTitle = "Sales Team";


  // new code
  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  List companyIdData = [];
  dynamic salespersonName,salespersonId,salesteamName,
      salesteamId,companyId,leadconvertId;
  List<merge_exist_opportunity> leadDuplicateIdData = [];
  List tabledataId=[];
  late merge_exist_opportunity leadDuplicateId;

  String? token;
  bool isLoading = true;










  DataRow _getDataRow(index, data) {
    print(data);
    print("ffrrreeesss");
    return DataRow(
        cells: <DataCell>[
          DataCell(Container(
              width: 80,
              child: Text(leadDuplicateIdData[index].createDate.toString()))), //add name of your columns here
          DataCell(Container(width: 80, child:Text(leadDuplicateIdData[index].opportunityName.toString()))),
          DataCell(Container(
              width: 80,
              child: Text(leadDuplicateIdData[index].leadType.toString()))), //add name of your columns here
          DataCell(Container(width: 80, child: Text(leadDuplicateIdData[index].contactName.toString()))),
          DataCell(Container(
              width: 80,
              child: Text(leadDuplicateIdData[index].email.toString()))), //add name of your columns here
          DataCell(Container(width: 80, child: Text(leadDuplicateIdData[index].leadStage.toString()))),
          DataCell(Container(
              width: 80,
              child: Text(leadDuplicateIdData[index].salespersonName.toString()))), //add name of your columns here
          DataCell(Container(width: 80, child:Text(leadDuplicateIdData[index].salesTeamName.toString()))),
          DataCell(TextButton(
              onPressed: () {
                print("data deleteddssddddd");
                setState(() {
                  leadDuplicateIdData.removeAt(index);
                });

              },
              child:  IconButton( icon:Image.asset("images/cross.png"), onPressed: () {

                setState(() {
                  leadDuplicateIdData.removeAt(index);
                });
              },
              ))
          ) ]);

  }


  @override
  void initState() {
    super.initState();

    if (widget.leadId != 0) {
      print("datatatatatatatatata");
      print(widget.leadId);
      convertLeadData();
      setState(() {
        isLoading = true;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      child: Stack(
          children: [Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 25),
                child: Text(
                  "Assign this opportunity to",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
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
                            : "&filter=$keyword"}${companyId == null
                            ? ""
                            : "&company_id=$companyId"}"),
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
                    horizontal: 15, vertical: 1),
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
                padding: const EdgeInsets.only(top: 25),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white70,
                        ),
                        columnSpacing: 40,
                        columns: [
                          DataColumn(
                              label: Container(width: 40, child: Text('Created on'))),
                          DataColumn(
                              label: Container(width: 80, child: Text('Opportunity'))),
                          DataColumn(label: Container(width: 80, child: Text('Type'))),
                          DataColumn(
                              label: Container(width: 80, child: Text('Contact name'))),
                          DataColumn(label: Container(width: 80, child: Text('Email'))),
                          DataColumn(label: Container(width: 80, child: Text('Stage'))),
                          DataColumn(
                              label: Container(width: 80, child: Text('Sales person'))),
                          DataColumn(
                              label: Container(width: 80, child: Text('Sales team'))),
                          DataColumn(label: Text("")),
                        ],
                        rows: List.generate(

                          leadDuplicateIdData.length,
                              (index) => _getDataRow(
                            index,
                                leadDuplicateIdData[index],
                          ),
                        ),
                        showBottomBorder: true,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 53, left: 25),
                    child: SizedBox(
                      width: 170,
                      height: 43,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Create Opportunity",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {

                            if(leadDuplicateIdData.length>1 && leadDuplicateIdData.length<6 )
                            {
                              print("lead merge details");
                              for(int i = 0;i<leadDuplicateIdData.length;i++){
                                tabledataId.add(leadDuplicateIdData[i].leadIds);
                              }
                              leadDuplicateIdData.clear();
                              print(tabledataId);
                              print(salespersonId);
                              print(salesteamId);
                              print("table data");

                              String leadconvert = await  leadconvertion(leadconvertId,"merge",salespersonId,salesteamId,"",null,tabledataId);

                              print(leadconvert);
                              print("final complete data");
                              int resmessagevalue = int.parse(leadconvert);
                              if(leadconvert != "0"){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpportunityDetail(resmessagevalue)));
                              }

                            }
                            else{
                              const snackBar = SnackBar(  content: Text('Minimum 2 & Maximum 5  oppertunities to merge'),
                                backgroundColor: Colors.blueGrey,);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }


                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF04254),
                          )),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(top: 53,),
                    child: SizedBox(
                      width: 170,
                      height: 43,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.black),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFFFFFFF),
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),

            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ]
      ),
    );
  }

  void convertLeadData() async{

    token = await getUserJwt();
    var data =  await convertleadDataGet(widget.leadId,"convert");
    setState(() {
      leadconvertId = data['id']??null;
      salespersonName=data['user_id']??"";
      salespersonId=data['user_id']['id']??null;
      salesteamName=data['team_id']??"";
      salesteamId=data['team_id']['id']??null;


      var convertData  = data['duplicated_lead_ids'];


      for (var u in convertData) {
        leadDuplicateId =
        new merge_exist_opportunity(
          leadIds:u["id"],
          createDate:u["create_date"].toString(),
          opportunityName:u["name"].toString(),
          leadType:u["type"].toString(),
          contactName:u["contact_name"].toString(),
          email:u["email_from"].toString(),
          leadStage:u["stage_id"][1].toString(),
          salespersonName:u["user_id"][1].toString(),
          salesTeamName:u["team_id"][1].toString(),

        );
        // salespersonTeam = u["name"];
        // salespersonId = u["id"];
        // print(salespersonTeam);
        // print("datatatatatatat");

        leadDuplicateIdData.add(leadDuplicateId);

      }


      data['company_id'].length>0? companyIdData = data['company_id']:companyIdData = [];

      companyIdData.length>0?  companyId = companyIdData[0]:companyId="";
      isLoading=false;
    });
    print(token);


  }

}






