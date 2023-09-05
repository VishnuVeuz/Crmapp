import 'dart:convert';

import 'package:crm_project/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';

import '../activities.dart';
import '../commonquotation.dart';
import '../globals.dart' as globals;
import '../api.dart';

import '../model/quotationmodel.dart';
import '../notification.dart';
import '../quotationcreation.dart';


class QuotationScrolling extends StatefulWidget {


  @override
  State<QuotationScrolling> createState() => _QuotationScrollingState();
}

class _QuotationScrollingState extends State<QuotationScrolling> {
  late bool _isLastPage;
  late int _pageNumber;
  late bool _error;
  late bool _loading;
  final int _numberOfLeadModelsPerRequest = 10;
  late List<QuotationModel> _QuotationModel;
  final int _nextPageTrigger = 3;
  String? token,leadType;
  int? quotationType;

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
    fetchData();
  }


  Future<void> fetchData() async {
    token = await getUserJwt();
    print(token);
    print(_numberOfLeadModelsPerRequest);
    print(_pageNumber);
    try {

      final response = await get(Uri.parse(

          "${baseUrl}api/quotations?company_ids=${globals.selectedIds}&count=${_numberOfLeadModelsPerRequest}&page_no=${_pageNumber}&key_word="),

        headers: {

          'Authorization': 'Bearer $token',

        },
      );
      //"https://jsonplaceholder.typicode.com/LeadModels?_page=$_pageNumber&_limit=$_numberOfLeadModelsPerRequest"));
      //List responseList = json.decode(response.body);
      var responseList = jsonDecode(response.body);
      print("company_ids");
      print(globals.selectedIds);
      print(responseList['records']);
      print("company_ids");

      List quotationModelList= responseList['records'];
      if(quotationModelList.isEmpty){
        print("vishnu");


      }
      else{
        List<QuotationModel> quotationModelList = (responseList['records'] as List<dynamic>).map<QuotationModel>((data) => QuotationModel(data['id']??"",data['partner_id'].length!=0?data['partner_id'][1]??"":"",data['amount_total']??"",data['name']??"",data['date_order']??"",data['state']??"")).toList();


        setState(() {
          _isLastPage = quotationModelList.length < _numberOfLeadModelsPerRequest;
          _loading = false;
          _pageNumber = _pageNumber + 1;
          print(_pageNumber);
          print("_pageNumber");
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
            Text("Quotations", style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
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
                                        Activities()));
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
                  builder: (context) => QuotationCreation(0)));
          // Add your onPressed code here!
        },
        backgroundColor: Color(0xFF3D418E),
        child: const Icon(Icons.add),
      ),
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
    }
    return ListView.builder(
        itemCount: _QuotationModel.length + (_isLastPage ? 0 : 1),
        itemBuilder: (context, index) {

          // request more data when the user has reached the trigger point.
          if (index == _QuotationModel.length - _nextPageTrigger) {
            fetchData();
          }
          // when the user gets to the last item in the list, check whether
          // there is an error, otherwise, render a progress indicator.
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



        });
  }


}


