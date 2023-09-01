import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import '../commoncustomer.dart';
import '../customercreation.dart';
import '../drawer.dart';
import '../globals.dart' as globals;

import '../api.dart';
import '../model/customermodel.dart';
import '../quotationcreation.dart';

class CustomerScrolling extends StatefulWidget {


  @override
  State<CustomerScrolling> createState() => _CustomerScrollingState();
}

class _CustomerScrollingState extends State<CustomerScrolling> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<CustomerModel> _CustomerModel;
  final int _nextPageTrigger = 3;
  String? token,leadType;
  int? quotationType;

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
    fetchData();
  }


  Future<void> fetchData() async {
    token = await getUserJwt();
    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);


    try {

      final response = await get(Uri.parse(


      "${baseUrl}api/contacts?count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word=&company_ids=${globals.selectedIds}"),

        headers: {

          'Authorization': 'Bearer $token',

        },
      );

      var responseList = jsonDecode(response.body);
      print("company_ids");
      print(globals.selectedIds);
      print(responseList['records']);
      print("company_ids");

      List customerModelList= responseList['records'];
      if(customerModelList.isEmpty){
        print("vishnu");


      }
      else{



        List<CustomerModel> customerModelList = (responseList['records'] as List<dynamic>).map<CustomerModel>((data) => CustomerModel(data['id'],
            data['display_name']??"",data['function']??"",data['city']??"",data['country_id'].length!=0?data['country_id'][1]??"":"",data['email']??"",(data['meeting_count']??"").toString(),(data['opportunity_count']??"").toString(),data['image_1920']??"",data['parent_id'].length!=0?data['parent_id'][1]??"":"")).toList();


        setState(() {
          _isLastPage = customerModelList.length < _numberOfLeadModelsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          print(_pageNumber);
          print("_pageNumber");
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0,
        title: Row(
          children: [
            Text("Customers", style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.white,
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
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(icon: SvgPicture.asset("images/messages.svg"),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(icon: SvgPicture.asset("images/clock2.svg"),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
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
      // appBar: AppBar(title: const Text("Blog App"), centerTitle: true,),
      body: buildLeadModelsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerCreation(0)));
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xFF3D418E),
        child: const Icon(Icons.add),
      ),
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
    }
    return ListView.builder(
        itemCount: _CustomerModel.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {

          // request more data when the user has reached the trigger point.
          if (index == _CustomerModel.length - _nextPageTrigger) {
            fetchData();
          }
          // when the user gets to the last item in the list, check whether
          // there is an error, otherwise, render a progress indicator.
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



        });
  }


}

