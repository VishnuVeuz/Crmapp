import 'dart:convert';

import 'package:crm_project/quotationcreation.dart';
import 'package:crm_project/scrolling/customerscrolling.dart';
import 'package:crm_project/scrolling/quotationscrolling.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'calendarmainpage.dart';
import 'calendardetail.dart';
import 'leadmainpage.dart';
import 'login.dart';
import 'model/multicompany.dart';
import 'globals.dart' as globals;
import 'opportunity_detail.dart';
import 'opportunitycreation.dart';
import 'opportunitymainpage.dart';


class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool _isInitialized = false;
  List<multiCompany>? companyList;
  // List<ExpansionItem> companyList = [
  //   ExpansionItem(name: 'Item 1', selected: true),
  //   ExpansionItem(name: 'Item 2', selected: false),
  //   ExpansionItem(name: 'Item 3', selected: false),
  //   // Add more items here as needed
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    companyData();
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
      return Drawer(
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Image.asset("images/veuz.png")),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFF3D418E),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    width: MediaQuery.of(context).size.width,

                    //height: 60,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: ExpansionTile(
                        iconColor: Colors.white,
                        title: Text(
                          'Select Company',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.84,
                              color: Colors.white),
                        ),
                        children: <Widget>[
                          // Your ListView.builder goes here
                          Container(
                            height: MediaQuery.of(context).size.height/2.5,

                            child: ListView.builder(
                              shrinkWrap: true,
                               physics: ScrollPhysics(),
                              itemCount: companyList!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  activeColor: Colors.white,
                                  checkColor: Colors.black,
                                  title: InkWell(
                                    onTap: () {
                                      print(
                                          "selected company ${companyList![index].name}");
                                    },
                                    child: Text(
                                      companyList![index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                  value: companyList![index].selected,
                                  onChanged: (newValue) {
                                    setState(() {
                                      companyList![index].selected =
                                          newValue ?? false;


                                      companyList![index].selected=newValue!;

                                      final jsonListmultiCompany = json.encode(companyList);
                                      addMultiCmpnySF(jsonListmultiCompany);

                                      companyData();

                                      print(jsonListmultiCompany!);
                                      print(companyList![1].name);
                                      print(companyList![1].selected);
                                      print("Demo");
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      //color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 31),
                            child: Text(
                              "Leads",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.84,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF5D5F8F)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LeadMainPage()));
                  },
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      //color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 31),
                            child: Text(
                              "Opportunity",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.84,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF5D5F8F)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OpportunityMainPage(null,"","","")));
                  },
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      //color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 31),
                            child: Text(
                              "Quotations",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.84,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF5D5F8F)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuotationScrolling("","")));
                  },
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      //color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 31),
                            child: Text(
                              "Customers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.84,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF5D5F8F)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CustomerScrolling("","")));


                  },
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      //color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 31),
                            child: Text(
                              "Calender",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.84,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF5D5F8F)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Calender(null,"",DateTime.now(),null,[])));



                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    //color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Image.asset("images/logout.png"),
                            onPressed: () {},
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.84,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async{



                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    preferences.setString('logedData', "loggedout");
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             CalencerFullDetail()));


                  },
                )
              ],
            ),
          )
        ],
      ));
    }
  }

  companyData() async {
    String responce = await getUserCompanyData();
    print(responce);
    print("responce");

    List<dynamic> dynamicList = json.decode(responce);

    companyList =
        dynamicList.map((item) => multiCompany.fromJson(item)).toList();

    print(globals.selectedIds);



    List<Map<String, dynamic>> dataList = json.decode(responce).cast<Map<String, dynamic>>();

    globals.selectedIds =  dataList
        .where((item) => item['selected'] == true)
        .map<int>((item) => item['id'])
        .toList();

    print(companyList);
    print("kjbjdemo");
    setState(() {
      _isInitialized = true;
    });

  }
}
