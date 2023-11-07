import 'dart:convert';

import 'package:crm_project/bottomnavigation.dart';
import 'package:crm_project/drawer.dart';
import 'package:crm_project/opportunitymainpage.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import '../notificationactivity.dart';
import '../commonquotation.dart';
import '../globals.dart' as globals;
import '../api.dart';

import '../model/quotationmodel.dart';
import '../notification.dart';
import '../quotationcreation.dart';


class QuotationScrolling extends StatefulWidget {
  var quotationFrom;
  var filterItems;
  QuotationScrolling(this.quotationFrom,this.filterItems);

  @override
  State<QuotationScrolling> createState() => _QuotationScrollingState();
}

class _QuotationScrollingState extends State<QuotationScrolling> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _error1;
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<QuotationModel> _QuotationModel;
  final int _nextPageTrigger = 3;
  String? token,leadType;
  int? quotationType;
  String notificationCount="0";
  String searchText="";
  String messageCount="0";
  bool isSearching = false;


  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _QuotationModel = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    print("sfgdds");
    //  quotationType = widget.type;
    fetchData("");
  }


  Future<void> fetchData(data) async {


print("fetchData1");
    print(data);
    token = await getUserJwt();
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    String urls;

    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);

print(searchText);
if (searchText.isEmpty) {
  print("searchtext1");

  widget.quotationFrom == "notification" ?
  urls = "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&filters=${widget.filterItems}&key_word=":

  urls = "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=";

}
else{
  print("searchtext2");
  widget.quotationFrom == "notification" ?
  urls = "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&filters=${widget.filterItems}&key_word=${searchText}":

  urls = "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}";

}




    try {

      final response = await get(Uri.parse(
          urls
         // "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word="
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
      print("company_ids");

      List quotationModelList= responseList['records'];
      if(quotationModelList.isEmpty){
        print("vishnu");

        setState(() {
          _loading = false;
          _error1 = true;
         // _QuotationModel.clear();
        });


      }
      else{
        List<QuotationModel> quotationModelList = (responseList['records'] as List<dynamic>).map<QuotationModel>((data) => QuotationModel(data['id']??"",data['partner_id'].length!=0?data['partner_id'][1]??"":"",data['amount_total']??"",data['name']??"",data['date_order']??"",data['state']??"")).toList();


        setState(() {
          _isLastPage = quotationModelList.length < _numberOfLeadModelsPerRequest;
          _loading = false;

          if (quotationModelList.length < _numberOfLeadModelsPerRequest) {
            // If the result length is less than 10, set page number to 1
            _pageNumber = 1;
          } else {
            // Otherwise, increment the page number
            _pageNumber = _pageNumber + 1;
          }
          if (_pageNumber == 1) {
            _QuotationModel.clear();
          }

       // _pageNumber = _pageNumber + 1;
       //
       //    print(_pageNumber);
       //    print("_pageNumber");
       //   // _QuotationModel.clear();

          _QuotationModel.addAll(quotationModelList);
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Text("Quotations", style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFFFFFFFF),
                decoration: TextDecoration.none),)
          ],
        ),
        // leading: Builder(
        //   builder: (context) =>
        //       Padding(
        //         padding: const EdgeInsets.only(left: 20),
        //         child: IconButton(icon: Image.asset("images/back.png"),
        //           onPressed: () {
        //
        //           },
        //         ),
        //       ),
        // ),
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
                // Padding(
                //   padding: const EdgeInsets.only(right: 0),
                //   child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                //     onPressed: () {
                //       Scaffold.of(context).openDrawer();
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 15),
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
      // appBar: AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: buildLeadModelsView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QuotationCreation(0)));
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xFFFA256B),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:MyBottomNavigationBar(3),
      //bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  Widget buildLeadModelsView() {
    if (_QuotationModel.isEmpty) {
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
        // Container(
        //   width: 400,
        //   height: 50,
        //   color: Colors.red,
        //   child: TextField(
        //     decoration: InputDecoration(hintText: 'Search'),
        //     onChanged: (text) {
        //       print("demodata1");
        //       searchText = text;
        //       if (searchText.isEmpty) {
        //         // If the text is empty, show all data
        //         isSearching = false;
        //         fetchData("");
        //        // fetchData1("");
        //       } else {
        //         // If there's a search text, fetch data for that search text
        //
        //         searchForData(searchText);
        //         fetchData1(searchText);
        //       }
        //
        //
        //
        //     },
        //   ),
        // ),
        //


        Container(
          height: 50,
          //color: Colors.red,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text("Quotations", style: TextStyle(
          fontFamily: 'Mulish',
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Color(0xFF292929),
        decoration: TextDecoration.none),),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 26),
                child: InkWell(
                  child: Container(
                    width: 18,
                    height: 18,
                    child: SvgPicture.asset(
                      "images/search.svg",
                    ),
                  ),
                  onTap: (){},
                ),
              ),
            ],
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
                _pageNumber = 1; // Reset the page number when a new search is initiated
                fetchData(""); // Fetch data with the updated search query
              });// Store the search text when it's changed
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.arrow_back_ios,size: 18,color: Colors.black,),
              suffixIcon:Icon(Icons.close,size: 18,color: Colors.black,),

            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
              itemCount: _QuotationModel.length + (_isLastPage ? 0 : 1),
              itemBuilder: (context, index) {

print(index);
print(_QuotationModel.length);
print(_nextPageTrigger);
print(_QuotationModel.length - _nextPageTrigger);
print("final data demo");

                // if(searchText=="") {
                //   print("demodemo1");
                //   if (index == _QuotationModel.length - _nextPageTrigger) {
                //      fetchData("");
                //   }
                // }
                // else{
                //   print("demodemo");
                //   if (index == _QuotationModel.length ) {
                //     print("finalfinal");
                //
                //
                //     fetchData(searchText);
                //   }
                // }



    if (searchText.isEmpty) {
    if (index == _QuotationModel.length - _nextPageTrigger) {
    loadMoreData();
    }
    } else {
    if (index == _QuotationModel.length) {
    loadMoreData();
    }}

                if (index == _QuotationModel.length) {
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

                final QuotationModel quotationModel = _QuotationModel[index];


                return Padding(
                    padding: const EdgeInsets.all(0),
                    child: QuotationList(quotationModel.id,quotationModel.name,quotationModel.amount,quotationModel.quotationname,quotationModel.date,quotationModel.state)
                );



              }),
        ),
      ],
    );
  }

  Future<void> fetchData1(data) async {
    print(data);

    print("fetchData2");


    setState(() {
      _pageNumber = 1;
    });
    // Reset the page number when initiating a new search
    // _QuotationModel.clear();
    print(data);
    token = await getUserJwt();
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    String urls;

    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);


    widget.quotationFrom == "notification" ?
    urls = "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&filters=${widget.filterItems}&key_word=${data}":

    urls = "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${data}";


    try {

      final response = await get(Uri.parse(
          urls
        // "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word="
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
      print("company_idss");

      List quotationModelList= responseList['records'];
      if(quotationModelList.isEmpty){
        print("vishnu");

        setState(() {
          _loading = false;
          _error1 = true;
          _QuotationModel.clear();
        });


      }
      else{
        List<QuotationModel> quotationModelList = (responseList['records'] as List<dynamic>).map<QuotationModel>((data) => QuotationModel(data['id']??"",data['partner_id'].length!=0?data['partner_id'][1]??"":"",data['amount_total']??"",data['name']??"",data['date_order']??"",data['state']??"")).toList();


        setState(() {
          _isLastPage = quotationModelList.length < _numberOfLeadModelsPerRequest;
          _loading = false;
          // _pageNumber = _pageNumber + 1;
         _pageNumber = 1;
          print(_pageNumber);
          print("_pageNumber");
          _QuotationModel.clear();

          _QuotationModel.addAll(quotationModelList);
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

  void searchForData(String text) {
    setState(() {
      isSearching = true;
    });
    fetchData1(text);
  }

  void loadMoreData() {
    if (!isSearching) {
      fetchData("");
    }
  }
}


