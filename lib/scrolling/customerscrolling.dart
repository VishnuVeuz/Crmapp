import 'dart:convert';

import 'package:crm_project/opportunitymainpage.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import '../bottomnavigation.dart';
import '../notificationactivity.dart';
import '../commoncustomer.dart';
import '../customercreation.dart';
import '../drawer.dart';
import '../globals.dart' as globals;

import '../api.dart';
import '../model/customermodel.dart';
import '../notification.dart';
import '../quotationcreation.dart';

class CustomerScrolling extends StatefulWidget {
  var quotationFrom;
  var filterItems;
  CustomerScrolling(this.quotationFrom,this.filterItems);


  @override
  State<CustomerScrolling> createState() => _CustomerScrollingState();
}

class _CustomerScrollingState extends State<CustomerScrolling> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _error1;
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<CustomerModel> _CustomerModel;
  final int _nextPageTrigger = 3;
  String? token,leadType;
  int? quotationType;
  String notificationCount="0";
  String messageCount="0";
  bool isSearching = false;
  String searchText="";
  bool searchBanner = true,searchoption= false;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _CustomerModel = [];
    _isLastPage = false;
    _loading = true;
    _error = false;
    print("sfgdds");
    //  quotationType = widget.type;
    fetchData("");
  }


  Future<void> fetchData(data) async {
    token = await getUserJwt();
    String baseUrl= await getUrlString();
    var notificationMessage  = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();
    String urls;
    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);
    if (searchText.isEmpty) {
      widget.quotationFrom == "notification" ?
      urls = "${baseUrl}api/contacts?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&filters=${widget.filterItems}":
      urls = "${baseUrl}api/contacts?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}";

    }

    else{

      widget.quotationFrom == "notification" ?
      urls = "${baseUrl}api/contacts?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&filters=${widget.filterItems}":
      urls = "${baseUrl}api/contacts?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}";

    }



    try {

      final response = await get(Uri.parse(urls


     // "${baseUrl}api/contacts?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}"
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

      List customerModelList= responseList['records'];
      if(customerModelList.isEmpty){
        print("vishnu");
        setState(() {
          _loading = false;
          _error1 = true;
        });

      }
      else{



        List<CustomerModel> customerModelList = (responseList['records'] as List<dynamic>).map<CustomerModel>((data) => CustomerModel(data['id'],
            data['display_name']??"",data['function']??"",data['city']??"",data['country_id'].length!=0?data['country_id'][1]??"":"",data['email']??"",(data['meeting_count']??"").toString(),(data['opportunity_count']??"").toString(),data['image_1920']??"",data['parent_id'].length!=0?data['parent_id'][1]??"":"")).toList();


        setState(() {
          _isLastPage = customerModelList.length < _numberOfLeadModelsPerRequest;
          _loading = false;

          if (customerModelList.length < _numberOfLeadModelsPerRequest) {
            _pageNumber = 1;
          } else {
            // Otherwise, increment the page number
            _pageNumber = _pageNumber + 1;
          }
          if (_pageNumber == 1) {
            _CustomerModel.clear();
          }



          _CustomerModel.addAll(customerModelList);
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
                color: Colors.black, fontFamily: 'Proxima Nova'
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
              child: const Text("Retry", style: TextStyle(fontSize: 18, color: Colors.red, fontFamily: 'Proxima Nova'),)),
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
                color: Colors.black, fontFamily: 'Proxima Nova'
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
              child: const Text("Retry", style: TextStyle(fontSize: 18, color: Colors.red, fontFamily: 'Proxima Nova'),)),
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
            Padding(
              padding: const EdgeInsets.only(left:20 ),
              child: Text("Customers", style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Proxima Nova',
                  fontSize: 20,
                  color: Colors.white,
                  decoration: TextDecoration.none),),
            )
          ],
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
      body:Container(

        child: buildLeadModelsView(),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerCreation(0)));

        },
        backgroundColor: Color(0xFF043565),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:MyBottomNavigationBar(3),

    );
  }

  Widget buildLeadModelsView() {
    if (_CustomerModel.isEmpty) {
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
          child: Container(
            height: 50,
            //color: Colors.red,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text("Customers", style:TextStyle(
                      fontFamily: 'Proxima Nova',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0xFF292929),
                      decoration: TextDecoration.none),),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 28),
                  child: InkWell(
                    child: Container(
                      width: 18,
                      height: 18,
                      child: SvgPicture.asset(
                        "images/search.svg",
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        searchoption = true;
                        searchBanner = false;
                        searchController.clear();
                        searchText="";
                      });
                    },
                  ),
                ),
              ],
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
                hintStyle: TextStyle(  fontFamily: 'Proxima Nova',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF212121),),
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
              itemCount: _CustomerModel.length + (_isLastPage ? 0 : 1),
              itemBuilder: (context, index) {

    if (searchText.isEmpty) {
      if (index == _CustomerModel.length - _nextPageTrigger) {
        loadMoreData();
      }
    }
    else{
      if (index == _CustomerModel.length) {
        loadMoreData();
      }
    }




                if (index == _CustomerModel.length) {
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

                final CustomerModel customerModel = _CustomerModel[index];

                return Padding(
                    padding: const EdgeInsets.all(0),
                    child: CustomerList(customerModel.id,customerModel.name,customerModel.jobposition,customerModel.state,customerModel.country,customerModel.email,
                        customerModel.meetingcount,customerModel.opportunitycount,customerModel.customerimage,customerModel.parentname)
                );



              }),
        ),
      ],
    );
  }

  void loadMoreData() {
    if (!isSearching) {
      fetchData("");
    }
  }


}

