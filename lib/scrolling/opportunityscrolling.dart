import 'dart:convert';

import 'package:crm_project/bottomnavigation.dart';
import 'package:crm_project/opportunitymainpage.dart';
import 'package:crm_project/scrolling/scrollpagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import '../api.dart';
import '../commonopportunity.dart';
import '../drawer.dart';
import '../globals.dart' as globals;
import '../model/opportunitymodel.dart';
import '../opportunitycreation.dart';


class OpportunityScrolling extends StatefulWidget {
  final dynamic type,Id,similartype;
  var quotationFrom;
  var filterItems;
  String fromCustomer;


  OpportunityScrolling(this.type,this.Id,this.similartype,this.quotationFrom,this.filterItems,this.fromCustomer);

  @override
  State<OpportunityScrolling> createState() => _OpportunityScrollingState();
}

class _OpportunityScrollingState extends State<OpportunityScrolling> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _error1;
  late bool _nodata;
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<OpportunityModel> _OpportunityModel;
  final int _nextPageTrigger = 3;
  String? token,leadType;
  String searchText="";
  int? opportunityType;
  bool isSearching = false;
  bool searchBanner = true,searchoption= false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageNumber = 1;
    _OpportunityModel = [];
    _isLastPage = false;
    _loading = true;
    _nodata = false;
    _error = false;
    print("sfgdds");
    print(widget.type);
    print(widget.Id);
    print(widget.similartype);
    print(widget.quotationFrom);
    print(widget.filterItems);

    print("sfgdds11");
    opportunityType = widget.type;
    fetchData("");
  }


  Future<void> fetchData(data) async {
    token = await getUserJwt();
    String baseUrl= await getUrlString();
    String dataa;

    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);
    try {

      if (searchText.isEmpty) {

        widget.quotationFrom == "notification" ?
        dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&&filters=${widget.filterItems}":

        widget.quotationFrom == "lost" ?
        dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&&filters=${widget.filterItems}":



        widget.similartype=="similar"? dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&opportunity_id=${widget.Id}"
            : dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}${widget.Id==null?"&partner_id=":"&partner_id=${widget.Id}"}";

      }
      else{

        widget.quotationFrom == "notification" ?
        dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&&filters=${widget.filterItems}":

        widget.quotationFrom == "lost" ?
        dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&&filters=${widget.filterItems}":



        widget.similartype=="similar"? dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&opportunity_id=${widget.Id}"
            : dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=${searchText}&company_ids=${globals.selectedIds}&stage_id=${opportunityType}${widget.Id==null?"&partner_id=":"&partner_id=${widget.Id}"}";

      }


      print(dataa);

      print("demo datatatta");

      final response = await get(Uri.parse(dataa),
        headers: {

          'Authorization': 'Bearer $token',

        },
      );

      var responseList = jsonDecode(response.body);
      print(dataa);
      print("company_ids");
      print(globals.selectedIds);
      print(responseList['records']);
      print("company_ids");

    List opportunityModelList= responseList['records'];


    if(opportunityModelList.isEmpty){
      print("vishnuscrolling");
      _nodata = true;

      setState(() {
        _loading = false;
        _error1 = true;
      });



    }
    else{
      List<OpportunityModel> opportunityModelList = (responseList['records'] as List<dynamic>).map<OpportunityModel>((data) => OpportunityModel(data['id']??"",data['name']??"",data['name']??"",data['priority']??"",data['tag_ids']??"",data['image_1920']??"")).toList();


      setState(() {
        _isLastPage = opportunityModelList.length < _numberOfLeadModelsPerRequest;
        _loading = false;

        if (opportunityModelList.length < _numberOfLeadModelsPerRequest) {
          _pageNumber = 1;
        } else {

          _pageNumber = _pageNumber + 1;
        }
        if (_pageNumber == 1) {
          _OpportunityModel.clear();
        }


        _pageNumber = _pageNumber + 1;
        print(_pageNumber);
        print("_pageNumber");
        _OpportunityModel.addAll(opportunityModelList);
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

      body: buildLeadModelsView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpportunityCreation(0)));

        },
        backgroundColor: Color(0xFF043565),
        child: const Icon(Icons.add),
      ),

    );
  }

  Widget buildLeadModelsView() {
    if (_OpportunityModel.isEmpty) {


      if (_loading) {
        return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      }


      else if (_error) {
        return Center(
            child: errorDialog(size: 15)
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
                  padding: const EdgeInsets.only(left: 24),
                  child: Text("Opportunity", style: TextStyle(
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
              itemCount: _OpportunityModel.length + (_isLastPage ? 0 : 1),
              itemBuilder: (context, index) {

                // request more data when the user has reached the trigger point.

                if (searchText.isEmpty) {
                  if (index == _OpportunityModel.length - _nextPageTrigger) {
                    fetchData("");
                  }
                }
                else{
                  if (index == _OpportunityModel.length) {
                    loadMoreData();
                  }
                }


                if (index == _OpportunityModel.length) {
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

                final OpportunityModel opportunityModel = _OpportunityModel[index];

                return Padding(
                    padding: const EdgeInsets.all(0),
                    child: CommonOpportunity(opportunityModel.id,
                        opportunityModel.name, opportunityModel.contactname, opportunityModel.priority,
                        opportunityModel.tags, opportunityModel.leadimg,widget.fromCustomer,widget.Id== null ?0:widget.Id)
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

