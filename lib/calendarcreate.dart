import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'api.dart';
import 'calendardetail.dart';
import 'drawer.dart';
import 'globals.dart';
import 'notificationactivity.dart';

const List<String> privacylist = <String>[
  "Public",
  "Private",
  "Only internal users"
];
const List<String> showaslist = <String>[
  "Available",
  "Busy",
];

class CalendarAdd extends StatefulWidget {
  var calendarId;
  int? calendarTypeId;
  var calendarmodel;
  DateTime dateTimes;
  int? activityDataId;
  List calendarData;
  String scheduleSummary;

  CalendarAdd(this.calendarId,this.calendarTypeId,this.calendarmodel,this.dateTimes,this.activityDataId,this.calendarData,this.scheduleSummary);

  @override
  State<CalendarAdd> createState() => _CalendarAddState();
}

class _CalendarAddState extends State<CalendarAdd> {
  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  dynamic  orgnizerName,orgnizerId,companyName,companyId;

  TextEditingController meetingsubjectController = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController stopTime = TextEditingController();
  TextEditingController meeting_duration = TextEditingController();
  TextEditingController meeting_discription = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController meetingurlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  DateTime selectedDateTime = DateTime.now();
  var startTimefinal,stopTimefinal;

  List partnerName = [];
  List selctedPartnerName = [];
  List<ValueItem> editPartnerName = [];
  String? token;
  bool isCheckedAllday = false;
  bool durationVisibility = true;
  List tags = [];
  List selctedTag = [];
  List<ValueItem> editTagName = [];
  List reminders = [];
  List selctedReminders = [];
  List<ValueItem> editReminders = [];
  String privacy = "";
  String show_as = "";

