import 'dart:convert';

import 'package:crm_project/commonleads.dart';
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
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<LeadModel> _LeadModels;
  final int _nextPageTrigger = 3;
  String? token,leadType;

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
    fetchData();
    profilePreference();
  }


  Future<void> fetchData() async {

    print("lead fetch");
    token = await getUserJwt();
    String urls;
    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);
    print("pagenumberrr");
    widget.quotationFrom == "notification" ?
    urls = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=${widget.filterItems}"
    : urls = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=[$leadType]";


    try {
      String base = "${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=[$leadType]";
      // print(base);
      // print("basetotooooo");
    final response = await get(Uri.parse(urls

          //"${baseUrl}api/leads?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=[$leadType]"
       ),

        headers: {

          'Authorization': 'Bearer $token',

        },
      );
      //"https://jsonplaceholder.typicode.com/LeadModels?_page=$_pageNumber&_limit=$_numberOfLeadModelsPerRequest"));
      //List responseList = json.decode(response.body);
      var responseList = jsonDecode(response.body);
      print(urls);
      print("company_ids");
      print(globals.selectedIds);
      print(responseList['records']);
      print("company_idstest");

      List LeadModelList1= responseList['records'];
      if(LeadModelList1.isEmpty){
        print("vishnu");



      }
      else{
        print(responseList['records'].length);
        print("vishnuvn");
        List<LeadModel> LeadModelList = (responseList['records'] as List<dynamic>).map<LeadModel>((data) => LeadModel(data['id']??"",data['name']??"",data['contact_name']??"",data['priority']??"",data['tag_ids']??"",data['image_1920']??"")).toList();
        setState(() {
          _isLastPage = LeadModelList.length < _numberOfLeadModelsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          //_LeadModels.clear();

          _LeadModels.addAll(LeadModelList);

        });
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
                  fetchData();
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
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
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
                // Adjust the size of the icon as per your requirements
                color: Colors
                    .white, // Adjust the color of the icon as per your requirements
              ),

            ),
          ),
        ),

        automaticallyImplyLeading: false,
        actions: [
          Builder(builder: (context){
            return Row(
              children: [
                // Container(
                //   child: Stack(
                //       alignment: Alignment
                //           .center,
                //       children: [
                //         IconButton(icon: SvgPicture.asset("images/messages.svg"),
                //           onPressed: () {
                //             Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         Notifications()));
                //           },
                //         ),
                //         Positioned(
                //           bottom: 25,
                //           right: 28,
                //
                //           child: Container(
                //             width: 15.0,
                //             height: 15.0,
                //             decoration: BoxDecoration(
                //               shape: BoxShape
                //                   .circle,
                //               color: Color(0xFFFA256B),
                //             ),
                //             child: Center(child: Text("12",style: TextStyle(color: Colors.white,fontSize: 8),)),
                //           ),
                //         ),
                //       ]
                //   ),
                // ),
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
                            child: Center(child: Text("12",style: TextStyle(color: Colors.white,fontSize: 8),)),
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
                // IconButton(onPressed:(){
                //  // buildLeadModelsView();
                //   // showDialog(
                //   //   context: context,
                //   //   builder: (BuildContext context) =>
                //   //       buildLeadModelsView(),
                //   // ).then((value) => setState(() {}));
                // },
                //     icon:Icon(Icons.filter_alt_outlined,color: Colors.white,)),
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
     // appBar: AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: buildLeadModelsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LeadCreation(0)));
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xFF3D418E),
        child: const Icon(Icons.add),
      ),
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
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),


          child: MultiSelectBottomSheetField<LeadFilter?>(
            key: _multiSelectKey,
            initialChildSize: 0.7,
            maxChildSize: 0.95,

            title: Text("Leads Category",style:
            TextStyle(fontWeight: FontWeight.w600,fontSize: 17, fontFamily: 'Mulish',),),

            buttonText: Text("Lead Filter",

              style:
            TextStyle(fontWeight: FontWeight.w500,fontSize: 14, fontFamily: 'Mulish',color: Colors.black),),
            buttonIcon:  Icon(
            //  Icons.arrow_drop_down_rounded,
              Icons.filter_list_alt,
              color: Colors.grey,
            ),

            items: _items,
            searchable: true,


           // backgroundColor:  Color(0xFFED2449),
          cancelText: Text("Cancel",style: TextStyle(color: Color(0xFF231F20),
              fontWeight: FontWeight.w700,fontSize: 13.57,
              fontFamily: 'Mulish'
          ),),
            confirmText: Text("Ok",style: TextStyle(color: Color(0xFF231F20),
            fontWeight: FontWeight.w700,fontSize: 13.57,
                fontFamily: 'Mulish'
            ),),

            onConfirm: (values) async{
              setState(() {
                print(values);
                print("drop values");
                selectedFilter = values;
                leadType = selectedFilter.join(', ');
                leadType = leadType?.replaceAll('[', '').replaceAll(']', '');

                 _pageNumber = 1;
                _LeadModels.clear();
                fetchData();

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
                  fetchData();
                });
                _multiSelectKey.currentState?.validate();
              },
            ),
          ),





        ),
        Expanded(
          child: ListView.builder(
              itemCount: _LeadModels.length + (_isLastPage ? 0 : 1),

              itemBuilder: (context, index) {
                // request more data when the user has reached the trigger point.
                print(_LeadModels.length + (_isLastPage ? 0 : 1),);
                print("_isLastPage");
               print(_LeadModels.length);
               print(_nextPageTrigger);
               print(_LeadModels.length - _nextPageTrigger);
               print(index);
               print("data checksssss lead");





                if (index == _LeadModels.length - _nextPageTrigger) {

                  fetchData();
                }
                // when the user gets to the last item in the list, check whether
                // there is an error, otherwise, render a progress indicator.
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
}
Future getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('personName')??"";
  print(stringValue);
  print("Stringvalueeeee");
  return stringValue;
}


