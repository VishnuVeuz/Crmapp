import 'dart:convert';

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
  int? opportunityType;

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
    fetchData();
  }


  Future<void> fetchData() async {
    token = await getUserJwt();
    String dataa;

    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);
    try {

      widget.quotationFrom == "notification" ?
      dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&&filters=${widget.filterItems}":

      widget.quotationFrom == "lost" ?
      dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&&filters=${widget.filterItems}":



      widget.similartype=="similar"? dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}&opportunity_id=${widget.Id}"
      : dataa = "${baseUrl}api/opportunity?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}&stage_id=${opportunityType}${widget.Id==null?"&partner_id=":"&partner_id=${widget.Id}"}";

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
                  fetchData();
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

      // appBar: AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: buildLeadModelsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpportunityCreation(0)));
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xFF3D418E),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildLeadModelsView() {
    if (_OpportunityModel.isEmpty) {
      print(_loading);
      print("_nodata");
    //  if(_nodata){
    //    setState(() {
    //      _loading=false;
    //    });
    //   Center(
    //       child: Text("No Data Available",style: TextStyle(fontSize: 15),)
    //   );
    // }


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
    return ListView.builder(
        itemCount: _OpportunityModel.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {

          // request more data when the user has reached the trigger point.
          if (index == _OpportunityModel.length - _nextPageTrigger) {
            fetchData();
          }
          // when the user gets to the last item in the list, check whether
          // there is an error, otherwise, render a progress indicator.
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



        });
  }


}