  String? dropdownValue,dropdownValues,dropdowncreatevalue,dropdowncreatevalues;
  bool meetingvisibility = true,optionsvisibility = false;
  bool _isInitialized = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    //defaultvalues();
    print(widget.calendarId);
    print("calendarId");
   widget.calendarId==0 ? defaultvalues() : getCalendarDetails();

  }
  Widget build(BuildContext context) {
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
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Text(
                "New",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: 'Mulish',
                    color: Colors.white,
                    decoration: TextDecoration.none),
              )
            ],
          ),
          leading: Builder(
            builder: (context) =>
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: Image.asset("images/back.png"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            Builder(builder: (context) {
              return Row(
                children: [
                  // Container(
                  //   child: Stack(
                  //       alignment: Alignment
                  //           .center,
                  //       children: [
                  //         IconButton(icon: SvgPicture.asset("images/clock2.svg"),
                  //           onPressed: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>
                  //                         ActivitiesNotification()));
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
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                      icon: SvgPicture.asset("images/drawer.svg"),
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
        body: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 20, right: 25),
                    child: SizedBox(
                      width: 93,
                      height: 33,
                      child: ElevatedButton(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.57,
                                color: Colors.white,fontFamily: 'Mulish'),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );

                            String resmessage;
                            setState(() {
                              print("final datatatata");
                              print(partnerName);
                              print(orgnizerId);
                              print(reminders);
                              print(tags);
                              print(meetingsubjectController.text);
                              print(startTime.text);
                              print(stopTime.text);
                              print(meeting_duration.text);
                              print(locationController.text);
                              print(meetingurlController.text);
                              print(meeting_discription.text);


                              (dropdownValue == "Public")
                                  ? dropdowncreatevalue = "public"
                                  : (dropdownValue == "Private")
                                  ? dropdowncreatevalue = "private"
                                  : (dropdownValue == "Only internal users")
                                  ? dropdowncreatevalue = "confidential"
                                  : dropdownValue = "public";

                              (dropdownValues == "Available")
                                  ? dropdowncreatevalues = "free"
                                  : (dropdownValues == "Busy")
                                  ? dropdowncreatevalues = "busy"
                                  : dropdowncreatevalues = "busy";


                              print(dropdowncreatevalue);
                              print(dropdowncreatevalues);
                            });

                            //resmessage = await calendarCreate();

                            widget.calendarId == 0 ?
                            resmessage = await calendarCreate() : resmessage =
                            await calendarEdit();


                            print(resmessage);


                            int resmessagevalue = int.parse(resmessage);
                            if (resmessagevalue != 0) {
                              setState(() {
                                // isLoadingSave = false;
                              });
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CalencerFullDetail(resmessagevalue)));
                          }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9246A),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
                    child: TextFormField(
                      validator: (value) {
                        print(value);
                        print("svdsdvbfd");
                        if (value == null || value.isEmpty) {
                          return 'Please enter the Meeting Subject';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish'),
                      controller: meetingsubjectController,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                          ),

                          // border: UnderlineInputBorder(),
                          labelText: 'Meeting Subject',
                          labelStyle:
                          TextStyle(color: Colors.black, fontSize: 12,fontFamily: 'Mulish')),
                    ),
                  ),
                  SizedBox(height: 0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 5),
                    child: MultiSelectDropDown.network(

                      selectedOptions: editPartnerName
                          .map((tag) =>
                          ValueItem(label: tag.label, value: tag.value))
                          .toList(),
                      onOptionSelected: (options) {
                        print(options);
                        partnerName.clear();
                        for (var options in options) {
                          partnerName.add(options.value);
                          print('Label: ${options.label}');
                          print('Value: ${options.value}');
                          print(partnerName);
                          print('---');
                        }
                      },
                      networkConfig: NetworkConfig(


                        url: "${baseUrl}api/partners",
                        method: RequestMethod.get,
                        headers: {


                          'Authorization': 'Bearer $token',
                        },
                      ),
                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),

                      responseParser: (response) {
                        debugPrint('Response: $response');

                        final list = (response['records'] as List<
                            dynamic>).map((e) {
                          final item = e as Map<String, dynamic>;
                          return ValueItem(

                            label: item['display_name'],
                            value: item['id'].toString(),
                          );
                        }).toList();

                        return Future.value(list);
                      },
                      responseErrorBuilder: ((context, body) {
                        print(body);
                        print(token);
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('Error fetching the data'),
                        );
                      }),
                    ),
                  ),

                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 23, right: 5),
                        child: Center(

                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 2.2,
                            child: ElevatedButton(
                                child: Text(
                                  "Meeting Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.black,fontFamily: 'Mulish'),
                                ),
                                onPressed: () {
                                  setState(() {
                                    meetingvisibility = true;
                                    optionsvisibility = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFEBEBEB),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 0, right: 10),
                        child: Center(

                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 2.4,
                            child: ElevatedButton(
                                child: Text(
                                  "Options",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.black,fontFamily: 'Mulish'),
                                ),
                                onPressed: () {
                                  setState(() {

                                    optionsvisibility = true;
                                    meetingvisibility = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary:  Color(0xFFEBEBEB),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Visibility(
                    visible: meetingvisibility,
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 0, left: 25),
                              child: Text(
                                "Starting at",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                              ),
                            ),
                            InkWell(

                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 25, right: 25),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the name';
                                    }
                                    return null;
                                  },
                                  controller: startTime,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    //border: OutlineInputBorder(),
                                    hintText: "choose date & time",
                                    hintStyle: TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish')
                                  ),
                                ),
                              ),

                              onTap: () {
                                selectDateTime(context, "start");
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 25),
                              child: Text(
                                "Stopping at",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                              ),
                            ),
                            InkWell(

                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 25, right: 25),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the name';
                                    }
                                    return null;
                                  },
                                  controller: stopTime,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    //border: OutlineInputBorder(),
                                    hintText: "choose date & time",
                                    hintStyle: TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish')
                                  ),
                                ),
                              ),

                              onTap: () {
                                selectDateTime(context, "stop");
                              },
                            ),
                            Visibility(
                              visible: durationVisibility,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 0),
                                child: TextFormField(
                                  style: TextStyle(fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black,fontFamily: 'Mulish'),
                                  controller: meeting_duration,
                                  decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFAFAFAF)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFAFAFAF)),
                                      ),

                                      // border: UnderlineInputBorder(),
                                      labelText: 'Duration',
                                      labelStyle:
                                      TextStyle(fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black,fontFamily: 'Mulish')),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 0),
                                  child: Text(
                                    "All day",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Checkbox(
                                    activeColor: Color(0xFFF9246A),
                                    value: isCheckedAllday,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isCheckedAllday = value!;
                                        isCheckedAllday==true ? durationVisibility = false:
                                        durationVisibility = true;
                                      print(stopTime);
                                      print("stopTime");

                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              child: SearchChoices.single(
                                //items: items,
                                value: orgnizerName,
                                hint: Text(
                                  "Organizer",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black,fontFamily: 'Mulish'),
                                ),

                                searchHint: null,
                                autofocus: false,
                                onChanged: (value) {
                                  setState(() {
                                    print(value);
                                    print(value);
                                    print("orgnizerName");
                                    orgnizerName = value;
                                    orgnizerId = value["id"];
                                  });
                                },

                                dialogBox: false,
                                isExpanded: true,
                                menuConstraints:
                                BoxConstraints.tight(const Size.fromHeight(350)),
                                itemsPerPage: 10,
                                currentPage: currentPage,
                                selectedValueWidgetFn: (item) {
                                  return (Center(
                                      child: Container(
                                        width: 300,
                                        child: Text(
                                          item["name"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black,fontFamily: 'Mulish'),
                                        ),
                                      )));
                                },
                                futureSearchFn: (String? keyword,
                                    String? orderBy,
                                    bool? orderAsc,
                                    List<Tuple2<String, String>>? filters,
                                    int? pageNb) async {
                                  String token = await getUserJwt();


                                  Response response = await get(
                                    Uri.parse(
                                        "${baseUrl}api/organizer?page_no=${pageNb ??
                                            1}&count=10${keyword == null
                                            ? ""
                                            : "&filter=$keyword"}${companyId ==
                                            null
                                            ? "&company_ids=${null}"
                                            : "&company_ids=$selectedIds"}"),
                                    headers: {
                                      'Authorization': 'Bearer $token',
                                    },
                                  ).timeout(const Duration(
                                    seconds: 10,
                                  ));
                                  if (response.statusCode != 200) {
                                    throw Exception(
                                        "failed to get data from internet");
                                  }
                                  dynamic data = jsonDecode(response.body);
                                  int nbResults = data["length"];
                                  List<DropdownMenuItem> results =
                                  (data["records"] as List<dynamic>)
                                      .map<DropdownMenuItem>((item) =>
                                      DropdownMenuItem(
                                        value: item,
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Text(" ${item["name"]}"),
                                          ),
                                        ),
                                      ))
                                      .toList();
                                  return (Tuple2<List<DropdownMenuItem>, int>(
                                      results, nbResults));
                                },
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 0),
                              child: MultiSelectDropDown.network(
                                selectedOptions: editReminders
                                    .map((tag) =>
                                    ValueItem(label: tag.label, value: tag.value))
                                    .toList(),
                                onOptionSelected: (options) {
                                  print(options);
                                  reminders.clear();
                                  for (var options in options) {
                                    reminders.add(options.value);
                                    print('Label: ${options.label}');
                                    print('Value: ${options.value}');
                                    print(reminders);
                                    print('---');
                                  }
                                },
                                networkConfig: NetworkConfig(
                                  url: "${baseUrl}api/common_dropdowns?model=calendar.alarm",
                                  method: RequestMethod.get,
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                ),
                                chipConfig: const ChipConfig(
                                    wrapType: WrapType.wrap),
                                responseParser: (response) {
                                  debugPrint('Response: $response');

                                  final list =
                                  (response['record'] as List<dynamic>).map((e) {
                                    final item = e as Map<String, dynamic>;
                                    return ValueItem(
                                      label: item['name'],
                                      value: item['id'].toString(),
                                    );
                                  }).toList();

                                  return Future.value(list);
                                },
                                responseErrorBuilder: ((context, body) {
                                  print(body);
                                  print(token);
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('Error fetching the data'),
                                  );
                                }),
                              ),
                            ),

                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                                controller: locationController,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFAFAFAF)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFAFAFAF)),
                                    ),

                                    // border: UnderlineInputBorder(),
                                    labelText: 'Location',
                                    labelStyle:
                                    TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish')),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                                controller: meetingurlController,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFAFAFAF)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFAFAFAF)),
                                    ),

                                    // border: UnderlineInputBorder(),
                                    labelText: 'Meeting URL',
                                    labelStyle:
                                    TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish')),
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 5),
                              child: MultiSelectDropDown.network(
                                selectedOptions: editTagName
                                    .map((tag) =>
                                    ValueItem(label: tag.label, value: tag.value))
                                    .toList(),
                                onOptionSelected: (options) {
                                  print(options);
                                  tags.clear();
                                  for (var options in options) {
                                    tags.add(options.value);
                                    print('Label: ${options.label}');
                                    print('Value: ${options.value}');
                                    print(tags);
                                    print('---');
                                  }
                                },
                                networkConfig: NetworkConfig(
                                  url: "${baseUrl}api/common_dropdowns?model=calendar.event.type",
                                  method: RequestMethod.get,
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                ),
                                chipConfig: const ChipConfig(
                                    wrapType: WrapType.wrap),
                                responseParser: (response) {
                                  debugPrint('Response: $response');

                                  final list =
                                  (response['record'] as List<dynamic>).map((e) {
                                    final item = e as Map<String, dynamic>;
                                    return ValueItem(
                                      label: item['name'],
                                      value: item['id'].toString(),
                                    );
                                  }).toList();

                                  return Future.value(list);
                                },
                                responseErrorBuilder: ((context, body) {
                                  print(body);
                                  print(token);
                                  return const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text('Error fetching the data'),
                                  );
                                }),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: TextFormField(
                                style: TextStyle(fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                                controller: meeting_discription,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFAFAFAF)),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xFFAFAFAF)),
                                    ),

                                    // border: UnderlineInputBorder(),
                                    labelText: 'Description',
                                    labelStyle:
                                    TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Visibility(
                    visible: optionsvisibility,
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: SearchChoices.single(
                              hint: Text(
                                "Privacy",
                                style: TextStyle(fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                              ),
                              items: privacylist.map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish'),
                                  ),
                                );
                              }).toList(),
                              value: dropdownValue,
                              onChanged: (value) {
                                print(dropdownValue);
                                print("demo vale");
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: SearchChoices.single(
                              hint: Text(
                                "Show as",
                                style: TextStyle(fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,fontFamily: 'Mulish'),
                              ),
                              items: showaslist.map<DropdownMenuItem<String>>((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:TextStyle(fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Colors.black,fontFamily: 'Mulish'),
                                  ),
                                );
                              }).toList(),
                              value: dropdownValues,
                              onChanged: (value) {
                                setState(() {
                                  dropdownValues = value!;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),

                    ),
                  )


                ],

              ),
            ),
          ),
        ),


      );
    }

  }

  void defaultvalues() async{

    token = await getUserJwt();
    var data =  await defaultDropdownCalendar();
      setState(() {
      print(data);
      orgnizerName = data['user_id'];
      orgnizerId = data['user_id']['id']??null;
      startTime.text=data['start'].toString()??"";
      stopTime.text=data['stop'].toString()??"";
      meeting_duration.text=data['duration'].toString()??"";
      privacy = data['privacy'] ?? "";
      print(privacy);
      print("privacy");

      (privacy == "public")
          ? dropdownValue = privacylist[0]
          : (privacy == "private")
          ? dropdownValue = privacylist[1]
          : (privacy == "confidential")
          ? dropdownValue = privacylist[2]
          : dropdownValue = privacylist[0];


      print(dropdownValue);

      show_as = data['show_as'] ?? "";

      (show_as == "free")
          ? dropdownValues = showaslist.first
          : (show_as == "busy")
          ? dropdownValues = showaslist.last
          : dropdownValues = showaslist.last;

      for(int i=0;i<data['partner_ids'].length;i++)
      {
        selctedPartnerName.add(data['partner_ids'][i]);

      }

      for(int i=0;i<selctedPartnerName.length;i++){
        editPartnerName.add(new ValueItem(label: selctedPartnerName[i]['display_name'],value:selctedPartnerName[i]['id'].toString() ));

      }

      partnerName = editPartnerName.map((item) => item.value).toList();


      meetingsubjectController.text = widget.scheduleSummary;




      _isInitialized = true;

    });


    print(token);


  }
  calendarCreate() async {
    print(DateTime.parse(startTime.text));
    print("DateTime.parse");
    String value= await createCalendar(orgnizerId,partnerName,reminders,tags,meetingsubjectController.text,
        meeting_duration.text,locationController.text,meetingurlController.text,meeting_discription.text,dropdowncreatevalue,dropdowncreatevalues,startTime.text,stopTime.text,
        widget.calendarmodel,widget.calendarTypeId,widget.activityDataId
    );

    return value;
  }

  calendarEdit()async {
    String value= await editCalendar(orgnizerId,partnerName,reminders,tags,meetingsubjectController.text,
      meeting_duration.text,locationController.text,meetingurlController.text,meeting_discription.text,dropdowncreatevalue,dropdowncreatevalues,startTime.text,stopTime.text,widget.calendarId,
        widget.calendarmodel,widget.calendarTypeId,widget.activityDataId );

    print(value);
    return value;
  }

  void getCalendarDetails() async {
    token = await getUserJwt();
    var data = await getCalendarData(widget.calendarId);

    print(data);
    print("datatatatat");
    setState(() {
      meetingsubjectController.text=data['name'].toString();
      startTime.text=data['start'].toString();
      stopTime.text=data['stop'].toString();
      meeting_duration.text=data['duration'].toString();
      isCheckedAllday=data['allday']?? false;
      orgnizerName = data['user_id'] ?? "";
      orgnizerId = data['user_id'] ['id']?? null;
      locationController.text = data['location'].toString();
      meetingurlController.text = data['videocall_location'].toString();
      meeting_discription.text =data['description'].toString();

      for (int i = 0; i < data['categ_ids'].length; i++) {
        selctedTag.add(data['categ_ids'][i]);
      }

      for (int i = 0; i < selctedTag.length; i++) {
        editTagName.add(new ValueItem(
            label: selctedTag[i]['name'],
            value: selctedTag[i]['id'].toString()));
      }
      tags = editTagName.map((item) => item.value).toList();


      for (int i = 0; i < data['alarm_ids'].length; i++) {
        selctedReminders.add(data['alarm_ids'][i]);
      }

      for (int i = 0; i < selctedReminders.length; i++) {
        editReminders.add(new ValueItem(
            label: selctedReminders[i]['name'],
            value: selctedReminders[i]['id'].toString()));
      }
      reminders = editReminders.map((item) => item.value).toList();



      for (int i = 0; i < data['partner_ids'].length; i++) {
        selctedPartnerName.add(data['partner_ids'][i]);
      }

      for (int i = 0; i < selctedPartnerName.length; i++) {
        editPartnerName.add(new ValueItem(
            label: selctedPartnerName[i]['display_name'],
            value: selctedPartnerName[i]['id'].toString()));
      }
      partnerName = editPartnerName.map((item) => item.value).toList();



      privacy = data['privacy'] ?? "";
      print(privacy);
      print("privacy");

      (privacy == "public")
          ? dropdownValue = privacylist[0]
          : (privacy == "private")
          ? dropdownValue = privacylist[1]
          : (privacy == "confidential")
          ? dropdownValue = privacylist[2]
          : dropdownValue = privacylist[0];


      print(dropdownValue);

      show_as = data['show_as'] ?? "";

      (show_as == "free")
          ? dropdownValues = showaslist.first
          : (show_as == "busy")
          ? dropdownValues = showaslist.last
          : dropdownValues = showaslist.last;








      print("initial data");

      _isInitialized = true;
    });

    print(token);
  }




  Future<void> selectDateTime(BuildContext context,String valuedata) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime combinedDateTime = DateTime(
          pickedDateTime.year,
          pickedDateTime.month,
          pickedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {



          selectedDateTime = combinedDateTime;
          String formattedDate = DateFormat('yyyy-MM-dd kk:mm:ss').format(selectedDateTime);

          if(valuedata == "start"){
            startTimefinal = selectedDateTime;
            startTime.text = formattedDate.toString();
          }
          if(valuedata == "stop" ){
            stopTimefinal = selectedDateTime;
            stopTime.text = formattedDate.toString();
          }

          if((startTime.text!="" ) && (stopTime.text!="")){
            print("heth");
            meeting_duration.text = stopTimefinal.difference(startTimefinal).inHours.toString();

            print(meeting_duration.text);
            print("meeting_duration");
          }




        });
      }
    }
  }



}

