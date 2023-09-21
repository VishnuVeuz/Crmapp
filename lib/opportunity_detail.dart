import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crm_project/drawer.dart';
import 'package:crm_project/opportunitycreation.dart';
import 'package:crm_project/quotation_detail.dart';
import 'package:crm_project/quotationcreation.dart';
import 'package:crm_project/scrolling/quotationopportunity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

import 'notificationactivity.dart';
import 'api.dart';
import 'calendarmainpage.dart';
import 'lognoteedit.dart';
import 'notification.dart';
import 'opportunitymainpage.dart';
import 'opportunityquotation.dart';
import 'globals.dart' as globals;

class OpportunityDetail extends StatefulWidget {
  var opportunityId;
  OpportunityDetail(this.opportunityId);

  @override
  State<OpportunityDetail> createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail> {
  // String imgNew='images/whiterectangle.png',
  //     imgQualified='images/whiterectangle.png',
  //     imgProposition='images/whiterectangle.png',
  //     imgWon='images/whiterectangle.png';
  //
  // Color colorNew = Colors.black,
  //     colorQualified = Colors.black,
  //     colorProposition = Colors.black,
  //     colorWon = Colors.black;

  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  dynamic lostreasonName, lostreasonId;
  String notificationCount = "0";
  String? opportunityname,
      customername,
      email,
      phone,
      mobile,
      salesperson,
      salesperImg,
      priority,
      tag,
      company,
      createdby,
      createdon,
      lastupdateby,
      lastupdateon,
      internalnotes,
      attachmentCount = "0",
      followerCount = "0";

  bool followerStatus = false;

  int meeting_count = 0, quotation_count = 0, similar_opportunity = 0;

  bool? opportunityType, opportunityTypeWon;
  int? opportunityStageId;
  List opportunityStageTypes = [];
  int? stageColorIndex;
  late int opportunitylostId;
  bool _isInitialized = false;
  bool isLoading = true;
  String? token;
  List? recipient = [];
  List? tags = [];
  List orderLineProducts = [];
  List selctedRecipient = [];
  List<ValueItem> editRecipientName = [];

  Map<String, dynamic>? orderLineProductsData;

  dynamic activityTypeName,
      activityTypeId,
      assignedToname,
      assignedToid,
      activityTypeNameCategory,
      btntext = "Schedule";
  TextEditingController summaryController = TextEditingController();
  TextEditingController commandsController = TextEditingController();
  TextEditingController DuedateTime = TextEditingController();

  TextEditingController feedbackController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController subject2Controller = TextEditingController();

  bool smsVisible = true;
  bool isCheckedEmail = false;
  bool isCheckedFollowers = false;
  bool isCheckedMail = false;

  dynamic templateName, templateId;

  bool scheduleBtn = true, opencalendarBtn = false, meetingColum = true;

  DateTime? _selectedDate;
  var DuedateTimeFinal;

  bool scheduleView = false,
      scheduleActivityVisibility = true,
      scheduleVisibiltyOverdue = false,
      scheduleVisibiltyToday = false,
      scheduleVisibiltyPlanned = false,
      attachmentVisibility = false,
      smartbuttonVisible = true,
      starImage = false,
      lognoteoptions = true,
      followersVisibility = false;

  List sendMailData = [];

  String? scheduleDays,
      scheduleactivityType,
      scheduleSummary,
      scheduleUser,
      scheduleCreateDate,
      scheduleCreateUser,
      scheduleDueon,
      scheduleNotes,
      scheduleBtn1,
      scheduleBtn2,
      scheduleBtn3;

  int? scheduleLength = 0, scheduleOverdue, scheduleToday, schedulePlanned;
  var scheduleData;

  Icon scheduleIcon = Icon(
    Icons.circle,
    color: Colors.white,
    size: 8,
  );
  Icon logNoteIcon = Icon(
    Icons.circle,
    color: Colors.red,
    size: 8,
  );

  // lognote

  TextEditingController lognoteController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];
  List<dynamic> selectedImagesDisplay = [];
  List<dynamic> attachmentImagesDisplay = [];
  String imagepath = "";
  String personImg = "";
  List base64string1 = [];
  List<Map<String, dynamic>> myData1 = [];
  String base64string = "";
  int lognoteDatalength = 0;

