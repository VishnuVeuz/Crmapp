import 'dart:convert';

import 'package:crm_project/bottomnavigation.dart';
import 'package:crm_project/commonleads.dart';
import 'package:crm_project/opportunitymainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../leadcreation.dart';
import '../notificationactivity.dart';
import '../api.dart';
import '../drawer.dart';
import '../leadmainpage.dart';
import '../model/leadfilter.dart';
import '../model/leadmodel.dart';
import '../globals.dart' as globals;
import '../notification.dart';




class LeadScrolling extends StatefulWidget {
  final dynamic type;
  var quotationFrom;
  var filterItems;
  LeadScrolling(this.type,this.quotationFrom,this.filterItems);


  @override
  _LeadScrollingState createState() => _LeadScrollingState();
}
class _LeadScrollingState extends State<LeadScrolling> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _error1;
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<LeadModel> _LeadModels;
  final int _nextPageTrigger = 3;
  String? token,leadType;
  String searchText="";
  String notificationCount="0";
  String messageCount="0";
  bool isSearching = false;
  bool searchBanner = true,searchoption= false,filtervisible = false;

  TextEditingController searchController = TextEditingController();

  final _multiSelectKey = GlobalKey<FormFieldState>();

  static List<LeadFilter> filterLists = [
    LeadFilter( leadfilterName: "assigned_to_me", ),
    LeadFilter( leadfilterName: "activities_today"),
    LeadFilter( leadfilterName: "activities_upcoming_all"),
    LeadFilter( leadfilterName: "activities_overdue"),
    LeadFilter( leadfilterName: "lost"),
    LeadFilter( leadfilterName: "inactive"),
    LeadFilter( leadfilterName: "unassigned_leads")

  ];
  final _items = filterLists
      .map((filterlist) => MultiSelectItem<LeadFilter>(filterlist, filterlist.leadfilterName))
      .toList();
  List<LeadFilter?> selectedFilter= [];
  String username="";


  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _LeadModels = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    print("sfgdds");
    leadType = widget.type;

    print(leadType);
    print("demotesttesttt");
    fetchData("");
    profilePreference();
  }


  Future<void> fetchData(data) async {

    print("lead fetch");
    token = await getUserJwt();
    String baseUrl= await getUrlString();
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    String urls;
    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);
    print("pagenumberrr");


    if (searchText.isEmpty) {
      widget.quotationFrom == "notification" ?
      urls = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=${widget.filterItems}"
          : urls = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=[$leadType]";

    }
    else
      {

        widget.quotationFrom == "notification" ?
        urls = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&filters=${widget.filterItems}"
            : urls = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&filters=[$leadType]";

      }



    try {
      String base = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=[$leadType]";

    final response = await get(Uri.parse(urls

          //"${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=[$leadType]"
       ),

        headers: {

          'Authorization': 'Bearer $token',

        },
      );

      var responseList = jsonDecode(response.body);
      print(urls);
      print("company_ids");
      print(globals.selectedIds);
      print(responseList['records']);
      print("company_idstest");

      List LeadModelList1= responseList['records'];

      if(LeadModelList1.isEmpty){
        print("vishnu");
        setState(() {
          _loading = false;
          _error1 = true;
        });



      }
      else{
        print(responseList['records'].length);
        print("vishnuvn");

        if(responseList['records'].length==0){
          setState(() {
            _loading = false;
            _error = true;
          });
        }

        else{
          List<LeadModel> LeadModelList = (responseList['records'] as List<dynamic>).map<LeadModel>((data) => LeadModel(data['id']??"",data['name']??"",data['contact_name']??"",data['priority']??"",data['tag_ids']??"",data['image_1920']??"")).toList();
          setState(() {
            _isLastPage = LeadModelList.length < _numberOfLeadModelsPerRequest;
            _loading = false;

            if (LeadModelList.length < _numberOfLeadModelsPerRequest) {
              // If the result length is less than 10, set page number to 1
              _pageNumber = 1;
            } else {
              // Otherwise, increment the page number
              _pageNumber = _pageNumber + 1;
            }
            if (_pageNumber == 1) {
              _LeadModels.clear();
            }




            _LeadModels.addAll(LeadModelList);

          });
        }


      }






    } catch (e) {
      print("error --> $e");
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }


  Widget errorDialog({required double size}){
    return SizedBox(
      height: 180,
      width: 400,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Something went wrong while fetching data.',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black
            ),
          ),
          const SizedBox(height: 10,),
          TextButton(
              onPressed:  ()  {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData("");
                });
              },
              child: const Text("Retry", style: TextStyle(fontSize: 18, color: Colors.red),)),
        ],
      ),
    );
  }

  Widget errorDialog1({required double size}){
    return SizedBox(
      height: 180,
      width: 400,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No data found.',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black
            ),
          ),
          const SizedBox(height: 10,),
          TextButton(
              onPressed:  ()  {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchData("");
                });
              },
              child: const Text("Retry", style: TextStyle(fontSize: 18, color: Colors.red),)),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0,right: 0),
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width/4.5,
                child: Text(username,style: TextStyle(
                    fontFamily: 'Proxima Nova',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                    decoration: TextDecoration.none),),
              ),
            )
          ],
        ),
        leading: Builder(
          builder: (context)=>Padding(
            padding: const EdgeInsets.only(left:20),
            child: CircleAvatar(
              radius: 10,
              child: Icon(
                Icons.person,
                size: 20,

                color: Colors
                    .white,
              ),

            ),
          ),
        ),

        automaticallyImplyLeading: false,
        actions: [
          Builder(builder: (context){
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
                          bottom: 24,
                          right: 24,

                          child: Container(
                            width: 17.0,
                            height: 19.0,
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
                          bottom: 24,
                          right: 24,

                          child: Container(
                            width: 17.0,
                            height: 19.0,
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
                  child: IconButton(icon:SvgPicture.asset("images/drawer.svg"),
                    onPressed: (){
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ],
            );
          })
        ],
      ),
      body: buildLeadModelsView(),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LeadCreation(0)));

          },
          backgroundColor: Color(0xFF043565),
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar:MyBottomNavigationBar(1),

    );
  }

  Widget buildLeadModelsView() {
    if (_LeadModels.isEmpty) {
      if (_loading) {
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      } else if (_error) {
        return Center(
            child: errorDialog(size: 20)
        );
      }

      else if(_error1){
      return Center(
      child: errorDialog1(size: 20)
    );
      }
    }
    return Column(
      children: [
        Visibility(
          visible: searchBanner,
          child: Padding(
            padding: const EdgeInsets.only(top: 10,left: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: (){

                        setState(() {

                          searchoption= false;
                          filtervisible = true;
                        });

                      },
                      child: SvgPicture.asset(
                        "images/filter.svg",
                        width: 28,
                        height: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text("Filter",
                          style: TextStyle(
                            fontFamily: 'Proxima Nova',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xFF212121),
                          )),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){

                          setState(() {
                            searchoption= true;
                            filtervisible = false;

                          });
                        },
                        child: SvgPicture.asset(
                          "images/search1.svg",
                          width: 28,
                          height: 28,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text("Search",
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xFF212121),
                            )),
                      )
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
        Visibility(
          visible: filtervisible,
          child: Padding(
            padding: const EdgeInsets.only(left: 15,right: 20),


            child: MultiSelectBottomSheetField<LeadFilter?>(
              key: _multiSelectKey,
              initialChildSize: 0.7,
              maxChildSize: 0.95,

              title: Text("Leads Category",style:
              TextStyle(fontWeight: FontWeight.w600,fontSize: 16, fontFamily: 'Proxima Nova',),),



              buttonText: Text("Lead Filter",

                style:
              TextStyle(fontWeight: FontWeight.w500,fontSize: 16, fontFamily: 'Proxima Nova',color: Colors.black),),
              buttonIcon:
              Icon(
              //  Icons.arrow_drop_down_rounded,
                Icons.filter_list_alt,
                color: Colors.grey,
              ),




              items: _items,
              searchable: true,




            cancelText: Text("Cancel",style: TextStyle(color: Color(0xFF231F20),
                fontWeight: FontWeight.w700,fontSize: 17.57,
                fontFamily: 'Proxima Nova'
            ),),
              confirmText: Text("Ok",style: TextStyle(color: Color(0xFF231F20),
              fontWeight: FontWeight.w700,fontSize: 17.57,
                  fontFamily: 'Proxima Nova'
              ),),

              onConfirm: (values) async{
                setState(() {
                  print(values);
                  print("drop values");
                  selectedFilter = values;
                  leadType = selectedFilter.join(', ');
                  leadType = leadType?.replaceAll('[', '').replaceAll(']', '');

                   _pageNumber = 1;
                  _loading = true;
                  _error = false;
                  _LeadModels.clear();
                  fetchData("");


                });

                _multiSelectKey.currentState?.validate();
              },
              chipDisplay: MultiSelectChipDisplay(
                onTap: (item) {
                  setState(() {
                    selectedFilter.remove(item);
                    leadType = selectedFilter.join(', ');
                    leadType = leadType?.replaceAll('[', '').replaceAll(']', '');
                    _pageNumber = 1;
                    _LeadModels.clear();
                    fetchData("");
                  });
                  _multiSelectKey.currentState?.validate();
                },
              ),
            ),





          ),
        ),


        Visibility(
          visible: searchoption,
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  _pageNumber = 1;
                  fetchData("");
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 16, fontFamily: 'Proxima Nova',color: Colors.black),
                prefixIcon:IconButton(icon: Icon(Icons.arrow_back_ios,),
                  onPressed: (){
                    setState(() {
                      searchoption = false;
                      searchBanner = true;
                      searchController.clear();
                      searchText="";
                      loadMoreData();
                    });
                  },iconSize: 15,color: Colors.black ,) ,

                suffixIcon:IconButton(icon: Icon(Icons.close,),onPressed: (){

                  searchController.clear();
                  searchText="";
                  loadMoreData();
                },iconSize: 15,color: Colors.black ,) ,


              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
              itemCount: _LeadModels.length + (_isLastPage ? 0 : 1),

              itemBuilder: (context, index) {


    if (searchText.isEmpty) {
      if (index == _LeadModels.length - _nextPageTrigger) {
        loadMoreData();
      }
    }
    else{

      if (index == _LeadModels.length) {
        loadMoreData();
      }
    }



                if (index == _LeadModels.length) {
                  if (_error) {
                    return Center(
                        child: errorDialog(size: 15)
                    );
                  } else {
                    return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ));
                  }
                }

                final LeadModel leadModel = _LeadModels[index];

                  return Padding(
                      padding: const EdgeInsets.all(0),
                      child: LeadListviewCommon(leadModel.id,
                          leadModel.name, leadModel.contactname, leadModel.priority,
                          leadModel.tags, leadModel.leadimg)
                  );



              }),
        ),
      ],
    );
  }

  profilePreference() async{
    username = await getStringValuesSF() as String;

  }

  void loadMoreData() {
    if (!isSearching) {
      fetchData("");
    }
  }
}
Future getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('personName')??"";
  print(stringValue);
  print("Stringvalueeeee");
  return stringValue;
}