  Map<String, dynamic>? lognoteData;
  List logDataHeader = [];
  List logDataTitle = [];
  List ddd2 = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.opportunityId);
    print("leadId");
    getOpportunityDetails();
  }

  String? tokens;
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Show a loading indicator or any other placeholder widget while waiting for initialization
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: Text(
                  opportunityname!,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
              )
            ],
          ),
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(left: 20),
              child: IconButton(
                icon: Image.asset("images/back.png"),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return OpportunityMainPage(null,"","","","");
                      },
                        settings: RouteSettings(name: 'OpportunityMainPage',),
                      ));
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
                    child: Stack(alignment: Alignment.center, children: [
                      IconButton(
                        icon: SvgPicture.asset("images/clock2.svg"),
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
                            shape: BoxShape.circle,
                            color: Color(0xFFFA256B),
                          ),
                          child: Center(
                              child: Text(
                            notificationCount,
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          )),
                        ),
                      ),
                    ]),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(right: 0),
                  //   child: IconButton(icon: SvgPicture.asset("images/searchicon.svg"),
                  //     onPressed: () {
                  //
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
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
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OpportunityMainPage(null, "", "", "", "")));
            return true;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OpportunityCreation(0)));
                              },
                              child: SvgPicture.asset(
                                "images/create.svg",
                                width: 28,
                                height: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Create",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OpportunityCreation(
                                                widget.opportunityId)));
                              },
                              child: SvgPicture.asset(
                                "images/edit.svg",
                                width: 28,
                                height: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Edit",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OpportunityQuotation(
                                              widget.opportunityId)),
                                );
                              },
                              child: SvgPicture.asset(
                                "images/convert.svg",
                                width: 28,
                                height: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Convert",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                print(widget.opportunityId);
                                var data = await deleteOpportunityData(
                                    widget.opportunityId);

                                if (data['message'] == "Success") {
                                  print(data);

                                  print("responcedata");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OpportunityMainPage(
                                                null, "", "", "", "")),
                                  );
                                }
                              },
                              child: SvgPicture.asset(
                                "images/delete.svg",
                                width: 28,
                                height: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("Delete",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 70,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      var data =
                                                          await getOpportunityData(
                                                              widget
                                                                  .opportunityId,
                                                              "duplicate");
                                                      String resMessageText;

                                                      if (data['message']
                                                              .toString() ==
                                                          "success") {
                                                        resMessageText =
                                                            data['data']['id']
                                                                .toString();
                                                        int resmessagevalue =
                                                            int.parse(
                                                                resMessageText);
                                                        if (resmessagevalue !=
                                                            0) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    OpportunityCreation(
                                                                        resmessagevalue)),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    child: SvgPicture.asset(
                                                      "images/duplicatee.svg",
                                                      width: 28,
                                                      height: 28,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text("Duplicate",
                                                        style: TextStyle(
                                                          fontFamily: 'Mulish',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFF212121),
                                                        )),
                                                  )
                                                ],
                                              ),
                                              opportunityType == true
                                                  ? Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showDialog<String>(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                      title: const Text(
                                                                          'Lost Reason',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                'Mulish',
                                                                          )),
                                                                      content:
                                                                          Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        height: MediaQuery.of(context).size.height /
                                                                            2.8,
                                                                        //color: Colors.green,

                                                                        child: SearchChoices
                                                                            .single(
                                                                          value:
                                                                              lostreasonName,
                                                                          hint:
                                                                              Text(
                                                                            "Lost Reason",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.black,
                                                                                fontFamily: 'Mulish'),
                                                                          ),
                                                                          searchHint:
                                                                              null,
                                                                          autofocus:
                                                                              false,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              lostreasonName = value;
                                                                              lostreasonId = value["id"];
                                                                            });
                                                                          },
                                                                          dialogBox:
                                                                              false,
                                                                          isExpanded:
                                                                              true,
                                                                          menuConstraints:
                                                                              BoxConstraints.tight(const Size.fromHeight(200)),
                                                                          itemsPerPage:
                                                                              10,
                                                                          currentPage:
                                                                              currentPage,
                                                                          selectedValueWidgetFn:
                                                                              (item) {
                                                                            return (Center(
                                                                                child: Container(
                                                                              width: 300,
                                                                              child: Text(
                                                                                item["name"],
                                                                                style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Mulish'),
                                                                              ),
                                                                            )));
                                                                          },
                                                                          futureSearchFn: (String? keyword,
                                                                              String? orderBy,
                                                                              bool? orderAsc,
                                                                              List<Tuple2<String, String>>? filters,
                                                                              int? pageNb) async {
                                                                            token =
                                                                                await getUserJwt();
                                                                            Response
                                                                                response =
                                                                                await get(
                                                                              Uri.parse("${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=crm.lost.reason"),
                                                                              headers: {
                                                                                'Authorization': 'Bearer $token',
                                                                              },
                                                                            ).timeout(const Duration(
                                                                              seconds: 10,
                                                                            ));

                                                                            if (response.statusCode !=
                                                                                200) {
                                                                              throw Exception("failed to get data from internet");
                                                                            }

                                                                            dynamic
                                                                                data =
                                                                                jsonDecode(response.body);

                                                                            int nbResults =
                                                                                data["length"];

                                                                            List<DropdownMenuItem> results = (data["record"] as List<dynamic>)
                                                                                .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                                                                      value: item,
                                                                                      child: SingleChildScrollView(
                                                                                        child: Card(
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(0),
                                                                                            child: Text("${item["name"]}"),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ))
                                                                                .toList();
                                                                            return (Tuple2<List<DropdownMenuItem>, int>(results,
                                                                                nbResults));
                                                                          },
                                                                        ),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 10,
                                                                              right: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                width: 130,
                                                                                height: 40,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                  color: Color(0xFFF9246A),
                                                                                ),
                                                                                child: TextButton(
                                                                                    child: const Text(
                                                                                      'Submit',
                                                                                      style: TextStyle(fontFamily: 'Mulish', color: Colors.white),
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      String resmessage = await opportunityLost("lost");
                                                                                      int resmessagevalue = int.parse(resmessage);
                                                                                      print(resmessage);
                                                                                      print("lostid");
                                                                                      if (resmessagevalue != 0) {
                                                                                        Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(builder: (context) => OpportunityDetail(resmessagevalue)),
                                                                                        );
                                                                                      }
                                                                                      ;
                                                                                    }),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 10),
                                                                                child: Container(
                                                                                  width: 130,
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    color: Colors.grey[100],
                                                                                  ),
                                                                                  child: TextButton(
                                                                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                                    child: const Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(fontFamily: 'Mulish', color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ));
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/lost.svg",
                                                            width: 28,
                                                            height: 28,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text("Lost",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Mulish',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF212121),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            String resmessage =
                                                                await opportunityWonRestore(
                                                                    "restore");
                                                            int resmessagevalue =
                                                                int.parse(
                                                                    resmessage);
                                                            if (resmessagevalue !=
                                                                0) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        OpportunityDetail(
                                                                            resmessagevalue)),
                                                              );
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/more.svg",
                                                            width: 28,
                                                            height: 28,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text("Restore",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Mulish',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF212121),
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                              Visibility(
                                                visible: opportunityType!,
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        String resmessage =
                                                            await opportunityWonRestore(
                                                                "won");
                                                        int resmessagevalue =
                                                            int.parse(
                                                                resmessage);
                                                        if (resmessagevalue !=
                                                            0) {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    OpportunityDetail(
                                                                        resmessagevalue)),
                                                          );
                                                        }
                                                      },
                                                      child: SvgPicture.asset(
                                                        "images/won.svg",
                                                        width: 28,
                                                        height: 28,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Text("Won",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Mulish',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xFF212121),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              opportunityType == true
                                                  ? Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            String resmessage =
                                                                await opportunityarchive(
                                                                    false);
                                                            int resmessagevalue =
                                                                int.parse(
                                                                    resmessage);
                                                            if (resmessagevalue !=
                                                                0) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        OpportunityDetail(
                                                                            resmessagevalue)),
                                                              );
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/more.svg",
                                                            width: 28,
                                                            height: 28,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text("Archive",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Mulish',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF212121),
                                                              )),
                                                        )
                                                      ],
                                                    )
                                                  : Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            String resmessage =
                                                                await opportunityarchive(
                                                                    true);
                                                            int resmessagevalue =
                                                                int.parse(
                                                                    resmessage);
                                                            if (resmessagevalue !=
                                                                0) {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        OpportunityDetail(
                                                                            resmessagevalue)),
                                                              );
                                                            }
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            "images/unarchivee.svg",
                                                            width: 28,
                                                            height: 28,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text(
                                                            "Unarchive",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Mulish',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xFF212121),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      var smsResponce =
                                                          await smsDataGet(
                                                              widget
                                                                  .opportunityId,
                                                              "crm.lead");

                                                      var name, phone, smsId;
                                                      bool smsCondition;
                                                      name = smsResponce[
                                                          'recipient_single_description'];
                                                      phone = smsResponce[
                                                          'recipient_single_number_itf'];
                                                      smsId = smsResponce['id'];
                                                      smsCondition =
                                                          smsResponce[
                                                              'invalid_tag'];

                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            _buildSendsmsPopupDialog(
                                                                context,
                                                                name,
                                                                phone,
                                                                smsId,
                                                                smsCondition,
                                                                ""),
                                                      ).then((value) =>
                                                          setState(() {}));
                                                    },
                                                    child: SvgPicture.asset(
                                                      "images/sendsmss.svg",
                                                      width: 28,
                                                      height: 28,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Text("Send SMS",
                                                        style: TextStyle(
                                                          fontFamily: 'Mulish',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color:
                                                              Color(0xFF212121),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: SvgPicture.asset(
                                "images/moree.svg",
                                width: 28,
                                height: 28,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text("More",
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 39,
                      color: Color(0xFFF5F5F5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            child: Container(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: IconButton(
                                      icon: Image.asset("images/calendar.png"),
                                      onPressed: () {
                                        if (meeting_count >= 0) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Calender(
                                                          null,
                                                          "",
                                                          DateTime.now(),
                                                          null,
                                                          [],
                                                          "")));
                                        }
                                      },
                                    ),
                                  ),
                                  Center(
                                      child: Text(
                                    "Meeting",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 10,
                                        color: Color(0xFF212121)),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      meeting_count.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: Color(0xFFED2449)),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (meeting_count >= 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Calender(null, "",
                                            DateTime.now(), null, [], "")));
                              }
                            },
                          ),
                          InkWell(
                            child: Container(
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Image.asset("images/edit.png"),
                                    onPressed: () async {
                                      if (quotation_count == 1) {
                                        int datas =
                                            await singleQuatationOpprtunity(
                                                widget.opportunityId);

                                        print(datas);
                                        print("opportunitydinallalq");

                                        if (datas != 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    QuotationDetail(datas)),
                                          );
                                        }
                                      }

                                      if (quotation_count > 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QuotationScrollingopportunity(
                                                      widget.opportunityId)),
                                        );
                                      }
                                    },
                                  ),
                                  Center(
                                      child: Text(
                                    "Quotations",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Mulish',
                                        fontSize: 10,
                                        color: Color(0xFF212121)),
                                  )),
                                  Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      quotation_count.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                          color: Color(0xFFED2449)),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            onTap: () async {
                              if (quotation_count == 1) {
                                int datas = await singleQuatationOpprtunity(
                                    widget.opportunityId);

                                print(datas);
                                print("opportunitydinallalq");

                                if (datas != 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            QuotationDetail(datas)),
                                  );
                                }
                              }

                              if (quotation_count > 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuotationScrollingopportunity(
                                              widget.opportunityId)),
                                );
                              }
                            },
                          ),
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Image.asset("images/star4.png"),
                                      onPressed: () {
                                        if (similar_opportunity > 0) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpportunityMainPage(
                                                          widget.opportunityId,
                                                          "similar",
                                                          "",
                                                          "",
                                                          "")));
                                        }
                                      },
                                    ),
                                    Center(
                                        child: Text(
                                      "Similar Opportunity",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Mulish',
                                          fontSize: 10,
                                          color: Color(0xFF212121)),
                                    )),
                                    Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2,
                                      ),
                                      child: Text(
                                        similar_opportunity.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 10,
                                            color: Color(0xFFED2449)),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              if (similar_opportunity > 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OpportunityMainPage(
                                                widget.opportunityId,
                                                "similar",
                                                "",
                                                "",
                                                "")));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),

                  Visibility(
                    visible: smartbuttonVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        height: 50,
                        //color: Colors.red,
                        child: ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          //shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: opportunityStageTypes.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 5, top: 10),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          stageColorIndex == index
                                              ? Image.asset(
                                                  'images/blueractangle.png')
                                              : Image.asset(
                                                  'images/whiterectangle.png'),
                                          Positioned.fill(
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: stageColorIndex ==
                                                          index
                                                      ? Text(
                                                          opportunityStageTypes[
                                                              index]['name'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Mulish',
                                                          ),
                                                        )
                                                      : Text(
                                                          opportunityStageTypes[
                                                              index]['name'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Mulish',
                                                          ),
                                                        )))
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      print(
                                          opportunityStageTypes[index]['name']);
                                      print(opportunityStageTypes[index]['id']);
                                      print(" print(opportunityStageTypes");
                                      String resmessage =
                                          await StageChangeOpportunity(
                                              opportunityStageTypes[index]
                                                  ['id']);
                                      int resmessagevalue =
                                          int.parse(resmessage);
                                      if (resmessagevalue != 0) {
                                        setState(() {
                                          stageColorIndex = index;
                                        });

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           OpportunityDetail(
                                        //               resmessagevalue)),
                                        // );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 25, right: 25),
                        child: Text(opportunityname!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              color: Colors.black,
                            )),
                      ),
                      opportunityType == true
                          ? opportunityTypeWon == true
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 25, right: 35),
                                  child: Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "Won",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontFamily: 'Mulish',
                                      ),
                                    )),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 25, right: 25),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: 'Mulish',
                                      ),
                                    )),
                                  ),
                                )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 25, right: 35),
                              child: Container(
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                    child: Text(
                                  "Lost",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'Mulish',
                                  ),
                                )),
                              ),
                            ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Customer",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            customername!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Email",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            email!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Phone",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 36),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Text(
                                  phone!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF000000)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                var smsResponce = await smsDataGet(
                                    widget.opportunityId, "crm.lead");

                                var name, phone, smsId;
                                bool smsCondition;
                                name =
                                    smsResponce['recipient_single_description'];
                                phone =
                                    smsResponce['recipient_single_number_itf'];
                                smsId = smsResponce['id'];
                                smsCondition = smsResponce['invalid_tag'];

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildSendsmsPopupDialog(context, name,
                                          phone, smsId, smsCondition, "phone"),
                                ).then((value) => setState(() {}));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mobile_friendly_rounded,
                                      size: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text("SMS"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text("Mobile",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  color: Color(0xFF666666))),
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 45),
                                child: Text(
                                  mobile!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF000000)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                var smsResponce = await smsDataGet(
                                    widget.opportunityId, "crm.lead");

                                var name, phone, smsId;
                                bool smsCondition;
                                name =
                                    smsResponce['recipient_single_description'];
                                phone =
                                    smsResponce['recipient_single_number_itf'];
                                smsId = smsResponce['id'];
                                smsCondition = smsResponce['invalid_tag'];

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildSendsmsPopupDialog(context, name,
                                          phone, smsId, smsCondition, ""),
                                ).then((value) => setState(() {}));
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mobile_friendly_rounded,
                                      size: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text("SMS"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Salesperson",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      salesperImg != ""
                          ? Padding(
                              padding: const EdgeInsets.only(left: 100),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: CircleAvatar(
                                  radius: 12,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                        "${salesperImg!}?token=${tokens}"),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 80),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        //  color: Colors.green
                                        ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: CircleAvatar(
                                  radius: 12,
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
                      Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            salesperson!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Priority",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: RatingBar.builder(
                              initialRating: double.parse(priority!),
                              // initialRating: 0.0,

                              itemSize: 19,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 3,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 10,
                              ),
                              onRatingUpdate: (double value) async{

                                int prioritydata = value.toInt();
                                String valuess =await editOppertunitypriority( prioritydata.toString(), widget.opportunityId);



                              },
                            ),
                          )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text("Tags",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF666666))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 0, top: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 20,
                      //color: Colors.pinkAccent,

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: tags!.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color:
                                      Color(int.parse(tags![index]["color"])),
                                ),
                                width: 60,
                                height: 20,
                                child: Center(
                                  child: Text(
                                    tags![index]["name"].toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 8),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Company",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            company!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Created by",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            createdby!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Created on",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            createdon!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Last Updated by",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            lastupdateby!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Last Updated on",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            lastupdateon!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 22, right: 22),
                    child: Divider(
                      color: Color(0xFFF4F4F4),
                      thickness: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text("Internal Notes",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF666666))),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            internalnotes!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF000000)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 450,
                      height: 39,
                      color: Color(0xFFF5F5F5),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, top: 13, bottom: 10),
                        child: Text("Optional Products",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF212121))),
                      ),
                    ),
                  ),

                  Container(
                    color: Colors.white70,
                    //height: MediaQuery.of(context).size.height/1.8,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderLineProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          orderLineProductsData = orderLineProducts[index];

                          return InkWell(
                              onTap: () {
                                print(orderLineProducts[index]);
                                print("orderLineProducts[index];");
                              },
                              child: Card(
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,

                                      // height: MediaQuery.of(context).size.height/10,
                                      color: Colors.white,
                                      child: Column(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            //crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                left: 22),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              4,
                                                          //color: Colors.cyan,
                                                          child: Text(
                                                            orderLineProductsData![
                                                                    'name'] ??
                                                                "",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Mulish',
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                left: 40,
                                                                right: 25),
                                                        child: Text(
                                                          "sum: ${orderLineProductsData!['price_subtotal']}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  'Mulish',
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5, left: 22),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Quantity : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Mulish',
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                        Text(
                                                          orderLineProductsData![
                                                                      "product_uom_qty"]
                                                                  .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Mulish',
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                        Text(
                                                          " " +
                                                                  orderLineProductsData![
                                                                              "product_uom"]
                                                                          [
                                                                          'name']
                                                                      .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Mulish',
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xFF787878)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 5,
                                                                left: 22,
                                                                bottom: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Unit Price :",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      'Mulish',
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFF787878)),
                                                            ),
                                                            Text(
                                                              orderLineProductsData![
                                                                          'price_unit']
                                                                      .toString() ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      'Mulish',
                                                                  fontSize: 12,
                                                                  color: Color(
                                                                      0xFF787878)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(left: 200,right: 25,bottom: 10),
                                                      //   child: Container(
                                                      //     width: 20,
                                                      //     height: 20,
                                                      //
                                                      //     child: IconButton(
                                                      //       icon: Icon(Icons.delete),
                                                      //       onPressed: () {
                                                      //         print(index);
                                                      //
                                                      //         orderLineProducts.removeAt(index);
                                                      //         setState(() {
                                                      //
                                                      //         });
                                                      //         // orderLineProductsData?.removeAt(index);
                                                      //         print(orderLineProducts[index].toString());
                                                      //         print(orderLineProducts);
                                                      //         print("datatatatatattata");
                                                      //
                                                      //       },
                                                      //
                                                      //     ),
                                                      //   ),
                                                      // )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              ));
                        }),
                  ),

                  Container(
                    color: Color(0xFFF6F6F6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 0),
                          child: Center(
                            child: TextButton(
                                child: Text(
                                  "Send Message",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      color: Color(0xFF212121)),
                                ),
                                onPressed: () async {
                                  sendMailData = await sendMailsFollowers(
                                      widget.opportunityId, "crm.lead");

                                  setState(() {
                                    followersVisibility == true
                                        ? followersVisibility = false
                                        : followersVisibility = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF6F6F6),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 0),
                          child: Center(
                            child: TextButton(
                                child: Text(
                                  "Log note",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      color: Color(0xFF212121)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    followersVisibility == false
                                        ? followersVisibility = false
                                        : followersVisibility = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF6F6F6),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          child: Center(
                            child: TextButton(
                                child: Text(
                                  "Schedule Activity",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      color: Color(0xFF212121)),
                                ),
                                onPressed: () async {
                                  await defaultScheduleValues();

                                  summaryController.text = "";
                                  commandsController.text = "";
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildOrderPopupDialog(context, 0),
                                  ).then((value) => setState(() {}));
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF6F6F6),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 15, right: 10),
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            child: IconButton(
                              icon: Image.asset("images/pin.png"),
                              onPressed: () {
                                setState(() {
                                  attachmentVisibility == true
                                      ? attachmentVisibility = false
                                      : attachmentVisibility = true;
                                });
                              },
                            ),
                          ),
                          Container(
                            width: 30,
                            child: Text(
                              attachmentCount!,
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Mulish'),
                            ),
                          ),
                          followerStatus == false
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check_sharp,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            String resMessage =
                                                await followerFollow(
                                                    widget.opportunityId,
                                                    "crm.lead");

                                            if (resMessage == "success") {
                                              setState(() {
                                                int followCount;
                                                followCount =
                                                    int.parse(followerCount!);
                                                followerStatus = true;
                                                followCount = followCount + 1;
                                                followerCount =
                                                    followCount.toString();
                                              });

                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => OpportunityDetail(widget.opportunityId)));
                                            }
                                          },
                                          child: Text(
                                            "Following",
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontFamily: 'Mulish'),
                                          )),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.red,
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            String resMessage =
                                                await followerUnFollow(
                                                    widget.opportunityId,
                                                    "crm.lead");

                                            if (resMessage == "success") {
                                              setState(() {
                                                int followCount;
                                                followCount =
                                                    int.parse(followerCount!);
                                                followerStatus = false;
                                                followCount = followCount - 1;
                                                followerCount =
                                                    followCount.toString();
                                              });

                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => OpportunityDetail(widget.opportunityId)));
                                            }
                                          },
                                          child: Text(
                                            "Unfollow",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontFamily: 'Mulish'),
                                          )),
                                    ],
                                  ),
                                ),
                          Container(
                            width: 50,
                            child: IconButton(
                              icon: SvgPicture.asset("images/user.svg"),
                              onPressed: () async {
                                List followers = await getFollowers(
                                    widget.opportunityId, "crm.lead");

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildFollowPopupDialog(
                                          context, followers),
                                ).then((value) => setState(() {}));
                              },
                            ),
                          ),
                          Container(
                            width: 30,
                            //color: Colors.green,
                            child: Text(
                              followerCount!,
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'Mulish'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // code for attchments

                  Visibility(
                    visible: attachmentVisibility,
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: getattchmentData(
                                widget.opportunityId, "crm.lead"),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {}
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  if (snapshot.data == null) {
                                    return const Center(
                                        child: Text('Something went wrong'));
                                  }
                                  if (snapshot.data.length != 0) {
                                    attachmentImagesDisplay = snapshot.data;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
                                      child: Container(
                                        //color: Colors.green,

                                        width:
                                            MediaQuery.of(context).size.width,

                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              attachmentImagesDisplay.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        child: Image.network(
                                                          "${attachmentImagesDisplay[index]['url']}?token=${token}",
                                                          height: 100,
                                                          width: 80,
                                                        ),
                                                      ),
                                                      Positioned(
                                                          left: 37,
                                                          right: 0,
                                                          bottom: 70,
                                                          top: 1,
                                                          child: Container(
                                                            width: 20,
                                                            height: 20,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Color(
                                                                    0xFFFFFFFF)),
                                                            child: IconButton(
                                                              icon: SvgPicture
                                                                  .asset(
                                                                      "images/trash.svg"),
                                                              onPressed:
                                                                  () async {
                                                                print(attachmentImagesDisplay[
                                                                        index]
                                                                    ['id']);
                                                                print(
                                                                    "idvaluevalue");
                                                                // print(
                                                                //     logDataTitle[indexx][indexs]['attachment_ids'][index]["id"]);
                                                                int lodAttachmentId =
                                                                    attachmentImagesDisplay[
                                                                            index]
                                                                        ['id'];
                                                                var data =
                                                                    await deleteLogAttachment(
                                                                        lodAttachmentId);

                                                                if (data[
                                                                        'message'] ==
                                                                    "Success") {
                                                                  print(
                                                                      "jhbdndsjbv");
                                                                  await getOpportunityDetails();
                                                                  setState(() {
                                                                    attachmentImagesDisplay
                                                                        .clear();
                                                                  });
                                                                }

                                                                // print(
                                                                //     data);
                                                                print(
                                                                    "delete testststs");
                                                              },
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }
                              }
                              return Center(
                                  child: const CircularProgressIndicator());
                            }),
                        TextButton(
                            onPressed: () {
                              myAlert("attachment");
                            },
                            child: Text(
                              "Select Attachments",
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Mulish'),
                            )),
                      ],
                    ),
                  ),
                  //

                  // code for send message
                  Container(
                    width: MediaQuery.of(context).size.width,

                    //height: MediaQuery.of(context).size.height/6,
                    // color: Colors.green,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: followersVisibility,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 78),
                            child: Container(
                              // color: Colors.red,
                              child: Row(
                                children: [
                                  Text(
                                    "To:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontSize: 11,
                                        fontFamily: 'Mulish'),
                                  ),
                                  Text(
                                    " Followers of",
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 11,
                                        fontFamily: 'Mulish'),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                      //color: Colors.green,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        opportunityname!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 11,
                                            fontFamily: 'Mulish'),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 5,),
                        Visibility(
                          visible: followersVisibility,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            //height: 100,
                            //color: Colors.red,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: sendMailData.length,

                              itemBuilder: (_, i) {
                                isCheckedMail = sendMailData[i]['selected'];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 65),
                                  child: Container(
                                    height: 13,
                                    child: Row(
                                      children: [
                                        Transform.scale(
                                          scale: 0.6,
                                          child: Checkbox(
                                            activeColor: Color(0xFFF9246A),
                                            value: isCheckedMail,
                                            onChanged: (bool? value) {
                                              print(value);
                                              print("check box issues");
                                              setState(() {
                                                isCheckedMail = value!;
                                                sendMailData[i]['selected']=value;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          sendMailData[i]['name'],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11,
                                              fontFamily: 'Mulish'),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),


                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            salesperImg != ""
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: CircleAvatar(
                                        radius: 12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          child: Image.network(
                                              "${salesperImg!}?token=${token}"),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              //  color: Colors.green
                                              ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: CircleAvatar(
                                        radius: 12,
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
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.4,
                                //height: 46,
                                decoration: BoxDecoration(
                                    color: Color(0xFFF6F6F6),
                                    border:
                                        Border.all(color: Color(0xFFEBEBEB))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      // height: 40,
                                      // color: Colors.red,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: TextField(
                                            textAlignVertical:
                                                TextAlignVertical.top,
                                            //expands: true,
                                            maxLines: null,
                                            controller: lognoteController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    "Send a message to followers",
                                                hintStyle: TextStyle(

                                                    //fontFamily: "inter",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12,
                                                    fontFamily: 'Mulish',
                                                    color: Color(0xFFAFAFAF)))),
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey[350],
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Image.asset("images/pin.png"),
                                          onPressed: () {
                                            myAlert("lognote");
                                          },
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              recipient!.clear();
                                              await defaultSendmsgvalues();

                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildSendmessagePopupDialog(
                                                        context, 0),
                                              ).then(
                                                  (value) => setState(() {}));
                                            },
                                            icon: Icon(
                                              Icons.arrow_outward_rounded,
                                              size: 18,
                                              color: Colors.grey[700],
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        selectedImages.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(left: 73),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 40,
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.only(left: 70, right: 50),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 40,
                                  child: Container(
                                    width: 40,
                                    //height: 40,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      // Avoid scrolling
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: selectedImages.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 8),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Center(
                                            child: kIsWeb
                                                ? Image.network(
                                                    selectedImages[index].path)
                                                : Image.file(
                                                    selectedImages[index]));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 80, top: 5),
                          child: SizedBox(
                            width: 73,
                            height: 28,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    "Send",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Mulish',
                                        fontSize: 10,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  for (int i = 0;
                                      i < selectedImages.length;
                                      i++) {
                                    imagepath =
                                        selectedImages[i].path.toString();
                                    File imagefile =
                                        File(imagepath); //convert Path to File
                                    Uint8List imagebytes = await imagefile
                                        .readAsBytes(); //convert to bytes
                                    base64string = base64.encode(imagebytes);

                                    // base64string1.add(
                                    //     base64string);
                                    //

                                    String dataImages =
                                        '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                                    Map<String, dynamic> jsondata =
                                        jsonDecode(dataImages);
                                    myData1.add(jsondata);
                                  }
                                  // print(myData1);
                                  // print("final datatata");

                                  bodyController.text = lognoteController.text;

                                  String resMessage;
                                  followersVisibility == false
                                      ? resMessage = await logNoteData(myData1)
                                      : resMessage =
                                          await createSendmessage(myData1);

                                  if (resMessage == "success") {
                                    setState(() {
                                      logDataHeader.clear();
                                      logDataTitle.clear();
                                      selectedImagesDisplay.clear();
                                      lognoteController.text = "";
                                      selectedImages.clear();
                                      myData1.clear();
                                      bodyController.text = "";
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFFA256A),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: Color(0xFFF6F6F6),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            // <-- TextButton
                            onPressed: () {
                              setState(() {
                                scheduleActivityVisibility == true
                                    ? scheduleActivityVisibility = false
                                    : scheduleActivityVisibility = true;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 30.0,
                              color: Colors.black54,
                            ),
                            label: Text(
                              'Planned Activities',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                              ),
                            ),
                          ),
                          Visibility(
                            visible: scheduleVisibiltyOverdue,
                            child: Container(
                              width: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                  child: Text(
                                scheduleOverdue.toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                            ),
                          ),
                          Visibility(
                            visible: scheduleVisibiltyToday,
                            child: Container(
                              width: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow,
                              ),
                              child: Center(
                                  child: Text(
                                scheduleToday.toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                            ),
                          ),
                          Visibility(
                            visible: scheduleVisibiltyPlanned,
                            child: Container(
                              width: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: Center(
                                  child: Text(
                                schedulePlanned.toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // code change for schedule activity

                  Visibility(
                    visible: scheduleActivityVisibility,
                    child: Container(
                      color: Colors.white70,
                      //height: MediaQuery.of(context).size.height/1.8,

                      child: scheduleLength == 0
                          ? Container()
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: scheduleLength,
                              itemBuilder: (BuildContext context, int index) {
                                scheduleData['records'][index]['icon'] ==
                                        "fa-envelope"
                                    ? scheduleIcon = const Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                        size: 8,
                                      )
                                    : scheduleData['records'][index]['icon'] ==
                                            "fa-phone"
                                        ? scheduleIcon = Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 8,
                                          )
                                        : scheduleData['records'][index]
                                                    ['icon'] ==
                                                "fa-users"
                                            ? scheduleIcon = Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 8,
                                              )
                                            : scheduleData['records'][index]
                                                        ['icon'] ==
                                                    "fa-file-text-o"
                                                ? scheduleIcon = Icon(
                                                    Icons.file_copy,
                                                    color: Colors.white,
                                                    size: 8,
                                                  )
                                                : scheduleData['records'][index]
                                                            ['icon'] ==
                                                        "fa-line-chart"
                                                    ? scheduleIcon = Icon(
                                                        Icons.bar_chart,
                                                        color: Colors.white,
                                                        size: 8,
                                                      )
                                                    : scheduleData['records']
                                                                    [index]
                                                                ['icon'] ==
                                                            "fa-tasks"
                                                        ? scheduleIcon = Icon(
                                                            Icons.task,
                                                            color: Colors.white,
                                                            size: 8,
                                                          )
                                                        : scheduleData['records']
                                                                        [index]
                                                                    ['icon'] ==
                                                                "fa-upload"
                                                            ? scheduleIcon =
                                                                Icon(
                                                                Icons.upload,
                                                                color: Colors
                                                                    .white,
                                                                size: 8,
                                                              )
                                                            : Icon(
                                                                Icons.circle,
                                                                color: Colors
                                                                    .white,
                                                                size: 8,
                                                              );
                                return Card(
                                  elevation: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 15,
                                                    top: 5),
                                                child: Container(
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                      CircleAvatar(
                                                        radius: 12,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          child: Image.network(
                                                              "${scheduleData['records'][index]['image']!}?token=${token}"),
                                                        ),
                                                      ),

                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: Container(
                                                          width: 10.0,
                                                          height: 10.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Color(int.parse(
                                                                scheduleData[
                                                                            'records']
                                                                        [index][
                                                                    'label_color'])),
                                                          ),
                                                          child: Center(
                                                            child: scheduleIcon,
                                                            // child: Icon(
                                                            //   Icons.image,
                                                            //   color: Colors.white,
                                                            //   size: 8,
                                                            // ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 12, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5.5,
                                                  // color: Colors.red,

                                                  child: Text(
                                                    scheduleData['records']
                                                                    [index]
                                                                ['delay_label']
                                                            .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Mulish',
                                                        color: Color(int.parse(
                                                            scheduleData[
                                                                        'records']
                                                                    [index][
                                                                'label_color']))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  // color: Colors.red,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5.5,

                                                  child: Text(
                                                    scheduleData['records']
                                                                    [index][
                                                                'activity_type_id'][1]
                                                            .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xFF212121),
                                                      fontFamily: 'Mulish',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  //color: Colors.red,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4.5,

                                                  child: Text(
                                                    scheduleData['records']
                                                                    [index]
                                                                ['user_id'][1]
                                                            .toString() ??
                                                        "",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: 'Mulish',
                                                        color:
                                                            Color(0xFF212121)),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      print(scheduleView);
                                                      print("final data ");
                                                      scheduleView == false
                                                          ? scheduleView = true
                                                          : scheduleView == true
                                                              ? scheduleView =
                                                                  false
                                                              : false;
                                                      print(scheduleView);
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    child: Container(
                                                      width: 10,
                                                      height: 15,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "i",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 60),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Visibility(
                                              visible: scheduleView,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, left: 17),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Activity type",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Mulish',
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      scheduleData['records']
                                                              [index][
                                                          'activity_type_id'][1],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Mulish',
                                                          color: Colors.grey),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      "Created",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Mulish',
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          scheduleData['records']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'create_date']
                                                                  .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Mulish',
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Container(
                                                          child: CircleAvatar(
                                                            radius: 12,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              child: Image.network(
                                                                  "${scheduleData['records'][index]['image2']!}?token=${token}"),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          scheduleData['records']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'create_uid'][1]
                                                                  .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Mulish',
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      "Assigned to",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontFamily: 'Mulish',
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          child: CircleAvatar(
                                                            radius: 12,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12),
                                                              child: Image.network(
                                                                  "${scheduleData['records'][index]['image']!}?token=${token}"),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Text(
                                                          scheduleData['records']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'user_id'][1]
                                                                  .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Mulish',
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      "Due on",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      scheduleData['records']
                                                                      [index][
                                                                  'date_deadline']
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: 'Mulish',
                                                          color: Colors.grey),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0, left: 14, right: 10),
                                              child: Container(
                                                //color: Colors.red,

                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.5,
                                                child: Text(
                                                  scheduleData['records'][index]
                                                              ['note']
                                                          .replaceAll(
                                                              RegExp(
                                                                  r'<[^>]*>|&[^;]+;'),
                                                              ' ')
                                                          .toString() ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontFamily: 'Mulish',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 7,
                                              ),
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.end,

                                                children: [
                                                  Container(
                                                    //color: Colors.red,
                                                    // height: 25,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4.3,
                                                    child: TextButton.icon(
                                                      // <-- TextButton
                                                      onPressed: () async {
                                                        int datasIds =
                                                            scheduleData[
                                                                    'records']
                                                                [index]['id'];

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              _buildMarkDoneDialog(
                                                                  context,
                                                                  datasIds),
                                                        ).then((value) =>
                                                            setState(() {}));
                                                      },
                                                      icon: Icon(
                                                        Icons.check,
                                                        size: 13.0,
                                                        color: Colors.black54,
                                                      ),
                                                      label: Text(
                                                        scheduleData['records']
                                                                        [index][
                                                                    'buttons'][0]
                                                                .toString() ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'Mulish',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF717171)),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 0,
                                                  ),
                                                  scheduleData['records'][index]
                                                              ['buttons'][1] ==
                                                          "Reschedule"
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4.3,
                                                          child:
                                                              TextButton.icon(
                                                            // <-- TextButton
                                                            onPressed:
                                                                () async {
                                                              //  int idType = scheduleData['records'][index]['id'];
                                                              //
                                                              // var data =  await editDefaultScheduleData(scheduleData['records'][index]['id']);
                                                              //
                                                              //
                                                              // String textType =  scheduleData['records'][index]['buttons'][1].toString();

                                                              DateTime
                                                                  dateTime =
                                                                  DateTime.parse(
                                                                      scheduleData['records']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'date_deadline']);

                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => Calender(
                                                                          null,
                                                                          "",
                                                                          dateTime,
                                                                          null,
                                                                          [],
                                                                          "")));
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .calendar_month,
                                                              size: 13.0,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            label: Text(
                                                              scheduleData['records']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'buttons'][1]
                                                                      .toString() ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Mulish',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xFF717171)),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              4.3,
                                                          child:
                                                              TextButton.icon(
                                                            // <-- TextButton
                                                            onPressed:
                                                                () async {
                                                              int idType =
                                                                  scheduleData[
                                                                          'records']
                                                                      [
                                                                      index]['id'];

                                                              var data = await editDefaultScheduleData(
                                                                  scheduleData[
                                                                          'records']
                                                                      [
                                                                      index]['id']);

                                                              setState(() {
                                                                activityTypeName =
                                                                    data['activity_type_id'] ??
                                                                        null;
                                                                activityTypeId =
                                                                    data['activity_type_id']
                                                                            [
                                                                            'id'] ??
                                                                        null;
                                                                activityTypeNameCategory =
                                                                    data['activity_type_id']
                                                                            [
                                                                            'category'] ??
                                                                        "";
                                                                assignedToname =
                                                                    data['user_id'] ??
                                                                        null;
                                                                assignedToid =
                                                                    data['user_id']
                                                                            [
                                                                            'id'] ??
                                                                        null;
                                                                DuedateTime
                                                                        .text =
                                                                    data['date_deadline'] ??
                                                                        "";
                                                                summaryController
                                                                        .text =
                                                                    data['summary'] ??
                                                                        "";
                                                                commandsController
                                                                    .text = data[
                                                                        'note']
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'<[^>]*>|&[^;]+;'),
                                                                        ' ')
                                                                    .toString();
                                                                // DuedateTime.text == "default" ?
                                                                if (activityTypeNameCategory ==
                                                                    "default") {
                                                                  scheduleBtn =
                                                                      true;
                                                                  opencalendarBtn =
                                                                      false;
                                                                  btntext =
                                                                      "Schedule";
                                                                  meetingColum =
                                                                      true;
                                                                } else if (activityTypeNameCategory ==
                                                                    "phonecall") {
                                                                  scheduleBtn =
                                                                      true;
                                                                  opencalendarBtn =
                                                                      true;
                                                                  btntext =
                                                                      "Save";
                                                                  meetingColum =
                                                                      true;
                                                                } else if (activityTypeNameCategory ==
                                                                    "meeting") {
                                                                  scheduleBtn =
                                                                      false;
                                                                  opencalendarBtn =
                                                                      true;
                                                                  btntext =
                                                                      "Schedule";
                                                                  meetingColum =
                                                                      false;
                                                                } else if (activityTypeNameCategory ==
                                                                    "upload_file") {
                                                                  scheduleBtn =
                                                                      true;
                                                                  opencalendarBtn =
                                                                      false;
                                                                  btntext =
                                                                      "Schedule";
                                                                  meetingColum =
                                                                      true;
                                                                }

                                                                print(
                                                                    activityTypeNameCategory);
                                                                print(
                                                                    "jhbvjbvsvj");
                                                              });

                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    _buildOrderPopupDialog(
                                                                        context,
                                                                        idType),
                                                              ).then((value) =>
                                                                  setState(
                                                                      () {}));
                                                            },
                                                            icon: Icon(
                                                              Icons.edit,
                                                              size: 13.0,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                            label: Text(
                                                              scheduleData['records']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'buttons'][1]
                                                                      .toString() ??
                                                                  "",
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontFamily:
                                                                      'Mulish',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xFF717171)),
                                                            ),
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    width: 0,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            5,
                                                    child: TextButton.icon(
                                                      // <-- TextButton
                                                      onPressed: () async {
                                                        var data =
                                                            await deleteScheduleData(
                                                                scheduleData[
                                                                        'records']
                                                                    [
                                                                    index]['id']);

                                                        if (data['message'] ==
                                                            "Success") {
                                                          print("responce");
                                                          setState(() {
                                                            getScheduleDetails();
                                                          });
                                                        }

                                                        print("demo datataaa");
                                                      },
                                                      icon: Icon(
                                                        Icons.cancel_outlined,
                                                        size: 13.0,
                                                        color: Colors.black54,
                                                      ),
                                                      label: Text(
                                                        scheduleData['records']
                                                                        [index][
                                                                    'buttons'][2]
                                                                .toString() ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'Mulish',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xFF717171)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                    ),
                  ),

                  SizedBox(
                    height: 0,
                  ),

                  FutureBuilder(
                      future: getlogNoteData(widget.opportunityId, "crm.lead"),
                      builder: (context, AsyncSnapshot snapshot) {
                        logDataHeader.clear();
                        logDataTitle.clear();
                        print(snapshot.data);
                        print("snap data final ");
                        if (snapshot.hasError) {
                          print(snapshot.hasError);
                          print("snap error");
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            if (snapshot.data == null) {
                              print("dfffdfdf");
                              //print(snapshot.data!.length);
                              return const Center(
                                  child: Text('Something went wrong'));
                            }
                            if (snapshot.data.length != 0) {
                              snapshot.data?.forEach((key, value) {
                                logDataHeader.add(key);
                                logDataTitle.add(value);

                                print(logDataHeader.length);
                                print("ddd1.length");
                              });

                              print(logDataHeader.length);
                              print(logDataTitle.length);
                              print("ddd2.length");

                              print(logDataHeader[0]);
                              print(logDataTitle[0][0]['id']);
                              print("ddd2.lengthssss");

                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: logDataHeader.length,
                                  itemBuilder:
                                      (BuildContext context, int indexx) {
                                    return Card(
                                      elevation: 1,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: Center(
                                                child: Text(
                                              logDataHeader[indexx],
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontFamily: 'Mulish',
                                              ),
                                            )),
                                          ),
                                          ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  logDataTitle[indexx].length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int indexs) {
                                                selectedImagesDisplay =
                                                    logDataTitle[indexx][indexs]
                                                        ['attachment_ids'];
                                                starImage = logDataTitle[indexx]
                                                        [indexs]['starred'] ??
                                                    false;

                                                lognoteoptions =
                                                    logDataTitle[indexx][indexs]
                                                            ['is_editable'] ??
                                                        true;

                                                logDataTitle[indexx][indexs]
                                                            ['icon'] ==
                                                        "envelope"
                                                    ? logNoteIcon = const Icon(
                                                        Icons.email,
                                                        color: Colors.red,
                                                        size: 15,
                                                      )
                                                    : logDataTitle[indexx]
                                                                    [indexs]
                                                                ['icon'] ==
                                                            "ad_units"
                                                        ? logNoteIcon = Icon(
                                                            Icons.phone,
                                                            color: Colors.red,
                                                            size: 15,
                                                          )
                                                        : logDataTitle[indexx]
                                                                        [indexs]
                                                                    ['icon'] ==
                                                                "telegram"
                                                            ? logNoteIcon =
                                                                Icon(
                                                                Icons.telegram,
                                                                color:
                                                                    Colors.red,
                                                                size: 15,
                                                              )
                                                            : Icon(
                                                                Icons.circle,
                                                                color: Colors
                                                                    .white,
                                                                size: 8,
                                                              );

                                                return Card(
                                                  elevation: 1,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        color: Colors.white70,
                                                        child: Column(
                                                          children: [
                                                            Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 210,
                                                                      right:
                                                                          50),
                                                                  child:
                                                                      Container(
                                                                    //color: Colors.cyan,
                                                                    height: 30,
                                                                    width: 82,
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  right: 0,
                                                                  //left: 20,
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        82.0,
                                                                    height:
                                                                        30.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            border: Border.all(
                                                                              color: Colors.grey,
                                                                              width: 1,
                                                                            )),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        // Container(
                                                                        //   height:
                                                                        //       25,
                                                                        //   width:
                                                                        //       25,
                                                                        //   //color: Colors.red,
                                                                        //   child:
                                                                        //       Align(
                                                                        //     alignment:
                                                                        //         Alignment.topRight,
                                                                        //     child:
                                                                        //         IconButton(
                                                                        //       icon: Icon(Icons.add_reaction_outlined, size: 15.0),
                                                                        //       onPressed: () {},
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
                                                                        StatefulBuilder(builder: (BuildContext
                                                                                context,
                                                                            StateSetter
                                                                                setState) {
                                                                          return Container(
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: starImage == true
                                                                                  ? IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.star_rate,
                                                                                        size: 15.0,
                                                                                        color: Colors.yellow[700],
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        int lodDataId = logDataTitle[indexx][indexs]['id'];

                                                                                        var data = await logStarChange(lodDataId, false);

                                                                                        if (data['result']['message'] == "success") {
                                                                                          print("startrue");
                                                                                          setState(() {
                                                                                            starImage = false;
                                                                                          });
                                                                                        }

                                                                                        print(data);
                                                                                        print(" ");
                                                                                      },
                                                                                    )
                                                                                  : IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.star_rate,
                                                                                        size: 15.0,
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        int lodDataId = logDataTitle[indexx][indexs]['id'];

                                                                                        var data = await logStarChange(lodDataId, true);

                                                                                        if (data['result']['message'] == "success") {
                                                                                          print("starfalse");
                                                                                          setState(() {
                                                                                            starImage = true;
                                                                                          });
                                                                                        }

                                                                                        print(data);
                                                                                        print("hfghavjhcvjsch2");
                                                                                      },
                                                                                    ),
                                                                            ),
                                                                          );
                                                                        }),
                                                                        Visibility(
                                                                          visible:
                                                                              lognoteoptions,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 25,
                                                                                width: 25,
                                                                                //color: Colors.red,
                                                                                child: Align(
                                                                                  alignment: Alignment.topRight,
                                                                                  child: IconButton(
                                                                                    icon: Icon(Icons.edit, size: 15.0),
                                                                                    onPressed: () {
                                                                                      int lodDataId = logDataTitle[indexx][indexs]['id'];
                                                                                      String logdata = logDataTitle[indexx][indexs]['body'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ') ?? "";
                                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LogNoteEdit(lodDataId, salesperImg!, token!, widget.opportunityId, logdata)));

                                                                                      print("emojiVisibility");
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                height: 25,
                                                                                width: 25,
                                                                                //color: Colors.red,
                                                                                child: Align(
                                                                                  alignment: Alignment.center,
                                                                                  child: IconButton(
                                                                                    icon: Icon(Icons.delete_outline_outlined, size: 15.0),
                                                                                    onPressed: () async {
                                                                                      int lodDataId = logDataTitle[indexx][indexs]['id'];
                                                                                      var data = await deleteLogData(lodDataId);

                                                                                      if (data['message'] == "Success") {
                                                                                        print("final11");
                                                                                        await getOpportunityDetails();
                                                                                        setState(() {
                                                                                          logDataHeader.clear();
                                                                                          logDataTitle.clear();
                                                                                          selectedImagesDisplay.clear();
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            ListView.builder(
                                                                scrollDirection:
                                                                    Axis
                                                                        .vertical,
                                                                physics:
                                                                    NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: 1,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return Card(
                                                                    elevation:
                                                                        0,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 20.0, right: 15),
                                                                                  child: Container(
                                                                                    //color: Colors.green,
                                                                                    child: Stack(
                                                                                      alignment: Alignment.center,
                                                                                      children: [
                                                                                        // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                                                        CircleAvatar(
                                                                                          radius: 12,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(18),
                                                                                            child: Image.network("${logDataTitle[indexx][indexs]['image']}?token=${token}"),
                                                                                          ),
                                                                                        ),
                                                                                        Positioned(
                                                                                          bottom: 0,
                                                                                          right: 0,
                                                                                          child: Container(
                                                                                            width: 10.0,
                                                                                            height: 10.0,
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Colors.green,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                      // color: Colors.green,
                                                                                      width: MediaQuery.of(context).size.width / 4.5,
                                                                                      child: Text(logDataTitle[indexx][indexs]['create_uid'][1],
                                                                                          style: TextStyle(
                                                                                            fontSize: 12,
                                                                                            color: Colors.black,
                                                                                            fontFamily: 'Mulish',
                                                                                            fontWeight: FontWeight.w600,
                                                                                          ))),
                                                                                  Container(
                                                                                      //color: Colors.green,
                                                                                      width: MediaQuery.of(context).size.width / 4.5,
                                                                                      child: Text(logDataTitle[indexx][indexs]["period"],
                                                                                          style: TextStyle(
                                                                                            fontSize: 12,
                                                                                            fontFamily: 'Mulish',
                                                                                            color: Colors.grey[700],
                                                                                          ))),
                                                                                  Container(child: logNoteIcon),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Visibility(
                                                                          visible: logDataTitle[indexx][indexs]['subject'] == ""
                                                                              ? false
                                                                              : true,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 68),
                                                                            child: Container(
                                                                                // color: Colors.green,
                                                                                width: MediaQuery.of(context).size.width / 4,
                                                                                child: Text(logDataTitle[indexx][indexs]['subject'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ') ?? "",
                                                                                    style: TextStyle(
                                                                                      fontSize: 12,
                                                                                      fontFamily: 'Mulish',
                                                                                      color: Colors.black,
                                                                                    ))),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 62),
                                                                          child: Container(
                                                                              // color: Colors.green,
                                                                              width: MediaQuery.of(context).size.width / 2,
                                                                              child: Html(
                                                                                data: logDataTitle[indexx][indexs]['body'],
                                                                                style: {
                                                                                  'p': Style(fontSize: FontSize.small),
                                                                                  // Customize the font size for <p> elements
                                                                                  // Customize the font size for <strong> elements
                                                                                },
                                                                              )),
                                                                        ),
                                                                        selectedImagesDisplay.isEmpty
                                                                            ? Padding(
                                                                                padding: const EdgeInsets.only(left: 40),
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width / 3,
                                                                                  // height: 40,
                                                                                ),
                                                                              )
                                                                            : Padding(
                                                                                padding: const EdgeInsets.only(left: 40, right: 0),
                                                                                child: Container(
                                                                                  //color: Colors.green,

                                                                                  width: MediaQuery.of(context).size.width / 1.5,
                                                                                  // height: 140,
                                                                                  child: GridView.builder(
                                                                                    shrinkWrap: true,
                                                                                    // Avoid scrolling
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    itemCount: selectedImagesDisplay.length,
                                                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                      crossAxisCount: 1,
                                                                                      mainAxisSpacing: 10.0,
                                                                                      crossAxisSpacing: 10.0,
                                                                                      childAspectRatio: 3.5,

                                                                                    ),
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      print(selectedImagesDisplay.length);
                                                                                      print(selectedImagesDisplay[index]["datas"]);
                                                                                      print("selectedImagesDisplay.length,");

                                                                                      return
                                                                                        (selectedImagesDisplay[index]["mimetype"] == "application/pdf" ||
                                                                                            selectedImagesDisplay[index]["mimetype"] == "application/msword" ||
                                                                                            selectedImagesDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" ||
                                                                                            selectedImagesDisplay[index]["mimetype"] == "application/xml" ||
                                                                                            selectedImagesDisplay[index]["mimetype"] == "application/zip")
                                                                                            ? Padding(
                                                                                          padding: const EdgeInsets.only(left: 25),
                                                                                          child: Container(
                                                                                            margin: const EdgeInsets.all(5.0),
                                                                                            //padding: const EdgeInsets.all(10.0),
                                                                                            //color: Colors.white,
                                                                                            decoration: BoxDecoration(color: Colors.grey[350], border: Border.all(color: Colors.grey)),
                                                                                            width: MediaQuery.of(context).size.width,
                                                                                            // height: MediaQuery.of(context).size.height/18,
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  children: [
                                                                                                    Padding(
                                                                                                      padding: const EdgeInsets.only(top: 10, left: 5),
                                                                                                      child: FittedBox(
                                                                                                        child: SizedBox(
                                                                                                          width: 45,
                                                                                                          height: 45,
                                                                                                          child: DecoratedBox(
                                                                                                            decoration: BoxDecoration(
                                                                                                              color:
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/pdf"?
                                                                                                              Color(0xFFEF5350):
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/msword"?
                                                                                                              Color(0xFF2196F3):
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"?
                                                                                                              Color(0xFF4CAF50):
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/xml"?
                                                                                                              Color(0xFF0277BD):
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/zip"?
                                                                                                              Color(0xFFFDD835):
                                                                                                              Color(0xFFFFFFFF),

                                                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                                            ),
                                                                                                            child: Center(
                                                                                                              child: Icon(selectedImagesDisplay[index]["mimetype"] == "application/pdf"?
                                                                                                              Icons.picture_as_pdf_sharp:selectedImagesDisplay[index]["mimetype"] == "application/msword"? Icons.article_outlined:
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"?Icons.clear:
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/xml"?Icons.code_off:
                                                                                                              selectedImagesDisplay[index]["mimetype"] == "application/zip"?Icons.folder_zip_outlined:Icons.access_time_filled_outlined,

                                                                                                                color: Colors.white,
                                                                                                                size: 25,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      width: 10,
                                                                                                    ),
                                                                                                    Column(
                                                                                                      children: [
                                                                                                        Container(
                                                                                                            width: MediaQuery.of(context).size.width / 3.8,
                                                                                                            //color: Colors.blue,
                                                                                                            child: Text(


                                                                                                              "pdf name.pdf",
                                                                                                              style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Mulish'),
                                                                                                            )),
                                                                                                        SizedBox(
                                                                                                          height: 10,
                                                                                                        ),
                                                                                                        Container(
                                                                                                            width: MediaQuery.of(context).size.width / 3.8,
                                                                                                            // color: Colors.green,
                                                                                                            child: Text(


                                                                                                              "PDF",
                                                                                                              style: TextStyle(color: Colors.blue, fontSize: 11, fontFamily: 'Mulish'),
                                                                                                            )),
                                                                                                      ],
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      width: 20,
                                                                                                    ),
                                                                                                    Column(
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          width: 30,
                                                                                                          height: 30,
                                                                                                          //color: Colors.green,
                                                                                                          child: IconButton(
                                                                                                            icon: SvgPicture.asset("images/trash.svg"),
                                                                                                            onPressed: () {},
                                                                                                          ),
                                                                                                        ),
                                                                                                        Container(
                                                                                                          width: 34,
                                                                                                          height: 20,
                                                                                                          //color: Colors.green,
                                                                                                          child: IconButton(
                                                                                                            icon: Icon(Icons.download),
                                                                                                            onPressed: () {
                                                                                                              print(index);
                                                                                                              print(selectedImagesDisplay);
                                                                                                              print(selectedImagesDisplay[index]["datas"]);
                                                                                                              print(logDataTitle[indexx][indexs]['attachment_ids'][index]["id"]);
                                                                                                              print("final print dataaa");
                                                                                                            },
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                            :

                                                                                        (selectedImagesDisplay[index]["mimetype"] == "image/jpeg" || selectedImagesDisplay[index]["mimetype"] == "image/png")?
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(left: 20),
                                                                                          child: Container(
                                                                                            child: Stack(
                                                                                              children: [
                                                                                                ClipRRect(
                                                                                                  child: Image.network(
                                                                                                    "${selectedImagesDisplay[index]["datas"]}?token=${token}",
                                                                                                    height: 100,
                                                                                                    width: 80,
                                                                                                  ),
                                                                                                ),
                                                                                                Positioned(
                                                                                                    left: 40,
                                                                                                    right: 175,
                                                                                                    bottom: 50,
                                                                                                    top: 0,
                                                                                                    child: Container(
                                                                                                      width: 20,
                                                                                                      height: 20,
                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(0xFFFFFFFF)),
                                                                                                      // color: Colors
                                                                                                      //     .grey[200],
                                                                                                      child: IconButton(
                                                                                                        icon: SvgPicture.asset("images/trash.svg"),
                                                                                                        onPressed: () async {
                                                                                                          print(logDataTitle[indexx][indexs]['attachment_ids'][index]["id"]);
                                                                                                          int lodAttachmentId = logDataTitle[indexx][indexs]['attachment_ids'][index]["id"];
                                                                                                          var data = await deleteLogAttachment(lodAttachmentId);

                                                                                                          if (data['message'] == "Success") {
                                                                                                            print("jhbdndsjbv");
                                                                                                            await getOpportunityDetails();
                                                                                                            setState(() {
                                                                                                              logDataHeader.clear();
                                                                                                              logDataTitle.clear();
                                                                                                              selectedImagesDisplay.clear();
                                                                                                            });
                                                                                                          }

                                                                                                          print(data);
                                                                                                          print("delete testststs");
                                                                                                        },
                                                                                                      ),
                                                                                                    ))
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ):
                                                                                        Container();
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }),
                                                          ],
                                                        ),
                                                        //color: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
                                    );
                                  });
                            } else {
                              return Container();
                            }
                          }
                        }
                        return Center(child: const CircularProgressIndicator());
                      }),
                ],
              ),
            ),
            //color: Colors.green,
          ),
        ),
      );
    }
  }

  getOpportunityDetails() async {
    tokens = await getUserJwt();
    notificationCount = await getNotificationCount();
    var data = await getOpportunityData(widget.opportunityId, "");

    setState(() {
      opportunityname = data['name'].toString() ?? "";
      customername = data['partner_id']['display_name'] ?? "";
      email = data['email_from'].toString() ?? "";
      phone = data['phone'].toString() ?? "";
      mobile = data['mobile'].toString() ?? "";
      salesperson = data['user_id']['name'] ?? "";
      salesperImg = data['image'] ?? "";
      priority = data['priority'].toString() ?? "";
      //tag = data['tags_id']
      company = data["partner_name"].toString() ?? "";
      createdby = data["create_uid"][1].toString() ?? "";
      createdon = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.parse(data["create_date"])) ??
          "";

      lastupdateby = data["write_uid"][1].toString() ?? "";
      lastupdateon = DateFormat('yyyy-MM-dd HH:mm:ss')
              .format(DateTime.parse(data["write_date"])) ??
          "";

      internalnotes = data['description']
              .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
              .toString() ??
          "";
      opportunityType = data['active'] ?? true;

      opportunityType == false
          ? smartbuttonVisible = false
          : smartbuttonVisible = true;

      opportunityTypeWon = data['stage_id'][0]['is_won'] ?? true;

      opportunityStageTypes = data['stages_list'] ?? "";

      opportunityStageId = data['stage_id'][0]['id'] ?? 0;

      followerCount = data["followers_count"].toString() ?? "0";

      followerStatus = data["message_is_follower"] ?? false;

      opportunityStageTypes.asMap().forEach((currentIndex, element) {
        if (element['id'] == opportunityStageId) {
          stageColorIndex = currentIndex;
          return;
        }
      });

      for (int i = 0; i < data['crm_lead_line'].length; i++) {
        orderLineProducts.add(data['crm_lead_line'][i]);
      }

      if (data["tag_ids"].length > 0) {
        //tags=snapshot.data![index]["tag_ids"][0]["name"].toString();
        tags = data["tag_ids"];
      } else {
        tags = [];
      }

      print(opportunityTypeWon);
      print(opportunityStageTypes);
      print(opportunityStageId);
      print("lelelelelel");
      attachmentCount = (data["message_attachment_count"] ?? "0").toString();

      meeting_count = data["calendar_event_count"] ?? 0;
      quotation_count = data["quotation_count"] ?? 0;
      similar_opportunity = data["duplicate_lead_count"] ?? 0;

      _isInitialized = true;
    });
    await getScheduleDetails();
  }

  opportunityLost(String action) async {
    String value =
        await lostOpportunity(widget.opportunityId, lostreasonId, action);
    return value;
  }

  opportunityWonRestore(String action) async {
    String value =
        await restoreWonOpportunity(widget.opportunityId, lostreasonId, action);
    return value;
  }

  opportunityarchive(bool action) async {
    String value =
        await archiveOpportunity(widget.opportunityId, lostreasonId, action);
    return value;
  }

  StageChangeOpportunity(int state) async {
    String value = await opportunityStageChange(state, widget.opportunityId);
    return value;
  }

  defaultScheduleValues() async {
    token = await getUserJwt();

    var data = await defaultScheduleData(widget.opportunityId, "crm.lead");
    print(data['activity_type_id']);
    print("hgchgvhjb");
    setState(() {
      activityTypeName = data['activity_type_id'] ?? null;
      activityTypeId = data['activity_type_id']['id'] ?? null;
      activityTypeNameCategory = data['activity_type_id']['category'] ?? "";
      assignedToname = data['user_id'] ?? null;
      assignedToid = data['user_id']['id'] ?? null;
      DuedateTime.text = data['date_deadline'] ?? "";

      // DuedateTime.text == "default" ?
      if (activityTypeNameCategory == "default") {
        scheduleBtn = true;
        opencalendarBtn = false;
        btntext = "Schedule";
        meetingColum = true;
      } else if (activityTypeNameCategory == "phonecall") {
        scheduleBtn = true;
        opencalendarBtn = true;
        btntext = "Save";
        meetingColum = true;
      } else if (activityTypeNameCategory == "meeting") {
        scheduleBtn = false;
        opencalendarBtn = true;
        btntext = "Schedule";
        meetingColum = false;
      } else if (activityTypeNameCategory == "upload_file") {
        scheduleBtn = true;
        opencalendarBtn = false;
        btntext = "Schedule";
        meetingColum = true;
      }

      print(activityTypeNameCategory);
      print("jhbvjbvsvj");
    });
  }

  _buildOrderPopupDialog(BuildContext context, int typeIds) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height,
          //color: Colors.green,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 260, right: 10),
                  child: IconButton(
                    icon: Image.asset(
                      "images/cross.png",
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {});

                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                  child: SearchChoices.single(
                    //items: items,

                    value: activityTypeName,
                    hint: Text(
                      "Activity Type",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF212121),
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish'),
                    ),
                    searchHint: null,
                    autofocus: false,
                    onChanged: (value) async {
                      setState(() {
                        print(value['capital']);

                        activityTypeName = value;
                        activityTypeId = value["id"];
                        activityTypeNameCategory = value["category"];

                        if (activityTypeNameCategory == "default") {
                          scheduleBtn = true;
                          opencalendarBtn = false;
                          btntext = "Schedule";
                          meetingColum = true;
                        } else if (activityTypeNameCategory == "phonecall") {
                          scheduleBtn = true;
                          opencalendarBtn = true;
                          btntext = "Save";
                          meetingColum = true;
                        } else if (activityTypeNameCategory == "meeting") {
                          scheduleBtn = false;
                          opencalendarBtn = true;
                          btntext = "Schedule";
                          meetingColum = false;
                        } else if (activityTypeNameCategory == "upload_file") {
                          scheduleBtn = true;
                          opencalendarBtn = false;
                          btntext = "Schedule";
                          meetingColum = true;
                        }

                        print(activityTypeName);
                        print(activityTypeId);
                      });
                      await productDefaultDetails();
                    },

                    dialogBox: false,
                    isExpanded: true,
                    menuConstraints:
                        BoxConstraints.tight(const Size.fromHeight(300)),
                    itemsPerPage: 10,
                    currentPage: currentPage,
                    selectedValueWidgetFn: (item) {
                      return (Center(
                          child: Container(
                        width: 300,
                        child: Text(
                          item["name"],
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Mulish'),
                        ),
                      )));
                    },
                    futureSearchFn: (String? keyword,
                        String? orderBy,
                        bool? orderAsc,
                        List<Tuple2<String, String>>? filters,
                        int? pageNb) async {
                      Response response = await get(
                        Uri.parse(
                            "${baseUrl}api/activity_type?res_model=crm.lead&page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}"),
                        headers: {
                          'Authorization': 'Bearer $token',
                        },
                      ).timeout(const Duration(
                        seconds: 10,
                      ));

                      if (response.statusCode != 200) {
                        throw Exception("failed to get data from internet");
                      }

                      dynamic data = jsonDecode(response.body);

                      int nbResults = data["length"];

                      List<DropdownMenuItem> results =
                          (data["records"] as List<dynamic>)
                              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                    value: item,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text("${item["name"]}"),
                                      ),
                                    ),
                                  ))
                              .toList();
                      return (Tuple2<List<DropdownMenuItem>, int>(
                          results, nbResults));
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF212121),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mulish'),
                    controller: summaryController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Summary',
                        labelStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Mulish')),
                  ),
                ),
                Visibility(
                  visible: meetingColum,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: SizedBox(
                          child: InkWell(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: TextField(
                                enabled: false,
                                controller: DuedateTime,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Due Date",
                                    hintStyle: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF212121),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish'))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                        child: SearchChoices.single(
                          //items: items,

                          value: assignedToname,
                          hint: Text(
                            "Assigned To",
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Mulish'),
                          ),
                          searchHint: null,
                          autofocus: false,
                          onChanged: (value) async {
                            setState(() {
                              print(value['capital']);

                              assignedToname = value;
                              assignedToid = value["id"];
                            });
                            await productDefaultDetails();
                          },

                          dialogBox: false,
                          isExpanded: true,
                          menuConstraints:
                              BoxConstraints.tight(const Size.fromHeight(300)),
                          itemsPerPage: 10,
                          currentPage: currentPage,
                          selectedValueWidgetFn: (item) {
                            return (Center(
                                child: Container(
                              width: 300,
                              child: Text(
                                item["name"],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF212121),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Mulish'),
                              ),
                            )));
                          },
                          futureSearchFn: (String? keyword,
                              String? orderBy,
                              bool? orderAsc,
                              List<Tuple2<String, String>>? filters,
                              int? pageNb) async {
                            Response response = await get(
                              Uri.parse(
                                  "${baseUrl}api/assigned_to?res_model=crm.lead&res_id=${widget.opportunityId}&page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}"),

                              // "${baseUrl}api/products?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}${companyId == null ? "" : "&company_id=$companyId"}"),
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

                            List<DropdownMenuItem> results = (data["records"]
                                    as List<dynamic>)
                                .map<DropdownMenuItem>(
                                    (item) => DropdownMenuItem(
                                          value: item,
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Text("${item["name"]}"),
                                            ),
                                          ),
                                        ))
                                .toList();
                            return (Tuple2<List<DropdownMenuItem>, int>(
                                results, nbResults));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: TextFormField(
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Mulish'),
                          controller: commandsController,
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFAFAFAF)),
                              ),
                              labelText: 'Commands',
                              labelStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF212121),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Mulish')),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: opencalendarBtn,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: SizedBox(
                        width: 316,
                        height: 38,
                        child: ElevatedButton(
                            child: Center(
                              child: Text(
                                "Open Calendar",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.57,
                                    color: Colors.white,
                                    fontFamily: 'Mulish'),
                              ),
                            ),
                            onPressed: () async {
                              String resmessage;
                              typeIds == 0
                                  ? resmessage = await activitySchedule()
                                  : resmessage =
                                      await editactivitySchedule(typeIds);

                              int resmessagevalue = int.parse(resmessage);
                              if (resmessagevalue != 0) {
                                setState(() {});

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          // Calender(0,"",DateTime.now(),[])),

                                          Calender(
                                              widget.opportunityId,
                                              "crm.lead",
                                              DateTime.now(),
                                              resmessagevalue,
                                              [],
                                              summaryController.text)),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFF9246A),
                            )),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: scheduleBtn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: SizedBox(
                            width: 146,
                            height: 38,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    btntext,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white,
                                        fontFamily: 'Mulish'),
                                  ),
                                ),
                                onPressed: () async {
                                  String resmessage;

                                  typeIds == 0
                                      ? resmessage = await activitySchedule()
                                      : resmessage =
                                          await editactivitySchedule(typeIds);
                                  //resmessage=  await activitySchedule();
                                  int resmessagevalue = int.parse(resmessage);
                                  if (resmessagevalue != 0) {
                                    await getScheduleDetails();
                                    setState(() {});

                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF9246A),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(
                          child: SizedBox(
                            width: 146,
                            height: 38,
                            child: ElevatedButton(
                                child: Center(
                                  child: Text(
                                    "Mark as Done",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.57,
                                        color: Colors.white,
                                        fontFamily: 'Mulish'),
                                  ),
                                ),
                                onPressed: () async {
                                  String resmessage;
                                  typeIds == 0
                                      ? resmessage = await markDone()
                                      : resmessage =
                                          await editMarkDone(typeIds);

                                  int resmessagevalue = int.parse(resmessage);
                                  if (resmessagevalue != 0) {
                                    await getScheduleDetails();
                                    setState(() {});

                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF9246A),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: SizedBox(
                          width: 146,
                          height: 38,
                          child: ElevatedButton(
                              child: Center(
                                child: Text(
                                  "Done & Schedule\n next",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.white,
                                      fontFamily: 'Mulish'),
                                ),
                              ),
                              onPressed: () async {
                                String resmessage;
                                typeIds == 0
                                    ? resmessage = await markDone()
                                    : resmessage = await editMarkDone(typeIds);

                                int resmessagevalue = int.parse(resmessage);
                                if (resmessagevalue != 0) {
                                  await defaultScheduleValues();

                                  setState(() {
                                    summaryController.text = "";
                                    commandsController.text = "";
                                    typeIds = 0;
                                  });
                                  //Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF9246A),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: SizedBox(
                          width: 146,
                          height: 38,
                          child: ElevatedButton(
                              child: Center(
                                child: Text(
                                  "Discard",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.white,
                                      fontFamily: 'Mulish'),
                                ),
                              ),
                              onPressed: () async {
                                await getOpportunityDetails();
                                setState(() {});
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF9246A),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildMarkDoneDialog(BuildContext context, int marktypeIds) {
    print(marktypeIds);
    print("demodemo");
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text(
          'Mark Done',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Mulish'),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Container(
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: TextField(
            controller: feedbackController,
            decoration: InputDecoration(
                //border: OutlineInputBorder(),
                hintText: 'Write Feedback',
                hintStyle: TextStyle(
                    fontSize: 12, color: Colors.black, fontFamily: 'Mulish')),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.8,
                height: 38,
                child: ElevatedButton(
                    child: Center(
                      child: Text(
                        "Done & Schedule Next",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Mulish'),
                      ),
                    ),
                    onPressed: () async {
                      String resmessage = await markDoneScheduleActivity(
                          feedbackController.text, marktypeIds);

                      int resmessagevalue = int.parse(resmessage);
                      if (resmessagevalue != 0) {
                        feedbackController.text = "";
                        Navigator.pop(context);
                        await getScheduleDetails();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildOrderPopupDialog(context, 0),
                        ).then((value) => setState(() {}));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF9246A),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 6.4,
                  height: 38,
                  child: ElevatedButton(
                      child: Center(
                        child: Text(
                          "Done",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Colors.white,
                              fontFamily: 'Mulish'),
                        ),
                      ),
                      onPressed: () async {
                        String resmessage = await markDoneScheduleActivity(
                            feedbackController.text, marktypeIds);

                        int resmessagevalue = int.parse(resmessage);
                        if (resmessagevalue != 0) {
                          feedbackController.text = "";
                          await getScheduleDetails();
                          setState(() {
                            Navigator.pop(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFF9246A),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  height: 38,
                  child: ElevatedButton(
                      child: Center(
                        child: Text(
                          "Discard",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Colors.black,
                              fontFamily: 'Mulish'),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFFFFFF),
                      )),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String expirationDate = DateFormat("yyyy-MM-dd").format(_selectedDate!);

        DuedateTimeFinal = expirationDate;
        DuedateTime.text = expirationDate;

        print(expirationDate);
        print('expiration date');
      });
    }
  }

  getScheduleDetails() async {
    var datas = await getScheduleActivityData(widget.opportunityId, "crm.lead");

    String scheduleIcpnValue;

    setState(() {
      scheduleLength = datas['length'] ?? 0;
      print(datas);
      print(scheduleLength);
      print("scheduleLength");

      scheduleData = datas;
      scheduleOverdue = datas['overdue'] ?? 0;
      scheduleToday = datas['today'] ?? 0;
      schedulePlanned = datas['planned'] ?? 0;
      // scheduleIcpnValue = datas['planned']??0

      scheduleOverdue != 0
          ? scheduleVisibiltyOverdue = true
          : scheduleVisibiltyOverdue = false;
      scheduleToday != 0
          ? scheduleVisibiltyToday = true
          : scheduleVisibiltyToday = false;

      schedulePlanned != 0
          ? scheduleVisibiltyPlanned = true
          : scheduleVisibiltyPlanned = false;

      scheduleIcon = Icon(
        Icons.add,
        color: Colors.white,
        size: 8,
      );

      _isInitialized = true;
    });

    print(scheduleLength);
    print(scheduleData);
    print("dadadadadadada");

    return scheduleData;
  }

  leadLost(bool valueType) async {
    String value = await lostLead(widget.opportunityId, valueType);

    print(value);
    print("valuesss");
    return value;
  }

  productDefaultDetails() {}

  activitySchedule() async {
    String value = await scheduleActivity(
        activityTypeId,
        assignedToid,
        widget.opportunityId,
        summaryController.text,
        DuedateTime.text,
        commandsController.text,
        "crm.lead",
        "");

    print(value);
    print("valuesss");
    return value;
  }

  editactivitySchedule(int typeIds) async {
    String value = await editScheduleActivity(
        activityTypeId,
        assignedToid,
        widget.opportunityId,
        summaryController.text,
        DuedateTime.text,
        commandsController.text,
        "crm.lead",
        "",
        typeIds);

    print(value);
    print("valuesss");
    return value;
  }

  markDone() async {
    String value = await scheduleActivity(
        activityTypeId,
        assignedToid,
        widget.opportunityId,
        summaryController.text,
        DuedateTime.text,
        commandsController.text,
        "crm.lead",
        "mark_done");

    print(value);
    print("valuesss");
    return value;
  }

  editMarkDone(int typeIds) async {
    String value = await editScheduleActivity(
        activityTypeId,
        assignedToid,
        widget.opportunityId,
        summaryController.text,
        DuedateTime.text,
        commandsController.text,
        "crm.lead",
        "mark_done",
        typeIds);

    print(value);
    print("valuesss");
    return value;
  }

  logNoteData(List myData1) async {
    String value = await logNoteCreate(
        lognoteController.text, "crm.lead", widget.opportunityId, myData1);

    print(value);
    print("valuesss");
    return value;
  }

  void myAlert(String modelType) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select',style: TextStyle(
            fontWeight: FontWeight.w600,
                fontFamily: 'Mulish',
                fontSize: 14,
                color: Colors.black)),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(

                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0XFFF9246A)),
                        // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Color(0xFF212121)))),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      modelType == "lognote"
                          ? getImages()
                          : getImagesAttachment();
                      //getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery',style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Colors.white)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                   style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all(Color(0XFFF9246A)),
          // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                       textStyle: MaterialStateProperty.all(TextStyle(
                       fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish',
                            fontSize: 14,
                          color: Color(0xFF212121)))),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      print("system 2");
                      modelType == "lognote"
                          ? getImage(ImageSource.camera)
                          : getImageAttachment(ImageSource.camera);

                      //getImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera',style: TextStyle(
                        fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    setState(() {
      isLoading = true;
    });
    print("system 1");
    // var img = await picker.pickImage(source: media));
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print("system 2");
    // var img = await picker.pickMultiImage();

    if (img != null) {
      setState(
        () {
          if (imageData.isNotEmpty) {
            print("system 3");
            for (var i = 0; i < imageData.length; i++) {
              selectedImages.add(File(imageData[i].path));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nothing is selected')));
          }
        },
      );
    }
    print(selectedImages);
    print("system 4");

    setState(() {
      isLoading = false;
    });
  }

  //
  Future getImages() async {
    final pickedFile = await picker.pickMultipleMedia(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future getImageAttachment(ImageSource media) async {
    setState(() {
      isLoading = true;
    });
    print("system 1");
    // var img = await picker.pickImage(source: media));
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print("system 2");
    if (img != null) {
      Uint8List imagebytes = await img!.readAsBytes(); //convert to bytes
      base64string = base64.encode(imagebytes);
      String dataImages =
          '{"name":"name","type":"binary","datas":"${base64string.toString()}","res_model":"crm.lead","res_id":"${widget.opportunityId}"}';

      Map<String, dynamic> jsondata = jsonDecode(dataImages);
      myData1.add(jsondata);
    }

    String attachCount = await attchmentDataCreate(myData1);
    setState(() {
      myData1.clear();
      attachmentCount = attachCount;
    });
    setState(() {
      isLoading = false;
    });
  }

  Future getImagesAttachment() async {
    final pickedFile = await picker.pickMultipleMedia(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        isLoading = true;
      },
    );

    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        Uint8List imagebytes =
            await xfilePick[i]!.readAsBytes(); //convert to bytes
        base64string = base64.encode(imagebytes);
        String dataImages =
            '{"name":"name","type":"binary","datas":"${base64string.toString()}","res_model":"crm.lead","res_id":"${widget.opportunityId}"}';

        Map<String, dynamic> jsondata = jsonDecode(dataImages);
        myData1.add(jsondata);

        //attachmentSelectedImages.add(File(xfilePick[i].path));
      }
      String attachCount = await attchmentDataCreate(myData1);
      setState(() {
        myData1.clear();
        attachmentCount = attachCount;
      });
      setState(() {
        isLoading = false;
      });
      print(myData1);
      print("listarraycheck");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
  }

  _buildSendsmsPopupDialog(BuildContext context, var name, phone, smsId,
      bool smsCondition, String type) {
    print(context);
    print(name);
    print(phone);
    print(smsId);
    print(smsCondition);
    print(type);

    nameController.text = name;
    phonenumberController.text = phone;
    smsVisible = smsCondition;

    return StatefulBuilder(builder: (context, setState) {
      // nameController.text = name;
      // phonenumberController.text = phone;

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Send SMS Text Messages",
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Mulish'),
                    ),
                    IconButton(
                      icon: Image.asset(
                        "images/cross.png",
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Visibility(
                    visible: smsVisible,
                    child: Center(
                        child: Text(
                      "Invalid phone number",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ))),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Recipients",
                  style: TextStyle(
                      color: Color(0xFF212121),
                      fontSize: 14,
                      fontFamily: 'Mulish'),
                ),
                SizedBox(
                  height: 0,
                ),
                // Text("Followers of the document and",style: TextStyle(color: Colors.black,fontSize: 12),),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 12,
                        fontFamily: 'Mulish'),
                    controller: nameController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),

                        // border: UnderlineInputBorder(),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 12,
                            fontFamily: 'Mulish')),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 12,
                        fontFamily: 'Mulish'),
                    controller: phonenumberController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),

                        // border: UnderlineInputBorder(),
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 12,
                            fontFamily: 'Mulish')),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: TextFormField(
                        style: TextStyle(
                            color: Color(0xFF212121),
                            fontSize: 12,
                            fontFamily: 'Mulish'),
                        controller: subject2Controller,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),

                            // border: UnderlineInputBorder(),
                            labelText: 'Subject',
                            labelStyle:
                                TextStyle(color: Colors.black, fontSize: 10)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 3, right: 3),
                  child: Center(
                    child: SizedBox(
                      width: 340,
                      height: 38,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Send SMS",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            print(subject2Controller.text);
                            print(phonenumberController.text);
                            print(nameController.text);
                            print(smsId);
                            print(type);
                            String resMessagee = await sendSms(
                                subject2Controller.text,
                                phonenumberController.text,
                                smsId,
                                type);

                            if (resMessagee == "success") {
                              subject2Controller.clear();
                              phonenumberController.clear();
                              nameController.clear();
                              smsId = 0;
                              type = "";

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpportunityDetail(
                                          widget.opportunityId)));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9246A),
                          )),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildFollowPopupDialog(BuildContext context, List followers) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: TextButton(
            onPressed: () async {
              var responce = await followerDefaultDataGet(
                  widget.opportunityId, "crm.lead");

              int followerId;
              var message;
              bool send_mail;

              followerId = responce['id'];
              message = responce['message'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                  .toString() ??
                  "";
              send_mail = responce['send_mail'];

              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildAddfollowersPopupDialog(
                        context, followerId, message, send_mail),
              ).then((value) => setState(() {}));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text("Add Follower",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mulish',
                      ))),
            ),
          ),
          content: Container(
            color: Color(0xFFF6F6F6),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height / 5,
            child: ListView.builder(
              itemCount: followers.length,
              itemBuilder: (_, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    followers[i]['image'] != ""
                        ? Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Container(
                              width: 30,
                              height: 25,
                              //color: Colors.green,
                              // decoration: BoxDecoration(
                              //   border: Border.all(),
                              //
                              // ),
                              child: CircleAvatar(
                                radius: 12,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.network(
                                      "${followers[i]['image']}?token=${token}"),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 15, right: 10),
                            child: Container(
                              width: 30,
                              height: 25,
                              // decoration: BoxDecoration(
                              //     border: Border.all(
                              //       //  color: Colors.green
                              //     ),
                              //
                              // ),
                              child: CircleAvatar(
                                radius: 12,
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                  // Adjust the size of the icon as per your requirements
                                  color: Colors
                                      .grey, // Adjust the color of the icon as per your requirements
                                ),
                              ),
                            ),
                          ),
                    Container(
                        width: MediaQuery.of(context).size.width / 3.5,
                        child: Text(
                          followers[i]['name'],
                          style: TextStyle(fontFamily: 'Mulish', fontSize: 12),
                        )),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              List followerSub = await followerSubscription(
                                  followers[i]['id']);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildEditfollowersPopupDialog(context,
                                        followerSub, followers[i]['id']),
                              ).then((value) => setState(() {}));
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 18,
                            )),
                        IconButton(
                            onPressed: () async {
                              print(followers[i]['id']);
                              print("ghkjdghjh");

                              // "res_model": "lead.lead",
                              //
                              // "res_id": 197,
                              //
                              // "follower_id": 1822

                              String resMessage = await unFollowing(
                                  widget.opportunityId,
                                  followers[i]['id'],
                                  "crm.lead");

                              if (resMessage == "success") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpportunityDetail(
                                            widget.opportunityId)));
                              }
                            },
                            icon: Icon(
                              Icons.close,
                              size: 18,
                            ))
                      ],
                    ),
                  ],
                );
              },
            ),
          ));
    });
  }

  _buildAddfollowersPopupDialog(
      BuildContext context, int followerId, String message, bool send_mail) {
    isCheckedEmail = send_mail;
    bodyController.text = message;

    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery
          //     .of(context)
          //    .s ize
          //     .height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Invite Follower",
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'Mulish',),
                    ),
                    IconButton(
                      icon: Image.asset(
                        "images/cross.png",
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          templateName = null;
                          templateId = null;
                          recipient!.clear();
                          bodyController.text = "";
                          subjectController.text = "";
                        });

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  "Recipients",
                  style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w600,),
                ),
                SizedBox(
                  height: 5,
                ),
                // Text("Followers of the document and",style: TextStyle(color: Colors.black,fontSize: 12),),
                // SizedBox(height: 10,),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: MultiSelectDropDown.network(
                    hint: 'Add contacts to notify...',
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w600,),

                    selectedOptions: editRecipientName
                        .map((recipient) => ValueItem(
                            label: recipient.label, value: recipient.value))
                        .toList(),
                    onOptionSelected: (options) {
                      print(options);
                      recipient!.clear();
                      for (var options in options) {
                        recipient!.add(options.value);
                        print('Label: ${options.label}');
                        print('Value: ${options.value}');
                        print(recipient);
                        print('-hgvvjb--');
                      }
                    },
                    networkConfig: NetworkConfig(
                      url:
                          "${baseUrl}api/recipients?&model=crm.lead&company_ids=${globals.selectedIds}",
                      method: RequestMethod.get,
                      headers: {
                        'Authorization': 'Bearer $token',
                      },
                    ),
                    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                    responseParser: (response) {
                      debugPrint('Response: $response');

                      final list =
                          (response['record'] as List<dynamic>).map((e) {
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
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Send Email",
                  style: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w600,),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Checkbox(
                    activeColor: Color(0xFFF9246A),
                    value: isCheckedEmail,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedEmail = value!;
                      });
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //       horizontal: 5, vertical: 5),
                //   child: TextFormField(
                //     style: TextStyle(fontSize: 12),
                //     controller: subjectController,
                //     decoration: const InputDecoration(
                //         enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                //         ),
                //         focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Color(0xFFAFAFAF)),),
                //
                //         // border: UnderlineInputBorder(),
                //         labelText: 'Subject',
                //         labelStyle: TextStyle(color: Colors.black, fontSize: 10)
                //     ),
                //   ),),
                // SizedBox(height: 5,),
                Container(
                  //color: Colors.red,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      //color: Colors.red,
                      //width: MediaQuery.of(context).size.width/4,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        expands: true,
                        maxLines: null,
                        controller: bodyController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                          hintStyle: TextStyle(color: Colors.grey,fontSize: 12,fontFamily: 'Mulish',fontWeight: FontWeight.w600,),

                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: SizedBox(
                      width: 316,
                      height: 38,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Add Followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white ,fontFamily: 'Mulish'),
                            ),
                          ),
                          onPressed: () async {
                            String resmessage = await followerCreate(
                                message, followerId, recipient, send_mail);

                            if (resmessage == "success") {
                              bodyController.clear();
                              followerId = 0;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpportunityDetail(
                                          widget.opportunityId)));
                            }

                            print(recipient);
                            print("tagattagagaga");
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9246A),
                          )),
                    ),
                  ),
                ),
                // SizedBox(width: 15,),
                // Padding(
                //   padding: const EdgeInsets.only(top: 40),
                //   child: Center(
                //     child: SizedBox(
                //       width: 146,
                //       height: 38,
                //       child: ElevatedButton(
                //           child: Center(
                //             child: Text(
                //               "Cancel",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 13.57,
                //                   color: Colors.black),
                //             ),
                //           ),
                //           onPressed: () {},
                //           style: ElevatedButton.styleFrom(
                //             primary: Colors.white,
                //           )),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildEditfollowersPopupDialog(
      BuildContext context, List followerSub, int followerId) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          // width: MediaQuery
          //     .of(context)
          //     .size
          //     .width,
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Edit Subscription of",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Mulish',
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          " Follower name",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Mulish',
                              color: Color(0xFF212121),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Image.asset(
                        "images/cross.png",
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {});

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Divider(
                  color: Color(0xFFF4F4F4),
                  thickness: 2,
                ),

                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: ListView.builder(
                    itemCount: followerSub.length,
                    itemBuilder: (_, i) {
                      isCheckedFollowers = followerSub[i]["selected"];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Checkbox(
                                  activeColor: Color(0xFFF9246A),
                                  value: isCheckedFollowers,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isCheckedFollowers = value!;
                                      followerSub[i]["selected"] =
                                          isCheckedFollowers;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                followerSub[i]["name"],
                                style: TextStyle(
                                    fontFamily: 'Mulish', fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: SizedBox(
                      width: 306,
                      height: 38,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white,
                                  fontFamily: 'Mulish'),
                            ),
                          ),
                          onPressed: () async {
                            print(followerSub);
                            List selectedItems = followerSub
                                .where((item) => item["selected"] == true)
                                .toList();

                            List<int> selectedIds = selectedItems
                                .map<int>((item) => item["id"])
                                .toList();

                            print(selectedIds);

                            String resMessage =
                                await followerSubscriptionAdding(
                                    followerId, selectedIds);

                            if (resMessage == "success") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpportunityDetail(
                                          widget.opportunityId)));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9246A),
                          )),
                    ),
                  ),
                ),
                // SizedBox(width: 15,),
                // Padding(
                //   padding: const EdgeInsets.only(top: 40),
                //   child: Center(
                //     child: SizedBox(
                //       width: 146,
                //       height: 38,
                //       child: ElevatedButton(
                //           child: Center(
                //             child: Text(
                //               "Cancel",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 13.57,
                //                   color: Colors.black),
                //             ),
                //           ),
                //           onPressed: () {},
                //           style: ElevatedButton.styleFrom(
                //             primary: Colors.white,
                //           )),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  defaultSendmsgvalues() async {


    List<int> selectedIds = sendMailData
        .where((item) => item["selected"] == true)
        .map((item) => item["id"] as int)
        .toList();


    print("sjbkjbnkjnsdvkn");

    recipient!.clear();
    token = await getUserJwt();
    var data = await defaultSendmessageData(widget.opportunityId, "crm.lead",selectedIds);
    setState(() {
      print(data);

      subjectController.text = data['subject'].toString() ?? "";

      print(subjectController.text);
      print(data['partner_ids'].length);
      print("subjectController.text");



      for (int i = 0; i < data['partner_ids'].length; i++) {
        selctedRecipient.add(data['partner_ids'][i]);
      }

      for (int i = 0; i < selctedRecipient.length; i++) {
        print(selctedRecipient[i]['display_name']);
        print("selctedRecipient[i]['display_name']");
        editRecipientName.add(new ValueItem(
            label: selctedRecipient[i]['display_name'],
            value: selctedRecipient[i]['id'].toString()));
      }

      recipient = editRecipientName.map((item) => item.value).toList();

      print(recipient);
      print("recipient");


      _isInitialized = true;
    });

    print(token);
  }

  _buildSendmessagePopupDialog(BuildContext context, int sendtypeIds) {
    return StatefulBuilder(builder: (context, setState) {
      lognoteController.text !=""?bodyController.text=lognoteController.text
          :bodyController.text="";

      return AlertDialog(

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery
          //     .of(context)
          //     .size
          //     .height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Odoo",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    IconButton(
                      icon: Image.asset(
                        "images/cross.png",
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          templateName = null;
                          templateId = null;
                          recipient!.clear();
                          bodyController.text = "";
                          subjectController.text = "";
                          logDataHeader.clear();
                          logDataTitle.clear();
                          selectedImagesDisplay.clear();
                          lognoteController.text = "";
                          selectedImages.clear();
                          myData1.clear();
                          editRecipientName.clear();
                          recipient?.clear();
                          selctedRecipient.clear();

                        });

                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Text(
                  "Recipients",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Mulish',
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Followers of the document and",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Mulish',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: MultiSelectDropDown.network(
                    hint: 'Add contacts to notify...',
                    hintStyle: TextStyle(fontFamily: 'Mulish', fontSize: 12),
                    selectedOptions: editRecipientName
                        .map((recipient) => ValueItem(
                            label: recipient.label, value: recipient.value))
                        .toList(),
                    onOptionSelected: (options) {
                      print(options);
                      recipient!.clear();
                      for (var options in options) {
                        recipient!.add(options.value);
                        print('Label: ${options.label}');
                        print('Value: ${options.value}');
                        print(recipient);
                        print('-hgvvjb--');
                      }
                    },
                    networkConfig: NetworkConfig(
                      url:
                          "${baseUrl}api/recipients?&model=crm.lead&company_ids=${globals.selectedIds}",
                      method: RequestMethod.get,
                      headers: {
                        'Authorization': 'Bearer $token',
                      },
                    ),
                    chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                    responseParser: (response) {
                      debugPrint('Response: $response');

                      final list =
                          (response['record'] as List<dynamic>).map((e) {
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
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: TextFormField(
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'Mulish',
                    ),
                    controller: subjectController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),

                        // border: UnderlineInputBorder(),
                        labelText: 'Subject',
                        labelStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: 'Mulish',
                        )),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  //color: Colors.red,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery
                  //     .of(context)
                  //     .size
                  //     .height/6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: bodyController,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Mulish',
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    myAlert("lognote");
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          child: IconButton(
                            icon: Image.asset("images/pin.png"),
                            onPressed: () {},
                          ),
                        ),
                        Text(
                          "ATTACH FILE",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                              fontFamily: 'Mulish'),
                        ),
                      ],
                    ),
                  ),
                ),
                selectedImages.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 40,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 25, right: 50),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 40,
                          child: Container(
                            width: 40,
                            //height: 40,
                            child: GridView.builder(
                              shrinkWrap: true, // Avoid scrolling
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedImages.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 8),
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                    child: kIsWeb
                                        ? Image.network(
                                            selectedImages[index].path)
                                        : Image.file(selectedImages[index]));
                              },
                            ),
                          ),
                        ),
                      ),
                // FutureBuilder(
                //     future: getattchmentData(widget.leadId, "lead.lead"),
                //     builder: (context, AsyncSnapshot snapshot) {
                //
                //       if (snapshot.hasError) {
                //
                //       }
                //       if (snapshot.connectionState == ConnectionState.done) {
                //         if (snapshot.hasData) {
                //           if (snapshot.data == null) {
                //
                //             return const Center(
                //                 child: Text('Something went wrong'));
                //           }
                //           if (snapshot.data.length != 0) {
                //             attachmentImagesDisplay = snapshot.data;
                //
                //             return Padding(
                //               padding:
                //               const EdgeInsets.only(left: 0, right: 100),
                //               child:
                //               Container(
                //                 //color: Colors.green,
                //
                //                 width: MediaQuery.of(context).size.width / 3,
                //
                //                 child: GridView.builder(
                //                   shrinkWrap: true,
                //
                //                   physics: NeverScrollableScrollPhysics(),
                //                   itemCount: attachmentImagesDisplay.length,
                //                   gridDelegate:
                //                   const SliverGridDelegateWithFixedCrossAxisCount(
                //                       crossAxisCount: 1),
                //                   itemBuilder:
                //                       (BuildContext context, int index) {
                //
                //
                //                     return Center(
                //                       child: Container(
                //                         child: Stack(
                //                           children: [
                //                             ClipRRect(
                //                               child: Image.network(
                //                                 "${attachmentImagesDisplay[index]['url']}?token=${token}",
                //                                 height: 120,
                //                                 width: 80,
                //                               ),
                //                             ),
                //                             Positioned(
                //                                 left: 57,
                //                                 right: 0,
                //                                 bottom: 85,
                //                                 top: 1,
                //                                 child: Container(
                //                                   width: 15,
                //                                   // height: 15,
                //                                   color: Colors.grey[200],
                //                                   child: IconButton(
                //                                     icon: Icon(
                //                                       Icons
                //                                           .delete_outline_outlined,
                //                                       size: 15.0,
                //                                       color: Colors.grey[800],
                //                                     ),
                //                                     onPressed: () async {
                //                                       print(
                //                                           attachmentImagesDisplay[
                //                                           index]['id']);
                //                                       print("idvaluevalue");
                //                                       // print(
                //                                       //     logDataTitle[indexx][indexs]['attachment_ids'][index]["id"]);
                //                                       int lodAttachmentId = attachmentImagesDisplay[index]['id'];
                //                                       var data = await deleteLogAttachment(
                //                                           lodAttachmentId);
                //
                //                                       if (data['message'] ==
                //                                           "Success") {
                //                                         print(
                //                                             "jhbdndsjbv");
                //                                         await getLeadDetails();
                //                                         setState(() {
                //                                           attachmentImagesDisplay
                //                                               .clear();
                //                                         });
                //                                       }
                //
                //                                       // print(
                //                                       //     data);
                //                                       print(
                //                                           "delete testststs");
                //                                     },
                //                                   ),
                //                                 ))
                //                           ],
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                 ),
                //               ),
                //
                //             );
                //           } else {
                //             return Container();
                //           }
                //         }
                //       }
                //       return Center(child: const CircularProgressIndicator());
                //     }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: SearchChoices.single(
                    //items: items,

                    value: templateName,
                    hint: Text(
                      "Use template",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    searchHint: null,
                    autofocus: false,
                    onChanged: (value) async {
                      setState(() {
                        print(value['capital']);
                        print("value");
                        templateName = value;
                        templateId = value["id"];
                      });

                      print(templateId);
                      print(widget.opportunityId);
                      print("djbfkjnksdnk");
                      var resultData = await templateSelectionData(
                          templateId, widget.opportunityId, "crm.lead");

                      if (resultData != "") {
                        setState(() {
                          recipient?.clear();
                          selctedRecipient.clear();
                          editRecipientName.clear();
                          subjectController.text = resultData["subject"];
                          bodyController.text = resultData["body"];

                          for (int i = 0;
                              i < resultData['partner_ids'].length;
                              i++) {
                            selctedRecipient.add(resultData['partner_ids'][i]);
                          }

                          for (int i = 0; i < selctedRecipient.length; i++) {
                            editRecipientName.add(new ValueItem(
                                label: selctedRecipient[i]['display_name'],
                                value: selctedRecipient[i]['id'].toString()));
                          }

                          recipient = editRecipientName
                              .map((item) => item.value)
                              .toList();
                        });
                      }

                      print(resultData["body"]);
                      print("dajksfkdmvd ");
                    },

                    dialogBox: false,
                    isExpanded: true,
                    menuConstraints:
                        BoxConstraints.tight(const Size.fromHeight(300)),
                    itemsPerPage: 10,
                    currentPage: currentPage,
                    selectedValueWidgetFn: (item) {
                      return (Center(
                          child: Container(
                        width: 300,
                        child: Text(
                          item["name"],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      )));
                    },
                    futureSearchFn: (String? keyword,
                        String? orderBy,
                        bool? orderAsc,
                        List<Tuple2<String, String>>? filters,
                        int? pageNb) async {
                      Response response = await get(
                        Uri.parse(
                            "${baseUrl}api/message_templates?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=crm.lead"),
                        headers: {
                          'Authorization': 'Bearer $token',
                        },
                      ).timeout(const Duration(
                        seconds: 10,
                      ));

                      if (response.statusCode != 200) {
                        throw Exception("failed to get data from internet");
                      }

                      dynamic data = jsonDecode(response.body);

                      int nbResults = data["length"];

                      List<DropdownMenuItem> results =
                          (data["record"] as List<dynamic>)
                              .map<DropdownMenuItem>((item) => DropdownMenuItem(
                                    value: item,
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text("${item["name"]}"),
                                      ),
                                    ),
                                  ))
                              .toList();
                      return (Tuple2<List<DropdownMenuItem>, int>(
                          results, nbResults));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                  child: Center(
                    child: SizedBox(
                      width: 320,
                      height: 38,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Send",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            for (int i = 0; i < selectedImages.length; i++) {
                              imagepath = selectedImages[i].path.toString();
                              File imagefile =
                                  File(imagepath); //convert Path to File
                              Uint8List imagebytes = await imagefile
                                  .readAsBytes(); //convert to bytes
                              base64string = base64.encode(imagebytes);

                              // base64string1.add(
                              //     base64string);
                              //

                              String dataImages =
                                  '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                              Map<String, dynamic> jsondata =
                                  jsonDecode(dataImages);
                              myData1.add(jsondata);
                            }

                            String resMessage =
                                await createSendmessage(myData1);

                            if (resMessage == "success") {
                              setState(() {
                                logDataHeader.clear();
                                logDataTitle.clear();
                                selectedImagesDisplay.clear();
                                lognoteController.text = "";
                                selectedImages.clear();
                                myData1.clear();
                                editRecipientName.clear();
                                recipient?.clear();
                                selctedRecipient.clear();
                              });
                              Navigator.pop(context);

                              print(recipient);
                              print("tagattagagaga");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF9246A),
                          )),
                    ),
                  ),
                ),
                // SizedBox(width: 15,),
                // Padding(
                //   padding: const EdgeInsets.only(top: 20),
                //   child: Center(
                //     child: SizedBox(
                //       width: 146,
                //       height: 38,
                //       child: ElevatedButton(
                //           child: Center(
                //             child: Text(
                //               "Cancel",
                //               style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 13.57,
                //                   color: Colors.black),
                //             ),
                //           ),
                //           onPressed: () {},
                //           style: ElevatedButton.styleFrom(
                //             primary: Colors.white,
                //           )),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: TextButton(
                      onPressed: () async {
                        await newTemplate();
                      },
                      child: Text(
                        "Save As New Template",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'Mulish'),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  newTemplate() async {
    String value = await newTemplateCreate(bodyController.text, "crm.lead",
        subjectController.text, widget.opportunityId);

    print(value);
    print("valuesss");
    return value;
  }

  createSendmessage(List myData1) async {
    String value = await sendMessageCreate(
        bodyController.text,
        "crm.lead",
        subjectController.text,
        widget.opportunityId,
        recipient,
        templateId,
        myData1);

    print(value);
    print("valuesss");
    return value;
  }
}
