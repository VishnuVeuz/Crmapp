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
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:search_choices/search_choices.dart';

import 'bottomnavigation.dart';
import 'custom_shape.dart';
import 'globals.dart';
import 'main.dart';
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
  static final _editFormKey = GlobalKey<FormState>();

  @override
  State<OpportunityDetail> createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail> {
  final _textValue = ValueNotifier<String>('');

  PointerThisPlease<int> currentPage = PointerThisPlease<int>(1);
  dynamic lostreasonName, lostreasonId;
  String notificationCount = "0";
  String messageCount = "0";
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
  //String? token;
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
      internalVisibility = true,
      otherinfoVisibility = false,
      smartbuttonVisible = true,
      smartbuttonSaveVisible = false,
      starImage = false,
      lognoteoptions = true,
      lognoteVisibility = false,
      recipientsVisibility = false,
      followersVisibility = true;

  int? smartbuttonPosition;

  int? scheduleViewIndex;
  int selectedItemIndex = -1;

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
  TextEditingController lognoteEditController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];
  List<File> selectedImagesEdit = [];
  var selectedImagesDisplay;

  List<dynamic> logattachmentImagesDisplay = [];
  List<dynamic> logattachmentFileDisplay = [];

  List<dynamic> attachmentImagesDisplay = [];
  List<dynamic> attachmentFileDisplay = [];
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
  int? logDataIdEmoji;

  bool _isSavingData = false;

  TextEditingController sendphoneController = TextEditingController();
  TextEditingController sendmobileController = TextEditingController();
  TextEditingController sendjobController = TextEditingController();
  TextEditingController sendemailController = TextEditingController();
  TextEditingController sendnameController = TextEditingController();
  String radioInput = "person";
  dynamic schedulecompanyName, schedulecompanyId;
  int? scheduleCustcreateId;
  String? tagChangeColoir;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.opportunityId);
    print("leadId");
    getOpportunityDetails();
    requestNotificationPermissions();
    _initDownloadPath();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  String? token, baseUrl;

  String? _taskId;
  String? _localPath;

  PostProvideropportunity? postProvider;

  Widget build(BuildContext context) {
    print("builddataa");
    if (postProvider == null) {
      postProvider =
          Provider.of<PostProvideropportunity>(context, listen: false);
    }

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFFAA82E3),
      ),
      home: !_isInitialized
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              // resizeToAvoidBottomInset: false,
              drawer: MainDrawer(),
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 0,
                title: Row(
                  children: [
                    Container(
                      //width: MediaQuery.of(context).size.width / 4,
                      width: 150,
                      child: Text(
                        opportunityname!,
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                    )
                  ],
                ),
                leading: Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: IconButton(
                      icon: Image.asset("images/back.png"),
                      onPressed: () {
                        setState(() {
                          widget.opportunityId = 0;
                        });
                        navigatorKey.currentState
                            ?.pushNamed('OpportunityMainPage');
                      },
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
                actions: [
                  Builder(builder: (context) {
                    return Row(
                      children: [
                        Container(
                          child: Stack(alignment: Alignment.center, children: [
                            IconButton(
                              icon: SvgPicture.asset("images/messages.svg"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Notifications()));
                              },
                            ),
                            Positioned(
                              bottom: 25,
                              right: 28,
                              child: Container(
                                width: 18.0,
                                height: 18.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFA256B),
                                ),
                                child: Center(
                                    child: Text(
                                  messageCount,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8),
                                )),
                              ),
                            ),
                          ]),
                        ),
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
                                width: 18.0,
                                height: 18.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFA256B),
                                ),
                                child: Center(
                                    child: Text(
                                  notificationCount,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8),
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
              body: Builder(builder: (context) {
                final mediaQueryData = MediaQuery.of(context);
                return WillPopScope(
                  onWillPop: () async {
                    print("fin alalalal");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OpportunityMainPage(null, "", "", "", "")));
                    return true;
                  },
                  child: Container(
                    width: mediaQueryData.size.width,
                    height: mediaQueryData.size.height,
                    color: Colors.white,
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

                                        customername == "" ?
                     convertQuotationError("Cannot convert due to customer missing") :

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
                                        showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 70,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              print(widget
                                                                  .opportunityId);
                                                              try {
                                                                var data =
                                                                    await deleteOpportunityData(
                                                                        widget
                                                                            .opportunityId);

                                                                if (data[
                                                                        'message'] ==
                                                                    "Success") {
                                                                  print(data);

                                                                  print(
                                                                      "responcedata");
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => OpportunityMainPage(
                                                                            null,
                                                                            "",
                                                                            "",
                                                                            "",
                                                                            "")),
                                                                  );
                                                                }
                                                              } catch (e) {
                                                                errorMethod(e);
                                                              }
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              "images/delete.svg",
                                                              width: 28,
                                                              height: 28,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Text(
                                                                "Delete",
                                                                style:
                                                                    TextStyle(
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
                                                      Column(
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              try {
                                                                var data = await getOpportunityData(
                                                                    widget
                                                                        .opportunityId,
                                                                    "duplicate");
                                                                String
                                                                    resMessageText;

                                                                if (data['message']
                                                                        .toString() ==
                                                                    "success") {
                                                                  resMessageText =
                                                                      data['data']
                                                                              [
                                                                              'id']
                                                                          .toString();
                                                                  int resmessagevalue =
                                                                      int.parse(
                                                                          resMessageText);
                                                                  if (resmessagevalue !=
                                                                      0) {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              OpportunityCreation(resmessagevalue)),
                                                                    );
                                                                  }
                                                                }
                                                              } catch (e) {
                                                                errorMethod(e);
                                                              }
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              "images/duplicatee.svg",
                                                              width: 28,
                                                              height: 28,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Text(
                                                                "Duplicate",
                                                                style:
                                                                    TextStyle(
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
                                                      opportunityType == true
                                                          ? Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    showDialog<
                                                                            String>(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            AlertDialog(
                                                                              title: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  const Text('Lost Reason',
                                                                                      style: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.black,
                                                                                        fontFamily: 'Mulish',
                                                                                      )),
                                                                                  IconButton(
                                                                                    icon: SvgPicture.asset("images/cr.svg"),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              content: Container(
                                                                                width: mediaQueryData.size.width,
                                                                                height: mediaQueryData.size.height / 2.8,
                                                                                //color: Colors.green,

                                                                                child: SearchChoices.single(
                                                                                  value: lostreasonName,
                                                                                  hint: Text(
                                                                                    "Lost Reason",
                                                                                    style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Mulish'),
                                                                                  ),
                                                                                  searchHint: null,
                                                                                  autofocus: true,
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      lostreasonName = value;
                                                                                      lostreasonId = value["id"];
                                                                                    });
                                                                                  },
                                                                                  dialogBox: false,
                                                                                  isExpanded: true,
                                                                                  menuConstraints: BoxConstraints.tight(const Size.fromHeight(200)),
                                                                                  itemsPerPage: 10,
                                                                                  currentPage: currentPage,
                                                                                  selectedValueWidgetFn: (item) {
                                                                                    return (Center(
                                                                                        child: Container(
                                                                                      width: 300,
                                                                                      child: Text(
                                                                                        item["name"],
                                                                                        style: TextStyle(fontSize: 12, color: Colors.black, fontFamily: 'Mulish'),
                                                                                      ),
                                                                                    )));
                                                                                  },
                                                                                  futureSearchFn: (String? keyword, String? orderBy, bool? orderAsc, List<Tuple2<String, String>>? filters, int? pageNb) async {
                                                                                    token = await getUserJwt();
                                                                                    baseUrl = await getUrlString();
                                                                                    Response response = await get(
                                                                                      Uri.parse("${baseUrl}api/common_dropdowns?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=crm.lost.reason"),
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
                                                                                    return (Tuple2<List<DropdownMenuItem>, int>(results, nbResults));
                                                                                  },
                                                                                ),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 20, right: 5),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 130,
                                                                                        height: 40,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                          color: Color(0xFF043565),
                                                                                        ),
                                                                                        child: TextButton(
                                                                                            child: const Text(
                                                                                              'Submit',
                                                                                              style: TextStyle(fontFamily: 'Mulish', color: Colors.white),
                                                                                            ),
                                                                                            onPressed: () async {
                                                                                              //Navigator.pop(context);
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
                                                                                      // SizedBox(
                                                                                      //   width: 5,
                                                                                      // ),
                                                                                      // Padding(
                                                                                      //   padding: const EdgeInsets.only(right: 10),
                                                                                      //   child: Container(
                                                                                      //     width: 130,
                                                                                      //     height: 40,
                                                                                      //     decoration: BoxDecoration(
                                                                                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                      //       color: Colors.grey[100],
                                                                                      //     ),
                                                                                      //     child: TextButton(
                                                                                      //       onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                                      //       child: const Text(
                                                                                      //         'Cancel',
                                                                                      //         style: TextStyle(fontFamily: 'Mulish', color: Colors.black),
                                                                                      //       ),
                                                                                      //     ),
                                                                                      //   ),
                                                                                      // ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ));
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/lost.svg",
                                                                    width: 28,
                                                                    height: 28,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Text(
                                                                      "Lost",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Mulish',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF212121),
                                                                      )),
                                                                )
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    String
                                                                        resmessage =
                                                                        await opportunityWonRestore(
                                                                            "restore");
                                                                    int resmessagevalue =
                                                                        int.parse(
                                                                            resmessage);
                                                                    if (resmessagevalue !=
                                                                        0) {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                OpportunityDetail(resmessagevalue)),
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/more.svg",
                                                                    width: 28,
                                                                    height: 28,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Text(
                                                                      "Restore",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Mulish',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF212121),
                                                                      )),
                                                                )
                                                              ],
                                                            ),
                                                      Visibility(
                                                        visible:
                                                            opportunityType!,
                                                        child: Column(
                                                          children: [
                                                            InkWell(
                                                              onTap: () async {
                                                                String
                                                                    resmessage =
                                                                    await opportunityWonRestore(
                                                                        "won");
                                                                int resmessagevalue =
                                                                    int.parse(
                                                                        resmessage);
                                                                if (resmessagevalue !=
                                                                    0) {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                OpportunityDetail(resmessagevalue)),
                                                                  );
                                                                }
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                "images/won.svg",
                                                                width: 28,
                                                                height: 28,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                              child: Text("Won",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Mulish',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize:
                                                                        12,
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
                                                                  onTap:
                                                                      () async {
                                                                    String
                                                                        resmessage =
                                                                        await opportunityarchive(
                                                                            false);
                                                                    int resmessagevalue =
                                                                        int.parse(
                                                                            resmessage);
                                                                    if (resmessagevalue !=
                                                                        0) {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                OpportunityDetail(resmessagevalue)),
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/more.svg",
                                                                    width: 28,
                                                                    height: 28,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Text(
                                                                      "Archive",
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Mulish',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontSize:
                                                                            12,
                                                                        color: Color(
                                                                            0xFF212121),
                                                                      )),
                                                                )
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    String
                                                                        resmessage =
                                                                        await opportunityarchive(
                                                                            true);
                                                                    int resmessagevalue =
                                                                        int.parse(
                                                                            resmessage);
                                                                    if (resmessagevalue !=
                                                                        0) {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                OpportunityDetail(resmessagevalue)),
                                                                      );
                                                                    }
                                                                  },
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    "images/unarchivee.svg",
                                                                    width: 28,
                                                                    height: 28,
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Text(
                                                                    "Unarchive",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Mulish',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          12,
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

                                                              var name,
                                                                  phone,
                                                                  smsId;
                                                              bool smsCondition;
                                                              name = smsResponce[
                                                                  'recipient_single_description'];
                                                              phone = smsResponce[
                                                                  'recipient_single_number_itf'];
                                                              smsId =
                                                                  smsResponce[
                                                                      'id'];
                                                              smsCondition =
                                                                  smsResponce[
                                                                      'invalid_tag'];

                                                              showDialog(
                                                                context:
                                                                    context,
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
                                                                  setState(
                                                                      () {}));
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              "images/sendsmss.svg",
                                                              width: 28,
                                                              height: 28,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5),
                                                            child: Text(
                                                                "Send SMS",
                                                                style:
                                                                    TextStyle(
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
                              width: mediaQueryData.size.width,
                              height: 39,
                              color: Color(0xFFF5F5F5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Container(
                                              width: 30,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    "images/calendar.png"),
                                                onPressed: () {
                                                  if (meeting_count >= 0) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Calender(
                                                                    null,
                                                                    "",
                                                                    DateTime
                                                                        .now(),
                                                                    null,
                                                                    [],
                                                                    "")));
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 1.0),
                                            child: Center(
                                                child: Text(
                                              "Meeting",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 13,
                                                  color: Color(0xFF212121)),
                                            )),
                                          ),
                                          Center(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text(
                                              meeting_count.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: Color(0xFFED2449)),
                                            ),
                                          )),
                                          Divider(color: Colors.grey),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      if (meeting_count >= 0) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Calender(
                                                    null,
                                                    "",
                                                    DateTime.now(),
                                                    null,
                                                    [],
                                                    "")));
                                      }
                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            child: IconButton(
                                              icon: Image.asset(
                                                  "images/edit.png"),
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
                                                              QuotationDetail(
                                                                  datas)),
                                                    );
                                                  }
                                                }

                                                if (quotation_count > 1) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            QuotationScrollingopportunity(
                                                                widget
                                                                    .opportunityId)),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Center(
                                              child: Text(
                                            "Quotations",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Mulish',
                                                fontSize: 13,
                                                color: Color(0xFF212121)),
                                          )),
                                          Center(
                                              child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 2),
                                            child: Text(
                                              quotation_count.toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: Color(0xFFED2449)),
                                            ),
                                          )),
                                          Divider(
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
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
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              child: IconButton(
                                                icon: Image.asset(
                                                    "images/star4.png"),
                                                onPressed: () {
                                                  if (similar_opportunity > 0) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                OpportunityMainPage(
                                                                    widget
                                                                        .opportunityId,
                                                                    "similar",
                                                                    "",
                                                                    "",
                                                                    "")));
                                                  }
                                                },
                                              ),
                                            ),
                                            Center(
                                                child: Text(
                                              "Similar Opportunity",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 13,
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
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13,
                                                    color: Color(0xFFED2449)),
                                              ),
                                            )),
                                            Divider(color: Colors.grey),
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 25, right: 25),
                                child: Container(
                                  width: mediaQueryData.size.width / 1.52,
                                  child: Text(opportunityname!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 17,
                                        color: Colors.black,
                                      )),
                                ),
                              ),
                              opportunityType == true
                                  ? opportunityTypeWon == true
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 5, right: 25),
                                          child: Container(
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20),
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
                                              top: 20, left: 5, right: 25),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                          top: 20, left: 5, right: 25),
                                      child: Container(
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Customer",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: mediaQueryData.size.width / 2,
                                // color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      customername!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF000000)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Email",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: mediaQueryData.size.width / 2.3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      email!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF000000)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Phone",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Visibility(
                                visible: phone != "" ? true : false,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      children: [
                                        Container(
                                          //width:mediaQueryData.size.width /5,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              phone!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF000000)),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var smsResponce = await smsDataGet(
                                                widget.opportunityId,
                                                "crm.lead");

                                            var name, phone, smsId;
                                            bool smsCondition;
                                            name = smsResponce[
                                                'recipient_single_description'];
                                            phone = smsResponce[
                                                'recipient_single_number_itf'];
                                            smsId = smsResponce['id'];
                                            smsCondition =
                                                smsResponce['invalid_tag'];

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildSendsmsPopupDialog(
                                                      context,
                                                      name,
                                                      phone,
                                                      smsId,
                                                      smsCondition,
                                                      "phone"),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0),
                                                  child: Text(
                                                    "SMS",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Mulish',
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF000000)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Mobile",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Visibility(
                                visible: mobile != "" ? true : false,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Row(
                                      children: [
                                        Container(
                                          //width:mediaQueryData.size.width /5,
                                          //color: Colors.red,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              phone!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF000000)),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            var smsResponce = await smsDataGet(
                                                widget.opportunityId,
                                                "crm.lead");

                                            var name, phone, smsId;
                                            bool smsCondition;
                                            name = smsResponce[
                                                'recipient_single_description'];
                                            phone = smsResponce[
                                                'recipient_single_number_itf'];
                                            smsId = smsResponce['id'];
                                            smsCondition =
                                                smsResponce['invalid_tag'];

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildSendsmsPopupDialog(
                                                      context,
                                                      name,
                                                      phone,
                                                      smsId,
                                                      smsCondition,
                                                      ""),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 0),
                                                  child: Text(
                                                    "SMS",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Mulish',
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF000000)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Salesperson",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  salesperImg != ""
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: 20,
                                              height: 20,
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
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      //  color: Colors.green
                                                      ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: CircleAvatar(
                                                radius: 12,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 20,
                                                  color: Colors
                                                      .white, // Adjust the color of the icon as per your requirements
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    //width: MediaQuery.of(context).size.width / 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 25),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          salesperson!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'Mulish',
                                              fontSize: 12,
                                              color: Color(0xFF000000)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Priority",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                  width: mediaQueryData.size.width / 2.3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 25),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: RatingBar.builder(
                                        initialRating: double.parse(priority!),
                                        // initialRating: 0.0,

                                        itemSize: 19,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 3,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          //color: Colors.amber,
                                          color: Colors.green,
                                          size: 10,
                                        ),
                                        onRatingUpdate: (double value) async {
                                          int prioritydata = value.toInt();
                                          String valuess =
                                              await editOppertunitypriority(
                                                  prioritydata.toString(),
                                                  widget.opportunityId);
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Tags",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 0),
                                child: Container(
                                  width: mediaQueryData.size.width / 1.8,
                                  // height: 20,
                                  //color: Colors.pinkAccent,

                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    direction: Axis
                                        .horizontal, // Direction is horizontal
                                    spacing: 8.0, // Space between items
                                    runSpacing:
                                        8.0, // Space between rows (if wrapping)
                                    children: List.generate(tags!.length ?? 0,
                                        (int index) {
                                      final TextSpan span = TextSpan(
                                        text: tags![index]["name"].toString(),
                                        style: TextStyle(fontSize: 10),
                                      );
                                      final TextPainter tp = TextPainter(
                                          text: span,
                                          textDirection:
                                              Directionality.of(context));
                                      tp.layout();
                                      double textWidth = tp.size.width;

                                      return InkWell(
                                        onTap: () async {
                                          var colors = await getColors();

                                          int selectedtagId =
                                              tags![index]["id"];
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildColorPopupDialog(context,
                                                    colors, selectedtagId),
                                          ).then((value) => setState(() {
                                                tagChangeColoir == null
                                                    ? tags![index]["color"] =
                                                        tags![index]["color"]
                                                    : tags![index]["color"] =
                                                        tagChangeColoir;
                                              }));
                                        },

                                        child: ClipPath(
                                          clipper: CustomShape(
                                              textWidth), // Pass the calculated width
                                          child: Container(
                                            width: textWidth +
                                                27, // Set the container width based on text width + padding
                                            height: 20,
                                            color: Color(int.parse(
                                                tags![index]["color"])),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: Text(
                                                        tags![index]["name"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Mulish',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 9.5,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 2),
                                                      child: SvgPicture.asset(
                                                        'images/cross.svg',
                                                        width: 10,
                                                        height: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // child: Container(
                                        //   decoration: BoxDecoration(
                                        //     borderRadius:
                                        //     BorderRadius.all(Radius.circular(30)),
                                        //     color:
                                        //     Color(int.parse(tags![index]["color"])),
                                        //   ),
                                        //   width: 70,
                                        //   height: 19,
                                        //   child: Center(
                                        //     child: Text(
                                        //       tags![index]["name"].toString(),
                                        //       style: TextStyle(
                                        //           color: Colors.white,
                                        //           fontFamily: 'Mulish',
                                        //           fontWeight: FontWeight.w600,
                                        //           fontSize: 10),
                                        //     ),
                                        //   ),
                                        // ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 22, right: 22),
                            child: Divider(
                              color: Color(0xFFF4F4F4),
                              thickness: 1.5,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Text("Company",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF666666))),
                              ),
                              Container(
                                width: mediaQueryData.size.width / 2.3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 25),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      company!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF000000)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Visibility(
                            visible: smartbuttonVisible,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 21, right: 25),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    // color: Colors.red,
                                    child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                      //shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: opportunityStageTypes.length ?? 0,
                                      itemBuilder: (context, index) {
                                        print(index);
                                        print("final indexxx");
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 10),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                child: Container(
                                                  // color: Colors.red,
                                                  //width: mediaQueryData.size.width/3,
                                                  width: mediaQueryData.size.width /
                                                      4.1,
                                                  // height: 50,
                                                  child: Stack(
                                                    children: [
                                                      index == 0
                                                          ? stageColorIndex == index
                                                              ? Image.asset(
                                                                  'images/bluebtnfirst.png')
                                                              : Image.asset(
                                                                  'images/greenbtnfirst.png')
                                                          : stageColorIndex == index
                                                              ? Image.asset(
                                                                  'images/bluebtn.png')
                                                              : stageColorIndex! >
                                                                      index
                                                                  ? Image.asset(
                                                                      'images/greenbtn.png')
                                                                  : Image.asset(
                                                                      'images/greybtn.png'),
                                                      Positioned.fill(
                                                          child: Align(
                                                              alignment:
                                                                  Alignment.center,
                                                              child: stageColorIndex ==
                                                                          index ||
                                                                      stageColorIndex! >
                                                                          index
                                                                  ? Text(
                                                                      opportunityStageTypes[
                                                                              index]
                                                                          ['name'],
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'Mulish',
                                                                      ),
                                                                    )
                                                                  : Text(
                                                                      opportunityStageTypes[
                                                                              index]
                                                                          ['name'],
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'Mulish',
                                                                      ),
                                                                    )))
                                                    ],
                                                  ),
                                                ),
                                                onTap: () async {
                                                  setState(() {
                                                    smartbuttonSaveVisible = true;
                                                    smartbuttonPosition = index;
                                                  });

                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: smartbuttonSaveVisible,
                                    child: InkWell(
                                      onTap: () async {
                                        String resmessage =
                                        await StageChangeOpportunity(
                                            opportunityStageTypes[
                                            smartbuttonPosition!]['id']);
                                        int resmessagevalue =
                                        int.parse(resmessage);
                                        if (resmessagevalue != 0) {
                                          setState(() {
                                            stageColorIndex = smartbuttonPosition;
                                            smartbuttonSaveVisible = false;
                                          });

                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left:5, top: 5),
                                        child: Container(

                                          decoration: BoxDecoration(
                                              color: Color(0xFF9161D4),
                                              border: Border.all(
                                                color: Color(0xFF9161D4),
                                              ),
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                          ),
                                          width:mediaQueryData.size.width,
                                          height: 30,

                                          child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("images/whitetik.svg"),
                                            Center(
                                              child: Text("Mark Stage as Complete",style: TextStyle( fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 13.57,
                                                  color: Colors.white),),
                                            ),
                                          ],
                                        ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                        fontWeight: FontWeight.w500,
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
                                  orderLineProductsData =
                                      orderLineProducts[index];

                                  return InkWell(
                                      onTap: () {
                                        print(orderLineProducts[index]);
                                        print("orderLineProducts[index];");
                                      },
                                      child: Card(
                                        elevation: 3,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: Container(
                                              width: mediaQueryData.size.width,

                                              // height: MediaQuery.of(context).size.height/10,
                                              color: Colors.white,
                                              child: Column(
                                                // crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                                        left:
                                                                            22),
                                                                child:
                                                                    Container(
                                                                  width: mediaQueryData
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
                                                                        fontSize:
                                                                            14,
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
                                                                        left:
                                                                            40,
                                                                        right:
                                                                            25),
                                                                child: Text(
                                                                  "sum: ${orderLineProductsData!['price_subtotal']}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xFF787878),
                                                                      fontFamily:
                                                                          'Mulish'),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 5,
                                                                    left: 22),
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
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xFF787878),
                                                                      fontFamily:
                                                                          'Mulish'),
                                                                ),
                                                                Text(
                                                                  orderLineProductsData![
                                                                              "product_uom_qty"]
                                                                          .toString() ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xFF787878),
                                                                      fontFamily:
                                                                          'Mulish'),
                                                                ),
                                                                Text(
                                                                  " " + orderLineProductsData!["product_uom"]['name'].toString() ??
                                                                      "",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                      color: Color(
                                                                          0xFF787878),
                                                                      fontFamily:
                                                                          'Mulish'),
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
                                                                        left:
                                                                            22,
                                                                        bottom:
                                                                            5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Unit Price :",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                              0xFF787878),
                                                                          fontFamily:
                                                                              'Mulish'),
                                                                    ),
                                                                    Text(
                                                                      orderLineProductsData!['price_unit']
                                                                              .toString() ??
                                                                          "",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              12,
                                                                          color: Color(
                                                                              0xFF787878),
                                                                          fontFamily:
                                                                              'Mulish'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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

                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              color: Color(0xFFFFFFFF),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, left: 17, right: 0),
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: internalVisibility == true
                                                  ? Color(0XFFED2478)
                                                  : Colors
                                                      .transparent, // Underline color
                                              width: 1.5, // Underline width
                                            ),
                                          ),
                                        ),
                                        child: TextButton(
                                            child: Text(
                                              "Internal Notes",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 13,
                                                  color:
                                                      internalVisibility == true
                                                          ? Color(0XFF212121)
                                                          : Color(0xFF212121)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                internalVisibility == true
                                                    ? internalVisibility = false
                                                    : internalVisibility = true;

                                                otherinfoVisibility == false
                                                    ? otherinfoVisibility =
                                                        false
                                                    : otherinfoVisibility =
                                                        false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFFFFFFFF),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, left: 40, right: 0),
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: otherinfoVisibility == true
                                                  ? Color(0XFFED2478)
                                                  : Colors
                                                      .transparent, // Underline color
                                              width: 1.5, // Underline width
                                            ),
                                          ),
                                        ),
                                        child: TextButton(
                                            child: Text(
                                              "Other Information",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 13,
                                                  color: otherinfoVisibility ==
                                                          true
                                                      ? Color(0XFF212121)
                                                      : Color(0xFF212121)),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                otherinfoVisibility == true
                                                    ? otherinfoVisibility =
                                                        false
                                                    : otherinfoVisibility =
                                                        true;
                                                internalVisibility == false
                                                    ? internalVisibility = false
                                                    : internalVisibility =
                                                        false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xFFFFFFFF),
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: internalVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: Container(
                                color: Color(0xFFf5f5f5),
                                width: mediaQueryData.size.width,
                                //height: 40,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, top: 10, bottom: 10),
                                  child: Text(internalnotes!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          color: Color(0xFF787878))),
                                ),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: otherinfoVisibility,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Container(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 22, right: 22),
                                      child: Divider(
                                        color: Color(0xFFF4F4F4),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 25),
                                            child: Text("Created by",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Mulish',
                                                    fontSize: 12,
                                                    color: Color(0xFF666666))),
                                          ),
                                          Container(
                                            width:
                                                mediaQueryData.size.width / 2.3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  createdby!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Mulish',
                                                      fontSize: 12,
                                                      color: Color(0xFF000000)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 22, right: 22),
                                      child: Divider(
                                        color: Color(0xFFF4F4F4),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Text("Created on",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF666666))),
                                        ),
                                        Container(
                                          width:
                                              mediaQueryData.size.width / 2.3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                createdon!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Mulish',
                                                    fontSize: 12,
                                                    color: Color(0xFF000000)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 22, right: 22),
                                      child: Divider(
                                        color: Color(0xFFF4F4F4),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Text("Last Updated by",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF666666))),
                                        ),
                                        Container(
                                          width:
                                              mediaQueryData.size.width / 2.3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                lastupdateby!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'Mulish',
                                                    fontSize: 12,
                                                    color: Color(0xFF000000)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 22, right: 22),
                                      child: Divider(
                                        color: Color(0xFFF4F4F4),
                                        thickness: 1.5,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25),
                                          child: Text("Last Updated on",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Mulish',
                                                  fontSize: 12,
                                                  color: Color(0xFF666666))),
                                        ),
                                        Container(
                                          width:
                                              mediaQueryData.size.width / 2.3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(lastupdateon!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Mulish',
                                                      fontSize: 12,
                                                      color:
                                                          Color(0xFF000000))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 0, left: 22, right: 22),
                                      child: Divider(
                                        color: Color(0xFFF4F4F4),
                                        thickness: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Container(
                            color: Color(0xFFFFFFFF),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20, right: 0),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: followersVisibility == true
                                                ? Color(0XFFED2478)
                                                : Colors
                                                    .transparent, // Underline color
                                            width: 1.5, // Underline width
                                          ),
                                        ),
                                      ),
                                      child: TextButton(
                                          child: Text(
                                            "Send Message",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Mulish',
                                                fontSize: 13,
                                                color:
                                                    followersVisibility == true
                                                        ? Color(0XFF212121)
                                                        : Color(0xFF212121)),
                                          ),
                                          onPressed: () async {
                                            sendMailData =
                                                await sendMailsFollowers(
                                                    widget.opportunityId,
                                                    "crm.lead");

                                            setState(() {
                                              followersVisibility == true
                                                  ? followersVisibility = false
                                                  : followersVisibility = true;
                                              lognoteVisibility == false
                                                  ? lognoteVisibility = false
                                                  : lognoteVisibility = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFFFFFFF),
                                          )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20, right: 0),
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: lognoteVisibility == true
                                                ? Color(0XFFED2478)
                                                : Colors
                                                    .transparent, // Underline color
                                            width: 1.5, // Underline width
                                          ),
                                        ),
                                      ),
                                      child: TextButton(
                                          child: Text(
                                            "Log note",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Mulish',
                                                fontSize: 13,
                                                color: lognoteVisibility == true
                                                    ? Color(0XFF212121)
                                                    : Color(0xFF212121)),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              followersVisibility == false
                                                  ? followersVisibility = false
                                                  : followersVisibility = false;
                                              lognoteVisibility == true
                                                  ? lognoteVisibility = false
                                                  : lognoteVisibility = true;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xFFFFFFFF),
                                          )),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 20, right: 23),
                                  child: Center(
                                    child: TextButton(
                                        child: Text(
                                          "Schedule Activity",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
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
                                                _buildOrderPopupDialog(
                                                    context, 0),
                                          ).then((value) => setState(() {}));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xFFFFFFFF),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 25, right: 20),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          child: Container(
                                            width: 18,
                                            child: Image.asset(
                                              "images/pi.png",
                                              color: Colors.black,
                                              width: 0,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              attachmentVisibility == true
                                                  ? attachmentVisibility = false
                                                  : attachmentVisibility = true;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Container(
                                          width: 25,
                                          // color: Colors.green,
                                          child: Text(
                                            attachmentCount!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        followerStatus == false
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
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
                                                                  widget
                                                                      .opportunityId,
                                                                  "crm.lead");

                                                          if (resMessage ==
                                                              "success") {
                                                            setState(() {
                                                              int followCount;
                                                              followCount =
                                                                  int.parse(
                                                                      followerCount!);
                                                              followerStatus =
                                                                  true;
                                                              followCount =
                                                                  followCount +
                                                                      1;
                                                              followerCount =
                                                                  followCount
                                                                      .toString();
                                                            });

                                                            // Navigator.push(
                                                            //     context,
                                                            //     MaterialPageRoute(
                                                            //         builder: (context) => OpportunityDetail(widget.opportunityId)));
                                                          }
                                                        },
                                                        child: Text(
                                                          "Follow",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontFamily:
                                                                  'Mulish'),
                                                        )),
                                                  ],
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
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
                                                                  widget
                                                                      .opportunityId,
                                                                  "crm.lead");

                                                          if (resMessage ==
                                                              "success") {
                                                            setState(() {
                                                              int followCount;
                                                              followCount =
                                                                  int.parse(
                                                                      followerCount!);
                                                              followerStatus =
                                                                  false;
                                                              followCount =
                                                                  followCount -
                                                                      1;
                                                              followerCount =
                                                                  followCount
                                                                      .toString();
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
                                                              fontFamily:
                                                                  'Mulish'),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                        InkWell(
                                          child: Container(
                                              width: 20,
                                              child: SvgPicture.asset(
                                                  "images/user.svg")),
                                          onTap: () async {
                                            List followers = await getFollowers(
                                                widget.opportunityId,
                                                "crm.lead");

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildFollowPopupDialog(
                                                      context, followers),
                                            ).then((value) => setState(() {}));
                                          },
                                        ),
                                        Container(
                                          width: 25,
                                          //color: Colors.green,
                                          child: Text(
                                            followerCount!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // code for attchments

                          Visibility(
                            visible: attachmentVisibility,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: Column(
                                children: [
                                  FutureBuilder(
                                      future: getattchmentData(
                                          widget.opportunityId, "crm.lead"),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasError) {}
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data == null) {
                                              return const Center(
                                                  child: Text(
                                                      'Something went wrong'));
                                            }
                                            if (snapshot.data.length != 0) {
                                              attachmentImagesDisplay =
                                                  snapshot.data['images'];
                                              attachmentFileDisplay =
                                                  snapshot.data['files'];
                                              return Column(
                                                children: [
                                                  Container(
                                                    width: mediaQueryData
                                                        .size.width,
                                                    child: attachmentImagesDisplay
                                                                .length >
                                                            0
                                                        ? GridView.builder(
                                                            shrinkWrap: true,
                                                            // Avoid scrolling
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                attachmentImagesDisplay
                                                                    .length,
                                                            // itemCount: 15,
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 4,
                                                              mainAxisSpacing:
                                                                  1.0,
                                                              crossAxisSpacing:
                                                                  1.0,
                                                              childAspectRatio:
                                                                  1,
                                                            ),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Container(
                                                                //color: Colors.red,

                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        2,
                                                                        0,
                                                                        2,
                                                                        0),
                                                                width: 80,
                                                                height: double
                                                                    .infinity,
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                      left: 0,
                                                                      top: 6,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              75,
                                                                          height:
                                                                              71,
                                                                          child:
                                                                              Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(3),
                                                                              color: Color(0xffd9d9d9),
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.cover,
                                                                                image: NetworkImage("${attachmentImagesDisplay[index]['url']}?token=${token}"),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      left: 60,
                                                                      top: 0,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              20,
                                                                          height:
                                                                              20,
                                                                          child:
                                                                              Image.asset(
                                                                            'images/logimagedelete.png',
                                                                            width:
                                                                                20,
                                                                            height:
                                                                                20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      // trash2G2c (1652:325)
                                                                      left: 65,
                                                                      top: 5,
                                                                      child:
                                                                          Align(
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () async {
                                                                            int lodAttachmentId =
                                                                                attachmentImagesDisplay[index]['id'];
                                                                            var data =
                                                                                await deleteLogAttachment(lodAttachmentId);

                                                                            if (data['message'] ==
                                                                                "Success") {
                                                                              await getOpportunityDetails();
                                                                              setState(() {
                                                                                attachmentImagesDisplay.clear();
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                9,
                                                                            height:
                                                                                10,
                                                                            child:
                                                                                Image.asset(
                                                                              'images/logtrash.png',
                                                                              width: 9,
                                                                              height: 10,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            })
                                                        : Container(),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                    width: mediaQueryData
                                                        .size.width,
                                                    child: attachmentFileDisplay
                                                                .length >
                                                            0
                                                        ? GridView.builder(
                                                            shrinkWrap: true,
                                                            // Avoid scrolling
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                attachmentFileDisplay
                                                                    .length,
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 1,
                                                              //mainAxisSpacing: 5.0,
                                                              crossAxisSpacing:
                                                                  1.0,
                                                              childAspectRatio:
                                                                  5.5,
                                                            ),
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        2,
                                                                        0,
                                                                        2,
                                                                        0),
                                                                width: double
                                                                    .infinity,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              14,
                                                                              11,
                                                                              18,
                                                                              9),
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          52,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border.all(
                                                                            color:
                                                                                Color(0xffebebeb)),
                                                                        borderRadius:
                                                                            BorderRadius.circular(6),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                0,
                                                                                12,
                                                                                0),
                                                                            width:
                                                                                23,
                                                                            height:
                                                                                29,
                                                                            child:
                                                                                Image.asset(
                                                                              attachmentFileDisplay[index]["mimetype"] == "application/pdf"
                                                                                  ? 'images/logpdf.png'
                                                                                  : attachmentFileDisplay[index]["mimetype"] == "application/msword"
                                                                                      ? 'images/logword.png'
                                                                                      : attachmentFileDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                                                                          ? 'images/logexcel.png'
                                                                                          : attachmentFileDisplay[index]["mimetype"] == "application/xml"
                                                                                              ? 'images/logxml.png'
                                                                                              : attachmentFileDisplay[index]["mimetype"] == "application/zip"
                                                                                                  ? 'images/logzip.png'
                                                                                                  : '',
                                                                              width: 23,
                                                                              height: 29,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                mediaQueryData.size.width / 2,
                                                                            //height: double.infinity,
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Positioned(
                                                                                  // pdfnamearea1tc (1652:376)
                                                                                  left: 0,
                                                                                  top: 00,
                                                                                  child: Align(
                                                                                    child: SizedBox(
                                                                                      width: mediaQueryData.size.width / 2,
                                                                                      child: Text(
                                                                                        attachmentFileDisplay[index]["name"],
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Mulish',
                                                                                          fontSize: 12,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: Color(0xff202020),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Positioned(
                                                                                  left: 0,
                                                                                  top: 18,
                                                                                  child: Align(
                                                                                    child: SizedBox(
                                                                                      width: 50,
                                                                                      // height: 15,
                                                                                      child: Text(
                                                                                        attachmentFileDisplay[index]["mimetype"] == "application/pdf"
                                                                                            ? "PDF"
                                                                                            : attachmentFileDisplay[index]["mimetype"] == "application/msword"
                                                                                                ? "WORD"
                                                                                                : attachmentFileDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                                                                                    ? "EXCEL"
                                                                                                    : attachmentFileDisplay[index]["mimetype"] == "application/xml"
                                                                                                        ? "XML"
                                                                                                        : attachmentFileDisplay[index]["mimetype"] == "application/zip"
                                                                                                            ? "ZIP"
                                                                                                            : "",
                                                                                        style: TextStyle(
                                                                                          fontFamily: 'Mulish',
                                                                                          fontSize: 9,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Color(0xff666666),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 35),
                                                                            child:
                                                                                InkWell(
                                                                              child: Container(
                                                                                margin: EdgeInsets.fromLTRB(0, 0, 15, 1),
                                                                                width: 15,
                                                                                height: 16,
                                                                                child: Image.asset(
                                                                                  'images/logtrash.png',
                                                                                  width: 15,
                                                                                  height: 16,
                                                                                ),
                                                                              ),
                                                                              onTap: () async {
                                                                                int lodAttachmentId = attachmentFileDisplay[index]['id'];
                                                                                var data = await deleteLogAttachment(lodAttachmentId);

                                                                                if (data['message'] == "Success") {
                                                                                  print("jhbdndsjbv");
                                                                                  await getOpportunityDetails();
                                                                                  setState(() {
                                                                                    attachmentFileDisplay.clear();
                                                                                  });
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                                                              width: 14,
                                                                              height: 14,
                                                                              child: Image.asset(
                                                                                'images/logdownload.png',
                                                                                width: 14,
                                                                                height: 14,
                                                                              ),
                                                                            ),
                                                                            onTap:
                                                                                () async {
                                                                              await getExternalStorageDirectory();

                                                                              print(selectedImagesDisplay);
                                                                              print("dbjfnkdfbjsjfbdsvbkdsvkdj");

                                                                              String mimetypes = attachmentFileDisplay[index]['mimetype'];

                                                                              String itemName, itemNamefinal;

                                                                              itemName = attachmentFileDisplay[index]['name'];

                                                                              mimetypes == "application/pdf"
                                                                                  ? itemNamefinal = "${itemName}.pdf"
                                                                                  : mimetypes == "application/msword"
                                                                                      ? itemNamefinal = "${itemName}.doc"
                                                                                      : mimetypes == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                                                                          ? itemNamefinal = "${itemName}.xlsx"
                                                                                          : mimetypes == "application/xml"
                                                                                              ? itemNamefinal = "${itemName}.xml"
                                                                                              : mimetypes == "application/zip"
                                                                                                  ? itemNamefinal = "${itemName}.zip"
                                                                                                  : mimetypes == "image/jpeg"
                                                                                                      ? itemNamefinal = "${itemName}.jpeg"
                                                                                                      : mimetypes == "image/png"
                                                                                                          ? itemNamefinal = "${itemName}.png"
                                                                                                          : itemNamefinal = "${itemName}";

                                                                              FlutterDownloader.registerCallback(downloadCallback);

                                                                              requestPermission(itemNamefinal, attachmentFileDisplay[index]['url']);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 9,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            })
                                                        : Container(),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return Container();
                                            }
                                          }
                                        }
                                        return Center(
                                            child:
                                                const CircularProgressIndicator());
                                      }),
                                  TextButton(
                                      onPressed: () {
                                        myAlert("attachment");
                                      },
                                      child: Text(
                                        "Select Attachments",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Mulish'),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          //

                          // code for send message
                          Container(
                            width: mediaQueryData.size.width,
                            color: Color(0xFFf5f5f5),
                            //  color: Colors.red,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: followersVisibility,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, top: 10),
                                    child: Container(
                                      // color: Colors.red,
                                      child: Row(
                                        children: [
                                          Text(
                                            "To:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF666666),
                                              fontSize: 10,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                          Text(
                                            " Followers of",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF666666),
                                              fontSize: 10,
                                              fontFamily: 'Mulish',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25),
                                            child: Container(
                                                // color: Colors.green,
                                                width:
                                                    mediaQueryData.size.width /
                                                        1.5,
                                                child: Text(
                                                  opportunityname!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF414141),
                                                    fontSize: 10,
                                                    fontFamily: 'Mulish',
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: followersVisibility,
                                  child: Container(
                                    width: mediaQueryData.size.width,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: sendMailData.length,
                                      itemBuilder: (_, i) {
                                        isCheckedMail =
                                            sendMailData[i]['selected'];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Container(
                                            height: 15,
                                            child: Row(
                                              children: [
                                                Transform.scale(
                                                  scale: 0.7,
                                                  child: Checkbox(
                                                    shape: CircleBorder(),
                                                    activeColor:
                                                        Color(0xFF3D418E),
                                                    value: isCheckedMail,
                                                    onChanged: (bool? value) {
                                                      print(value);
                                                      print("check box issues");

                                                      String emails =
                                                          sendMailData[i]
                                                                  ['email'] ??
                                                              "";
                                                      value == true &&
                                                              sendMailData[i]
                                                                      ['id'] ==
                                                                  null
                                                          ? showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  _buildMailPopupDialog(
                                                                      context,
                                                                      0,
                                                                      emails),
                                                            ).then((value) =>
                                                              setState(() {
                                                                sendMailData[i]
                                                                        ['id'] =
                                                                    scheduleCustcreateId;
                                                              }))
                                                          : null;
                                                      setState(() {
                                                        print(
                                                            scheduleCustcreateId);
                                                        print(
                                                            "scheduleCustcreateId");

                                                        isCheckedMail = value!;
                                                        sendMailData[i]['id'] =
                                                            scheduleCustcreateId;
                                                        sendMailData[i]
                                                                ['selected'] =
                                                            value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 25),
                                                  child: Container(
                                                    width: mediaQueryData
                                                            .size.width /
                                                        1.3,
                                                    // color: Colors.red,
                                                    child: Text(
                                                      sendMailData[i]['name'],
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF666666),
                                                          fontSize: 11,
                                                          fontFamily: 'Mulish',
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: followersVisibility,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          salesperImg != ""
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 23),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        child: Image.network(
                                                            "${salesperImg!}?token=${token}"),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 23),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            //  color: Colors.green
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
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
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 25),
                                            child: Container(
                                              width: mediaQueryData.size.width /
                                                  1.3,
                                              //height: 46,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Color(0xFFFfffff),
                                                  border: Border.all(
                                                      color:
                                                          Color(0xFFEBEBEB))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: mediaQueryData
                                                            .size.width /
                                                        1.8,
                                                    // height: 40,
                                                    // color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: TextField(
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .top,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'Mulish',
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xFF000000),
                                                          ),
                                                          //expands: true,
                                                          maxLines: null,
                                                          controller:
                                                              lognoteController,
                                                          decoration: const InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: "Send a message to followers",
                                                              hintStyle: TextStyle(
                                                                  //fontFamily: "inter",
                                                                  fontWeight: FontWeight.w400,
                                                                  fontFamily: 'Mulish',
                                                                  fontSize: 11,
                                                                  color: Color(0xFFAFAFAF)))),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        recipient!.clear();
                                                        await defaultSendmsgvalues();
                                                        setState(() {
                                                          recipientsVisibility ==
                                                                  true
                                                              ? recipientsVisibility =
                                                                  false
                                                              : recipientsVisibility =
                                                                  true;
                                                        });

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              _buildSendmessagePopupDialog(
                                                                  context, 0),
                                                        ).then((value) =>
                                                            setState(() {}));
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .arrow_outward_rounded,
                                                        size: 18,
                                                        color:
                                                            Color(0xFFAFAFAF),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      selectedImages.isEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 73),
                                              child: Container(
                                                width:
                                                    mediaQueryData.size.width,
                                                // height: 40,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 70, right: 50, top: 5),
                                              child: Container(
                                                width:
                                                    mediaQueryData.size.width,
                                                // height: 40,
                                                child: Container(
                                                  width: 40,
                                                  //height: 40,
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    // Avoid scrolling
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        selectedImages.length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 8),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return selectedImages[
                                                                  index]
                                                              .path
                                                              .contains(".pdf")
                                                          ? Container(
                                                              width: 40,
                                                              height: 40,
                                                              color: Color(
                                                                  0xFFEF5350),
                                                              child: Icon(Icons
                                                                  .picture_as_pdf_sharp),
                                                            )
                                                          : selectedImages[
                                                                      index]
                                                                  .path
                                                                  .contains(
                                                                      ".zip")
                                                              ? Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  color: Color(
                                                                      0xFFFDD835),
                                                                  child: Icon(Icons
                                                                      .folder_zip_outlined),
                                                                )
                                                              : selectedImages[
                                                                          index]
                                                                      .path
                                                                      .contains(
                                                                          ".xlsx")
                                                                  ? Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      color: Color(
                                                                          0xFF4CAF50),
                                                                      child: Icon(
                                                                          Icons
                                                                              .clear),
                                                                    )
                                                                  : selectedImages[
                                                                              index]
                                                                          .path
                                                                          .contains(
                                                                              ".xml")
                                                                      ? Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          color:
                                                                              Color(0xFF0277BD),
                                                                          child:
                                                                              Icon(Icons.code_off),
                                                                        )
                                                                      : selectedImages[index]
                                                                              .path
                                                                              .contains(".doc")
                                                                          ? Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              color: Color(0xFF2196F3),
                                                                              child: Icon(Icons.article_outlined),
                                                                            )
                                                                          : Center(child: kIsWeb ? Image.network(selectedImages[index].path) : Image.file(selectedImages[index]));
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
                                                const EdgeInsets.only(left: 60),
                                            child: Container(
                                              child: IconButton(
                                                icon: Image.asset(
                                                    "images/pin.png"),
                                                onPressed: () {
                                                  myAlert("lognote");
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25, top: 3),
                                            child: SizedBox(
                                              //width: 270,
                                              width:MediaQuery.of(context).size.width/1.5,
                                              height: 30,
                                              child: ElevatedButton(
                                                  child: Center(
                                                    child: Text(
                                                      "Send Message",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: 'Mulish',
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  // Center(
                                                  //     child:SvgPicture.asset("images/sendd.svg")
                                                  //
                                                  //   // ),
                                                  // ),
                                                  onPressed: _isSavingData
                                                      ? null // Disable the button if saving is in progress
                                                      : () async {
                                                          setState(() {
                                                            _isSavingData =
                                                                true;
                                                          });
                                                          for (int i = 0;
                                                              i <
                                                                  selectedImages
                                                                      .length;
                                                              i++) {
                                                            imagepath =
                                                                selectedImages[
                                                                        i]
                                                                    .path
                                                                    .toString();
                                                            File imagefile = File(
                                                                imagepath); //convert Path to File
                                                            Uint8List
                                                                imagebytes =
                                                                await imagefile
                                                                    .readAsBytes(); //convert to bytes
                                                            base64string =
                                                                base64.encode(
                                                                    imagebytes);

                                                            String dataImages =
                                                                '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                                                            Map<String, dynamic>
                                                                jsondata =
                                                                jsonDecode(
                                                                    dataImages);
                                                            myData1
                                                                .add(jsondata);
                                                          }

                                                          bodyController.text =
                                                              lognoteController
                                                                  .text;

                                                          var resMessage;
                                                          followersVisibility ==
                                                                  false
                                                              ? resMessage =
                                                                  await logNoteData(
                                                                      myData1)
                                                              : resMessage =
                                                                  await createSendmessage(
                                                                      myData1);

                                                          if (resMessage[
                                                                  'message'] ==
                                                              "success") {
                                                            setState(() {
                                                              _isSavingData =
                                                                  false;
                                                              attachmentCount =
                                                                  resMessage['data']
                                                                          [
                                                                          'att_count']
                                                                      .toString();

                                                              logDataHeader
                                                                  .clear();
                                                              logDataTitle
                                                                  .clear();
                                                              if (selectedImagesDisplay !=
                                                                  null) {
                                                                selectedImagesDisplay
                                                                    .clear();
                                                              }

                                                              lognoteController
                                                                  .text = "";
                                                              selectedImages
                                                                  .clear();
                                                              myData1.clear();
                                                              bodyController
                                                                  .text = "";
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            });
                                                            postProvider
                                                                ?.fetchPosts(widget
                                                                    .opportunityId);
                                                            delayMethod();
                                                          }
                                                        },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color(0xFF043565),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: lognoteVisibility,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          salesperImg != ""
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 12,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        child: Image.network(
                                                            "${salesperImg!}?token=${token}"),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25),
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            //  color: Colors.green
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20))),
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
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 24),
                                            child: Container(
                                              width: mediaQueryData.size.width /
                                                  1.3,
                                              //height: 46,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Color(0xFFFfffff),
                                                  border: Border.all(
                                                      color:
                                                          Color(0xFFEBEBEB))),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: mediaQueryData
                                                            .size.width /
                                                        1.8,
                                                    // height: 40,
                                                    // color: Colors.red,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      child: TextField(
                                                          textAlignVertical:
                                                              TextAlignVertical
                                                                  .top,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'Mulish',
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xFF000000),
                                                          ),
                                                          //expands: true,
                                                          maxLines: null,
                                                          controller:
                                                              lognoteController,
                                                          decoration: const InputDecoration(
                                                              border: InputBorder.none,
                                                              hintText: "Log an internal note",
                                                              hintStyle: TextStyle(
                                                                  //fontFamily: "inter",
                                                                  fontWeight: FontWeight.w400,
                                                                  fontFamily: 'Mulish',
                                                                  fontSize: 11,
                                                                  color: Color(0xFFAFAFAF)))),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: IconButton(
                                                        onPressed: () async {
                                                          recipient!.clear();
                                                          await defaultSendmsgvalues();
                                                          setState(() {
                                                            recipientsVisibility ==
                                                                    false
                                                                ? recipientsVisibility =
                                                                    false
                                                                : recipientsVisibility =
                                                                    false;
                                                          });

                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _buildSendmessagePopupDialog(
                                                                    context, 0),
                                                          ).then((value) =>
                                                              setState(() {}));
                                                        },
                                                        icon: Icon(
                                                          Icons
                                                              .arrow_outward_rounded,
                                                          size: 18,
                                                          color:
                                                              Color(0xFFAFAFAF),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      selectedImages.isEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 73),
                                              child: Container(
                                                width:
                                                    mediaQueryData.size.width,
                                                // height: 40,
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 70, right: 50, top: 5),
                                              child: Container(
                                                width:
                                                    mediaQueryData.size.width,
                                                // height: 40,
                                                child: Container(
                                                  width: 40,
                                                  //height: 40,
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    // Avoid scrolling
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        selectedImages.length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 8),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return selectedImages[
                                                                  index]
                                                              .path
                                                              .contains(".pdf")
                                                          ? Container(
                                                              width: 40,
                                                              height: 40,
                                                              color: Color(
                                                                  0xFFEF5350),
                                                              child: Icon(Icons
                                                                  .picture_as_pdf_sharp),
                                                            )
                                                          : selectedImages[
                                                                      index]
                                                                  .path
                                                                  .contains(
                                                                      ".zip")
                                                              ? Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  color: Color(
                                                                      0xFFFDD835),
                                                                  child: Icon(Icons
                                                                      .folder_zip_outlined),
                                                                )
                                                              : selectedImages[
                                                                          index]
                                                                      .path
                                                                      .contains(
                                                                          ".xlsx")
                                                                  ? Container(
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      color: Color(
                                                                          0xFF4CAF50),
                                                                      child: Icon(
                                                                          Icons
                                                                              .clear),
                                                                    )
                                                                  : selectedImages[
                                                                              index]
                                                                          .path
                                                                          .contains(
                                                                              ".xml")
                                                                      ? Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          color:
                                                                              Color(0xFF0277BD),
                                                                          child:
                                                                              Icon(Icons.code_off),
                                                                        )
                                                                      : selectedImages[index]
                                                                              .path
                                                                              .contains(".doc")
                                                                          ? Container(
                                                                              width: 40,
                                                                              height: 40,
                                                                              color: Color(0xFF2196F3),
                                                                              child: Icon(Icons.article_outlined),
                                                                            )
                                                                          : Center(child: kIsWeb ? Image.network(selectedImages[index].path) : Image.file(selectedImages[index]));
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
                                                const EdgeInsets.only(left: 60),
                                            child: Container(
                                              child: IconButton(
                                                icon: Image.asset(
                                                    "images/pin.png"),
                                                onPressed: () {
                                                  myAlert("lognote");
                                                },
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 25, top: 3),
                                            child: SizedBox(
                                              //width: 270,
                                              width:MediaQuery.of(context).size.width/1.5,
                                              height: 30,
                                              child: ElevatedButton(
                                                  child: Center(
                                                    child: Text(
                                                      "Send Lognote",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: 'Mulish',
                                                          fontSize: 12,
                                                          color: Colors.white),
                                                    ),

                                                    // ),
                                                  ),
                                                  onPressed: _isSavingData
                                                      ? null // Disable the button if saving is in progress
                                                      : () async {
                                                          setState(() {
                                                            _isSavingData =
                                                                true;
                                                          });
                                                          for (int i = 0;
                                                              i <
                                                                  selectedImages
                                                                      .length;
                                                              i++) {
                                                            imagepath =
                                                                selectedImages[
                                                                        i]
                                                                    .path
                                                                    .toString();
                                                            File imagefile = File(
                                                                imagepath); //convert Path to File
                                                            Uint8List
                                                                imagebytes =
                                                                await imagefile
                                                                    .readAsBytes(); //convert to bytes
                                                            base64string =
                                                                base64.encode(
                                                                    imagebytes);

                                                            String dataImages =
                                                                '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                                                            Map<String, dynamic>
                                                                jsondata =
                                                                jsonDecode(
                                                                    dataImages);
                                                            myData1
                                                                .add(jsondata);
                                                          }

                                                          bodyController.text =
                                                              lognoteController
                                                                  .text;

                                                          var resMessage;
                                                          followersVisibility ==
                                                                  false
                                                              ? resMessage =
                                                                  await logNoteData(
                                                                      myData1)
                                                              : resMessage =
                                                                  await createSendmessage(
                                                                      myData1);

                                                          if (resMessage[
                                                                  'message'] ==
                                                              "success") {
                                                            setState(() {
                                                              _isSavingData =
                                                                  false;
                                                              attachmentCount =
                                                                  resMessage['data']
                                                                          [
                                                                          'att_count']
                                                                      .toString();

                                                              logDataHeader
                                                                  .clear();
                                                              logDataTitle
                                                                  .clear();
                                                              if (selectedImagesDisplay !=
                                                                  null) {
                                                                selectedImagesDisplay
                                                                    .clear();
                                                              }

                                                              lognoteController
                                                                  .text = "";
                                                              selectedImages
                                                                  .clear();
                                                              myData1.clear();
                                                              bodyController
                                                                  .text = "";

                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            });
                                                            postProvider
                                                                ?.fetchPosts(widget
                                                                    .opportunityId);
                                                            delayMethod();
                                                          }
                                                        },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Color(0xFF043565),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Visibility(
                            visible: scheduleLength == 0 ? false : true,
                            child: Container(
                              color: Color(0xFFffffff),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton.icon(
                                      // <-- TextButton
                                      onPressed: () {
                                        setState(() {
                                          scheduleActivityVisibility == true
                                              ? scheduleActivityVisibility =
                                                  false
                                              : scheduleActivityVisibility =
                                                  true;
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
                                          fontSize: 15,
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
                          ),

                          // code change for schedule activity

                          Visibility(
                            visible: scheduleActivityVisibility,
                            child: Container(
                              color: Color(0xFFf5f5f5),
                              //height: MediaQuery.of(context).size.height/1.8,

                              child: scheduleLength == 0
                                  ? Container()
                                  : ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: scheduleLength,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        scheduleData['records'][index]['icon'] ==
                                                "fa-envelope"
                                            ? scheduleIcon = const Icon(
                                                Icons.email_outlined,
                                                color: Colors.white,
                                                size: 8,
                                              )
                                            : scheduleData['records'][index]
                                                        ['icon'] ==
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
                                                        : scheduleData['records']
                                                                        [index]
                                                                    ['icon'] ==
                                                                "fa-line-chart"
                                                            ? scheduleIcon =
                                                                Icon(
                                                                Icons.bar_chart,
                                                                color: Colors
                                                                    .white,
                                                                size: 8,
                                                              )
                                                            : scheduleData['records']
                                                                            [index][
                                                                        'icon'] ==
                                                                    "fa-tasks"
                                                                ? scheduleIcon =
                                                                    Icon(
                                                                    Icons.task,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 8,
                                                                  )
                                                                : scheduleData['records'][index]
                                                                            ['icon'] ==
                                                                        "fa-upload"
                                                                    ? scheduleIcon = Icon(
                                                                        Icons
                                                                            .upload,
                                                                        color: Colors
                                                                            .white,
                                                                        size: 8,
                                                                      )
                                                                    : Icon(
                                                                        Icons
                                                                            .circle,
                                                                        color: Colors
                                                                            .white,
                                                                        size: 8,
                                                                      );

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              //padding: const EdgeInsets.all(25.0),
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    25, 0, 25, 5),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xffebebeb)),
                                                  color: Color(0xfffcfcfc),
                                                  // color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      width: mediaQueryData
                                                              .size.width /
                                                          1,
                                                      height: 40,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            //color:Colors.pink,
                                                            // ellipse121x7a (1112:1367)
                                                            margin: EdgeInsets
                                                                .fromLTRB(
                                                                    9, 0, 9, 2),
                                                            width: 25,
                                                            height: 25,
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                // scheduleData['records'][index]['delay_label'].toString() ?? ""
                                                                CircleAvatar(
                                                                  radius: 12,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    child: Image
                                                                        .network(
                                                                            "${scheduleData['records'][index]['image']!}?token=${token}"),
                                                                  ),
                                                                ),

                                                                Positioned(
                                                                  bottom: 0,
                                                                  right: 0,
                                                                  child:
                                                                      Container(
                                                                    width: 10.0,
                                                                    height:
                                                                        10.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Color(int.parse(scheduleData['records']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'label_color'])),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          scheduleIcon,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .fromLTRB(0,
                                                                      0, 9, 0),
                                                              width:
                                                                  mediaQueryData
                                                                          .size
                                                                          .width /
                                                                      1.3,
                                                              height: double
                                                                  .infinity,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    // autogrouprwrccT2 (7u5yPeGNvuuGAuKdPZrWrc)
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            1,
                                                                            1,
                                                                            2),
                                                                    width: mediaQueryData
                                                                            .size
                                                                            .width /
                                                                        2,
                                                                    height: double
                                                                        .infinity,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          // marcdemoLP2 (1112:1368)
                                                                          left:
                                                                              1,
                                                                          top:
                                                                              1,
                                                                          child:
                                                                              Align(
                                                                            child:
                                                                                Text(
                                                                              scheduleData['records'][index]['user_id'][1].toString() ?? "",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Mulish',
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                                // height: 1.255*ffem/fem,
                                                                                color: Color(0xff202020),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          // goodqag (1112:1369)
                                                                          left:
                                                                              2,
                                                                          top:
                                                                              15,
                                                                          child:
                                                                              Align(
                                                                            child:
                                                                                Text(
                                                                              scheduleData['records'][index]['note'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').toString() ?? "",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Mulish',
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.w500,
                                                                                //height: 1.255*ffem/fem,
                                                                                color: Color(0xff666666),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            1,
                                                                            0,
                                                                            2),
                                                                    //width: MediaQuery.of(context).size.width,
                                                                    width: mediaQueryData
                                                                            .size
                                                                            .width /
                                                                        4.29,
                                                                    //height: double.infinity,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Positioned(
                                                                          right:
                                                                              1,
                                                                          top:
                                                                              1,
                                                                          child:
                                                                              Align(
                                                                            child:
                                                                                Text(
                                                                              scheduleData['records'][index]['delay_label'].toString() ?? "",
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Mulish',
                                                                                  fontSize: 11,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  // height: 1.255*ffem/fem,
                                                                                  color: Color(int.parse(scheduleData['records'][index]['label_color']))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Positioned(
                                                                          // meetingzbz (1112:1394)
                                                                          right:
                                                                              1,
                                                                          top:
                                                                              15,
                                                                          child:
                                                                              Align(
                                                                            child:
                                                                                Text(
                                                                              scheduleData['records'][index]['activity_type_id'][1].toString() ?? "",
                                                                              textAlign: TextAlign.right,
                                                                              style: TextStyle(
                                                                                fontFamily: 'Mulish',
                                                                                fontSize: 11,
                                                                                fontWeight: FontWeight.w600,
                                                                                //  height: 1.255*ffem/fem,
                                                                                color: Color(0xff202020),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 6),
                                                      height: 1,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xffebebeb),
                                                      ),
                                                    ),
                                                    Container(
                                                      // color: Colors.green,
                                                      width: mediaQueryData
                                                          .size.width,
                                                      height: 30,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              height: double
                                                                  .infinity,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              10,
                                                                              0,
                                                                              2,
                                                                              0),
                                                                      // height: 14*fem,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          int datasIds =
                                                                              scheduleData['records'][index]['id'];

                                                                          showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (BuildContext context) =>
                                                                                _buildMarkDoneDialog(context, datasIds),
                                                                          ).then((value) =>
                                                                              setState(() {}));
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Container(
                                                                              // checkd2g (1112:1371)
                                                                              margin: EdgeInsets.fromLTRB(0, 0, 2, 0),
                                                                              width: 12,
                                                                              height: 12,
                                                                              child: Image.asset(
                                                                                'images/schedulecheck.png',
                                                                                width: 10,
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                              child: Text(
                                                                                scheduleData['records'][index]['buttons'][0].toString() ?? "",
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Mulish',
                                                                                  fontSize: 11,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  // height: 1.255*ffem/fem,
                                                                                  color: Color(0xff707070),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  scheduleData['records'][index]['buttons']
                                                                              [
                                                                              1] ==
                                                                          "Reschedule"
                                                                      ? Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Container(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                2,
                                                                                0,
                                                                                2,
                                                                                0),

                                                                            // height: double.infinity,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                DateTime dateTime = DateTime.parse(scheduleData['records'][index]['date_deadline']);

                                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => Calender(null, "", dateTime, null, [], "")));
                                                                              },
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    // iconsaxlinearcalendarPvx (1112:1377)
                                                                                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                                                                    width: 12,
                                                                                    height: 12,
                                                                                    child: Image.asset(
                                                                                      'images/schedulecalendar.png',
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    scheduleData['records'][index]['buttons'][1].toString() ?? "",
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Mulish',
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      color: Color(0xff707070),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          flex:
                                                                              2,
                                                                          child:
                                                                              Container(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                2,
                                                                                0,
                                                                                2,
                                                                                0),

                                                                            // height: double.infinity,
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () async {
                                                                                int idType = scheduleData['records'][index]['id'];

                                                                                var data = await editDefaultScheduleData(scheduleData['records'][index]['id']);

                                                                                setState(() {
                                                                                  activityTypeName = data['activity_type_id'] ?? null;
                                                                                  activityTypeId = data['activity_type_id']['id'] ?? null;
                                                                                  activityTypeNameCategory = data['activity_type_id']['category'] ?? "";
                                                                                  assignedToname = data['user_id'] ?? null;
                                                                                  assignedToid = data['user_id']['id'] ?? null;
                                                                                  DuedateTime.text = data['date_deadline'] ?? "";
                                                                                  summaryController.text = data['summary'] ?? "";
                                                                                  commandsController.text = data['note'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').toString();
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

                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) => _buildOrderPopupDialog(context, idType),
                                                                                ).then((value) => setState(() {}));
                                                                              },
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Container(
                                                                                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                                                                    width: 12,
                                                                                    height: 12,
                                                                                    child: Image.asset(
                                                                                      'images/scheduleedit.png',
                                                                                      width: 10,
                                                                                      height: 10,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    scheduleData['records'][index]['buttons'][1].toString() ?? "",
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Mulish',
                                                                                      fontSize: 11,
                                                                                      fontWeight: FontWeight.w500,
                                                                                      // height: 1.255*ffem/fem,
                                                                                      color: Color(0xff707070),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      // color:Colors.red,

                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              2,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                      //  height: double.infinity,
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          var data =
                                                                              await deleteScheduleData(scheduleData['records'][index]['id']);

                                                                          if (data['message'] ==
                                                                              "Success") {
                                                                            print("responce");
                                                                            setState(() {
                                                                              getScheduleDetails();
                                                                            });
                                                                          }

                                                                          print(
                                                                              "demo datataaa");
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: Container(
                                                                                margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                                                                width: 12,
                                                                                height: 12,
                                                                                child: Image.asset(
                                                                                  'images/schedulecancel.png',
                                                                                  width: 10,
                                                                                  height: 10,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: Text(
                                                                                scheduleData['records'][index]['buttons'][2].toString() ?? "",
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Mulish',
                                                                                  fontSize: 11,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  //height: 1.255*ffem/fem,
                                                                                  color: Color(0xff707070),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  VerticalDivider(),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        JustTheTooltip(
                                                                          margin: EdgeInsets.only(
                                                                              left: 25,
                                                                              right: 25),
                                                                          // showDuration:  const Duration(seconds: 10),
                                                                          preferredDirection:
                                                                              AxisDirection.up,
                                                                          isModal:
                                                                              true,
                                                                          child:
                                                                              Material(
                                                                            //color: Colors.grey.shade800,
                                                                            shape:
                                                                                const CircleBorder(),
                                                                            //elevation: 4.0,
                                                                            child:
                                                                                Container(
                                                                              // iconsaxlinearcalendarPvx (1112:1377)
                                                                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                                              width: 12,
                                                                              height: 12,
                                                                              child: Image.asset(
                                                                                'images/alertcircle.png',
                                                                                width: 10,
                                                                                height: 10,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          content:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 25, right: 25),
                                                                            height:
                                                                                165,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.only(top: 5, left: 9),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                children: [
                                                                                  Text(
                                                                                    "Activity type",
                                                                                    style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontFamily: 'Mulish',
                                                                                      color: Color(0xFF666666),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text(
                                                                                    scheduleData['records'][index]['activity_type_id'][1],
                                                                                    style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontFamily: 'Mulish',
                                                                                      color: Color(0xFF666666),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text(
                                                                                    "Created",
                                                                                    style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      fontFamily: 'Mulish',
                                                                                      color: Color(0xFF666666),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        scheduleData['records'][index]['create_date'].toString() ?? "",
                                                                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Mulish', color: Color(0xFF666666)),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Container(
                                                                                        child: CircleAvatar(
                                                                                          radius: 10,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(12),
                                                                                            child: Image.network("${scheduleData['records'][index]['image2']!}?token=${token}"),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Text(
                                                                                        scheduleData['records'][index]['create_uid'][1].toString() ?? "",
                                                                                        style: TextStyle(
                                                                                          fontSize: 11,
                                                                                          fontFamily: 'Mulish',
                                                                                          color: Color(0xFF666666),
                                                                                          fontWeight: FontWeight.w500,
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
                                                                                      fontSize: 11,
                                                                                      fontFamily: 'Mulish',
                                                                                      color: Color(0xFF666666),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        child: CircleAvatar(
                                                                                          radius: 10,
                                                                                          child: ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(18),
                                                                                            child: Image.network("${scheduleData['records'][index]['image']!}?token=${token}"),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Text(
                                                                                        scheduleData['records'][index]['user_id'][1].toString() ?? "",
                                                                                        style: TextStyle(fontSize: 11, fontFamily: 'Mulish', fontWeight: FontWeight.w500, color: Color(0xFF666666)),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text(
                                                                                    "Due on",
                                                                                    style: TextStyle(
                                                                                      fontSize: 11,
                                                                                      color: Color(0xFF666666),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                  Text(
                                                                                    scheduleData['records'][index]['date_deadline'].toString() ?? "",
                                                                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Mulish', color: Color(0xFF666666)),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 3,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
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
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                            ),
                          ),

                          SizedBox(
                            height: 0,
                          ),

                          // FutureBuilder(
                          //     future:  postProvider?.fetchPosts(widget.opportunityId),
                          //     builder: (context, snapshot) {
                          //       logDataHeader.clear();
                          //       logDataTitle.clear();
                          //       print(snapshot.hasData);
                          //       print("snapshot.data");
                          //       print("snap data final ");
                          //
                          //       if (snapshot.connectionState == ConnectionState.waiting) {
                          //         print("test1");
                          //         return Center(child: CircularProgressIndicator());
                          //       }
                          //       else {
                          //         if (snapshot.hasError) {
                          //           return Center(child: Text('Error: ${snapshot.error}'));
                          //         }
                          //         else{
                          //
                          //           if (postProvider?.posts.length != 0) {
                          //
                          //
                          //
                          //             return Consumer<PostProvideropportunity>(
                          //                 builder: (mcontext, provider, child) {
                          //
                          //                   logDataHeader.clear();
                          //                   logDataTitle.clear();
                          //                   if (provider != null ) {
                          //                     var postss = provider.posts;
                          //                     if(postss!=null){
                          //                       postss.forEach((key, value) {
                          //                         logDataHeader.add(key);
                          //                         logDataTitle.add(value);
                          //
                          //
                          //                       } );
                          //
                          //                     }
                          //                   }
                          //
                          //                   return ListView.builder(
                          //                       scrollDirection: Axis.vertical,
                          //                       physics: NeverScrollableScrollPhysics(),
                          //                       shrinkWrap: true,
                          //                       itemCount: logDataHeader.length,
                          //                       itemBuilder:
                          //                           (BuildContext context, int indexx) {
                          //                         return Column(
                          //                           children: [
                          //                             Padding(
                          //                               padding: const EdgeInsets.only(
                          //                                   top: 0, bottom: 0),
                          //                               child: Container(
                          //                                 width:mediaQueryData
                          //                                     .size
                          //                                     .width,
                          //                                 height: 42,
                          //                                 color: Color(0xff3D418E),
                          //                                 child: Center(
                          //                                     child: Text(
                          //                                       logDataHeader[indexx],
                          //                                       style: TextStyle(
                          //                                           fontWeight: FontWeight.w700,
                          //                                           fontSize: 12,
                          //                                           fontFamily: 'Mulish',
                          //                                           color: Colors.white),
                          //
                          //                                     )),
                          //                               ),
                          //                             ),
                          //                             ListView.builder(
                          //                                 scrollDirection: Axis.vertical,
                          //                                 physics:
                          //                                 NeverScrollableScrollPhysics(),
                          //                                 shrinkWrap: true,
                          //                                 itemCount:
                          //                                 logDataTitle[indexx].length,
                          //                                 itemBuilder:
                          //                                     (BuildContext context,
                          //                                     int indexs) {
                          //                                   selectedImagesDisplay =
                          //                                   logDataTitle[indexx][indexs]
                          //                                   ['attachment_ids'];
                          //
                          //                                   if (selectedImagesDisplay.length != 0) {
                          //                                     logattachmentImagesDisplay =
                          //                                     selectedImagesDisplay['images'];
                          //                                     logattachmentFileDisplay =
                          //                                     selectedImagesDisplay['files'];
                          //                                   }
                          //
                          //                                   print(logDataTitle[indexx]
                          //                                   [indexs]['attachment_ids']);
                          //
                          //                                   print(logDataTitle[indexx]
                          //                                   [indexs]['reaction_ids']);
                          //                                   print("hjvdbjsbdv");
                          //
                          //
                          //                                   List emojiSet =
                          //                                   logDataTitle[indexx][indexs]
                          //                                   ['reaction_ids'];
                          //
                          //                                   if (emojiSet.length > 0) {
                          //                                     print(emojiSet[0]['emoji']);
                          //                                     print(emojiSet[0]['count']);
                          //                                     print("fsvdsvdvdv");
                          //                                   }
                          //
                          //                                   print(emojiSet);
                          //                                   print("various hbfuhebin");
                          //                                   print(logDataTitle[indexx][indexs]
                          //                                   ['reaction_ids']);
                          //                                   print("hbfuhebin");
                          //
                          //                                   print("selectedImagesDisplaysss");
                          //
                          //                                   starImage = logDataTitle[indexx]
                          //                                   [indexs]['starred'] ??
                          //                                       false;
                          //                                   lognoteoptions =
                          //                                       logDataTitle[indexx][indexs]
                          //                                       ['is_editable'] ??
                          //                                           true;
                          //
                          //                                   print(logDataTitle[indexx]
                          //                                   [indexs]['is_editable']);
                          //
                          //                                   print('is_editable');
                          //
                          //                                   logDataTitle[indexx][indexs]
                          //                                   ['icon'] ==
                          //                                       "envelope"
                          //                                       ? logNoteIcon = const Icon(
                          //                                     Icons.email,
                          //                                     color: Colors.red,
                          //                                     size: 15,
                          //                                   )
                          //                                       : logDataTitle[indexx]
                          //                                   [indexs]
                          //                                   ['icon'] ==
                          //                                       "ad_units"
                          //                                       ? logNoteIcon = Icon(
                          //                                     Icons.phone,
                          //                                     color: Colors.red,
                          //                                     size: 15,
                          //                                   )
                          //                                       : logDataTitle[indexx]
                          //                                   [indexs]
                          //                                   ['icon'] ==
                          //                                       "telegram"
                          //                                       ? logNoteIcon =
                          //                                       Icon(
                          //                                         Icons.telegram,
                          //                                         color:
                          //                                         Colors.red,
                          //                                         size: 15,
                          //                                       )
                          //                                       : Icon(
                          //                                     Icons.circle,
                          //                                     color: Colors
                          //                                         .white,
                          //                                     size: 8,
                          //                                   );
                          //
                          //                                   return Card(
                          //                                     elevation: 1,
                          //                                     child: Column(
                          //                                       // crossAxisAlignment: CrossAxisAlignment.center,
                          //                                       mainAxisAlignment: MainAxisAlignment.center,
                          //                                       children: [
                          //                                         Container(
                          //                                           margin: EdgeInsets.only(top: 10,left: 24,right: 24),
                          //                                           width:mediaQueryData
                          //                                               .size
                          //                                               .width,
                          //                                           //height:80,
                          //                                           //  color: Colors.yellow,
                          //                                           child: Row(
                          //                                             crossAxisAlignment: CrossAxisAlignment
                          //                                                 .start,
                          //
                          //                                             children: [
                          //                                               Container(
                          //                                                 // group20507jZA (1636:7)
                          //                                                 padding: EdgeInsets.fromLTRB(
                          //                                                     25, 27, 3, 0),
                          //                                                 width: 35,
                          //                                                 height: 35,
                          //                                                 decoration: BoxDecoration(
                          //
                          //                                                   borderRadius: BorderRadius.circular(
                          //                                                       17.5),
                          //                                                   image: DecorationImage(
                          //                                                     fit: BoxFit.cover,
                          //                                                     image: NetworkImage(
                          //                                                         "${logDataTitle[indexx][indexs]['image']}?token=${token}"),
                          //                                                   ),
                          //                                                 ),
                          //                                                 child: Align(
                          //                                                   // ellipse123qs6 (1636:32)
                          //                                                   alignment: Alignment.bottomRight,
                          //                                                   child: SizedBox(
                          //                                                     width: double.infinity,
                          //                                                     height: 7,
                          //                                                     child: Container(
                          //                                                       decoration: BoxDecoration(
                          //                                                         borderRadius: BorderRadius
                          //                                                             .circular(3),
                          //                                                         border: Border.all(
                          //                                                             color: Color(0xffffffff)),
                          //                                                         color: Color(0xff167b33),
                          //                                                       ),
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //                                               ),
                          //                                               Expanded(
                          //                                                 child: Container(
                          //
                          //                                                   // autogroup8ggpMqS (D1Ah1azZTcaTxt74iV8ggp)
                          //                                                   padding: EdgeInsets.fromLTRB(
                          //                                                       19, 2, 2, 2),
                          //
                          //                                                   child: Row(
                          //                                                     crossAxisAlignment: CrossAxisAlignment
                          //                                                         .start,
                          //                                                     children: [
                          //                                                       Expanded(
                          //                                                         flex: 3,
                          //                                                         child: Container(
                          //                                                           //  color: Colors.blue,
                          //                                                           margin: EdgeInsets.fromLTRB(
                          //                                                               0, 0, 20, 0),
                          //                                                           // height: double.infinity,
                          //                                                           child: Column(
                          //                                                             crossAxisAlignment: CrossAxisAlignment
                          //                                                                 .start,
                          //                                                             mainAxisAlignment: MainAxisAlignment
                          //                                                                 .start,
                          //                                                             children: [
                          //                                                               Container(
                          //                                                                 // color:Colors.red,
                          //
                          //                                                                 margin: EdgeInsets
                          //                                                                     .fromLTRB(
                          //                                                                     0, 0, 0, 2),
                          //                                                                 child: RichText(
                          //                                                                   text: TextSpan(
                          //                                                                     style: TextStyle(
                          //                                                                       fontFamily: 'Mulish',
                          //                                                                       fontSize: 12,
                          //                                                                       fontWeight: FontWeight
                          //                                                                           .w700,
                          //                                                                       height: 0,
                          //                                                                       color: Color(
                          //                                                                           0xff000000),
                          //                                                                     ),
                          //                                                                     children: [
                          //                                                                       TextSpan(
                          //                                                                         text: logDataTitle[indexx][indexs]['create_uid'][1],
                          //                                                                         style: TextStyle(
                          //                                                                           fontFamily: 'Mulish',
                          //                                                                           fontSize: 11,
                          //                                                                           fontWeight: FontWeight
                          //                                                                               .w500,
                          //                                                                           height: 1,
                          //                                                                           color: Color(
                          //                                                                               0xff000000),
                          //
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                       TextSpan(
                          //                                                                         text: ' -',
                          //                                                                         style: TextStyle(
                          //                                                                           fontFamily: 'Mulish',
                          //                                                                           fontSize: 11,
                          //                                                                           fontWeight: FontWeight
                          //                                                                               .w500,
                          //                                                                           height: 1,
                          //                                                                           color: Color(
                          //                                                                               0xffa29d9d),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                       TextSpan(
                          //                                                                         text: ' ',
                          //                                                                         style: TextStyle(
                          //                                                                           fontFamily: 'Mulish',
                          //                                                                           fontSize: 11,
                          //                                                                           fontWeight: FontWeight
                          //                                                                               .w500,
                          //                                                                           height: 1,
                          //                                                                           color: Color(
                          //                                                                               0xff000000),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                       TextSpan(
                          //                                                                         text: logDataTitle[indexx][indexs]["period"],
                          //                                                                         style: TextStyle(
                          //                                                                           fontFamily: 'Mulish',
                          //                                                                           fontSize: 9,
                          //                                                                           fontWeight: FontWeight
                          //                                                                               .w500,
                          //                                                                           height: 1.5,
                          //                                                                           color: Color(
                          //                                                                               0xff948e8e),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ],
                          //                                                                   ),
                          //                                                                 ),
                          //                                                               ),
                          //                                                               Container(
                          //                                                                 // color:Colors.pink,
                          //                                                                 //height:60,
                          //                                                                 child: Text(
                          //
                          //
                          //                                                                   removeHtmlTagsAndSpaces(
                          //                                                                       logDataTitle[indexx][indexs]['body']
                          //                                                                           .toString() ??
                          //                                                                           ""),
                          //
                          //                                                                   // logDataTitle[indexx][indexs]['body'] .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                          //                                                                   //     .toString() ??
                          //                                                                   //     "",
                          //                                                                   style: TextStyle(
                          //                                                                     fontFamily: 'Mulish',
                          //                                                                     fontSize: 9,
                          //                                                                     fontWeight: FontWeight
                          //                                                                         .w600,
                          //                                                                     // height: 1.5,
                          //                                                                     color: Color(
                          //                                                                         0xff787878),
                          //                                                                   ),
                          //
                          //                                                                 ),
                          //                                                               ),
                          //
                          //
                          //                                                             ],
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //
                          //                                                       Expanded(
                          //                                                         flex: 1,
                          //                                                         child: Container(
                          //
                          //                                                           margin: EdgeInsets.fromLTRB(
                          //                                                               0, 0, 0, 1),
                          //                                                           width: 25,
                          //                                                           height: 20,
                          //                                                           child: Container(
                          //                                                               child: logNoteIcon),
                          //                                                         ),
                          //                                                       ),
                          //                                                       lognoteoptions == true
                          //                                                           ? Expanded(
                          //                                                         flex: 2,
                          //                                                         child: Container(
                          //                                                           padding: EdgeInsets.all(
                          //                                                               1.0),
                          //                                                           decoration: BoxDecoration(
                          //
                          //                                                             borderRadius: BorderRadius
                          //                                                                 .circular(5.0),
                          //                                                             // Specifies rounded corners
                          //                                                             border: Border.all(
                          //                                                               color: Color(
                          //                                                                   0XFFD9D9D9),
                          //                                                               // Border color
                          //
                          //                                                               width: 1.0, // Border width
                          //                                                             ),
                          //                                                           ),
                          //                                                           child: Row(
                          //                                                             children: [
                          //                                                               SizedBox(width: 3,),
                          //                                                               Expanded(
                          //                                                                 child: InkWell(
                          //                                                                   child: Container(
                          //                                                                     margin: EdgeInsets
                          //                                                                         .fromLTRB(
                          //                                                                         0, 0, 0, 1),
                          //                                                                     width: 13,
                          //                                                                     height: 13,
                          //                                                                     child: SvgPicture
                          //                                                                         .asset(
                          //                                                                       'images/emoji6.svg',
                          //                                                                       // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   onTap: () {
                          //                                                                     logDataIdEmoji =
                          //                                                                     logDataTitle[indexx][indexs]['id'];
                          //                                                                     showDialog(
                          //                                                                       context: context,
                          //                                                                       builder: (
                          //                                                                           BuildContext context) =>
                          //                                                                           _buildEmojiPopupDialog(
                          //                                                                               mcontext),
                          //                                                                     );
                          //                                                                   },
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(width: 5,),
                          //
                          //                                                               Expanded(
                          //
                          //                                                                 child: StatefulBuilder(
                          //                                                                     builder: (
                          //                                                                         BuildContext
                          //                                                                         context,
                          //                                                                         StateSetter
                          //                                                                         setState) {
                          //                                                                       return Container(
                          //                                                                           margin: EdgeInsets
                          //                                                                               .fromLTRB(
                          //                                                                               0, 0, 0,
                          //                                                                               1),
                          //                                                                           width: 13,
                          //                                                                           height: 13,
                          //                                                                           child: starImage ==
                          //                                                                               true
                          //                                                                               ? InkWell(
                          //                                                                             onTap: () async {
                          //                                                                               try{
                          //                                                                               int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //
                          //                                                                               var data = await logStarChange(
                          //                                                                                   lodDataId,
                          //                                                                                   false);
                          //
                          //                                                                               if (data['result']['message'] ==
                          //                                                                                   "success") {
                          //                                                                                 print(
                          //                                                                                     "startrue");
                          //                                                                                 setState(() {
                          //                                                                                   starImage =
                          //                                                                                   false;
                          //                                                                                 });
                          //                                                                               }
                          //                                                                               }catch(e){
                          //                                                                                 errorMethod(e);
                          //                                                                               }
                          //                                                                             },
                          //                                                                             child: SvgPicture
                          //                                                                                 .asset(
                          //                                                                               'images/st3.svg',
                          //                                                                               // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                             ),
                          //                                                                           )
                          //                                                                               : InkWell(
                          //                                                                             onTap: () async {
                          //                                                                               try{
                          //                                                                               int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //
                          //                                                                               var data = await logStarChange(
                          //                                                                                   lodDataId,
                          //                                                                                   true);
                          //
                          //                                                                               if (data['result']['message'] ==
                          //                                                                                   "success") {
                          //                                                                                 print(
                          //                                                                                     "starfalse");
                          //                                                                                 setState(() {
                          //                                                                                   starImage =
                          //                                                                                   true;
                          //                                                                                 });
                          //                                                                               }
                          //                                                                               }catch(e){
                          //                                                                                 errorMethod(e);
                          //                                                                               }
                          //
                          //                                                                             },
                          //                                                                             child: SvgPicture
                          //                                                                                 .asset(
                          //                                                                               'images/star6.svg',
                          //                                                                               // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                             ),
                          //                                                                           )
                          //                                                                       );
                          //                                                                     }
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(width: 5,),
                          //
                          //                                                               Expanded(
                          //                                                                 child: InkWell(
                          //                                                                   child: Container(
                          //                                                                     margin: EdgeInsets
                          //                                                                         .fromLTRB(
                          //                                                                         0, 0, 0, 1),
                          //                                                                     width: 13,
                          //                                                                     height: 13,
                          //                                                                     //color:Colors.red,
                          //                                                                     child: SvgPicture
                          //                                                                         .asset(
                          //                                                                       'images/edit6.svg',
                          //                                                                       // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   onTap: () {
                          //                                                                     int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //                                                                     String logdata = logDataTitle[indexx][indexs]['body']
                          //                                                                         .replaceAll(
                          //                                                                         RegExp(
                          //                                                                             r'<[^>]*>|&[^;]+;'),
                          //                                                                         ' ') ?? "";
                          //                                                                     // Navigator.push(
                          //                                                                     //     context,
                          //                                                                     //     MaterialPageRoute(
                          //                                                                     //         builder: (
                          //                                                                     //             context) =>
                          //                                                                     //             LogNoteEdit(
                          //                                                                     //                 lodDataId,
                          //                                                                     //                 salesperImg!,
                          //                                                                     //                 token!,
                          //                                                                     //                 widget
                          //                                                                     //                     .opportunityId,
                          //                                                                     //                 logdata,
                          //                                                                     //                 "crm.lead")));
                          //
                          //                                                                     selectedItemIndex =  lodDataId;
                          //                                                                     lognoteEditController.text = logdata;
                          //                                                                     postProvider?.fetchPosts(widget.opportunityId);
                          //                                                                   },
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(width: 5,),
                          //
                          //                                                               Expanded(
                          //                                                                 child: InkWell(
                          //                                                                   child: Container(
                          //                                                                     margin: EdgeInsets
                          //                                                                         .fromLTRB(
                          //                                                                         0, 0, 0, 1),
                          //                                                                     width: 13,
                          //                                                                     height: 13,
                          //                                                                     child: SvgPicture
                          //                                                                         .asset(
                          //                                                                       'images/delete6.svg',
                          //                                                                       // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   onTap: () async {
                          //                                                                     try{
                          //                                                                     int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //                                                                     var data = await deleteLogData(
                          //                                                                         lodDataId);
                          //
                          //                                                                     if (data['message'] ==
                          //                                                                         "Success") {
                          //                                                                       print("final11");
                          //                                                                       postProvider?.fetchPosts(widget.opportunityId);
                          //                                                                     }
                          //
                          //                                                                     }catch(e){
                          //                                                                       errorMethod(e);
                          //                                                                     }
                          //                                                                   },
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(width: 3,),
                          //                                                             ],
                          //                                                           ),
                          //                                                         ),
                          //                                                       )
                          //                                                           :
                          //                                                       Expanded(
                          //                                                         flex: 1,
                          //                                                         child: Container(
                          //                                                           padding: EdgeInsets.all(
                          //                                                               1.0),
                          //                                                           decoration: BoxDecoration(
                          //                                                             borderRadius: BorderRadius
                          //                                                                 .circular(5.0),
                          //                                                             // Specifies rounded corners
                          //                                                             border: Border.all(
                          //                                                               color: Color(
                          //                                                                   0XFFD9D9D9),
                          //                                                               // Border color
                          //                                                               width: 1.0, // Border width
                          //                                                             ),
                          //                                                           ),
                          //                                                           child: Row(
                          //                                                             children: [
                          //                                                               SizedBox(width: 3,),
                          //                                                               Expanded(
                          //                                                                 child: InkWell(
                          //                                                                   child: Container(
                          //                                                                     margin: EdgeInsets
                          //                                                                         .fromLTRB(
                          //                                                                         0, 0, 0, 1),
                          //                                                                     width: 13,
                          //                                                                     height: 13,
                          //                                                                     child: SvgPicture
                          //                                                                         .asset(
                          //                                                                       'images/emoji6.svg',
                          //                                                                       // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   onTap: () {
                          //                                                                     logDataIdEmoji =
                          //                                                                     logDataTitle[indexx][indexs]['id'];
                          //                                                                     showDialog(
                          //                                                                       context: context,
                          //                                                                       builder: (
                          //                                                                           BuildContext context) =>
                          //                                                                           _buildEmojiPopupDialog(
                          //                                                                               mcontext),
                          //                                                                     );
                          //                                                                   },
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(width: 5,),
                          //
                          //                                                               Expanded(
                          //
                          //                                                                 child: StatefulBuilder(
                          //                                                                     builder: (
                          //                                                                         BuildContext
                          //                                                                         context,
                          //                                                                         StateSetter
                          //                                                                         setState) {
                          //                                                                       return Container(
                          //                                                                           margin: EdgeInsets
                          //                                                                               .fromLTRB(
                          //                                                                               0, 0, 0,
                          //                                                                               1),
                          //                                                                           width: 13,
                          //                                                                           height: 13,
                          //                                                                           child: starImage ==
                          //                                                                               true
                          //                                                                               ? InkWell(
                          //                                                                             onTap: () async {
                          //                                                                               try{
                          //                                                                               int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //
                          //                                                                               var data = await logStarChange(
                          //                                                                                   lodDataId,
                          //                                                                                   false);
                          //
                          //                                                                               if (data['result']['message'] ==
                          //                                                                                   "success") {
                          //                                                                                 print(
                          //                                                                                     "startrue");
                          //                                                                                 setState(() {
                          //                                                                                   starImage =
                          //                                                                                   false;
                          //                                                                                 });
                          //                                                                               }
                          //                                                                               }catch(e){
                          //                                                                                 errorMethod(e);
                          //                                                                               }
                          //                                                                             },
                          //                                                                             child: SvgPicture
                          //                                                                                 .asset(
                          //                                                                               'images/st3.svg',
                          //                                                                               // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                             ),
                          //                                                                           )
                          //                                                                               : InkWell(
                          //                                                                             onTap: () async {
                          //                                                                               try{
                          //                                                                               int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //
                          //                                                                               var data = await logStarChange(
                          //                                                                                   lodDataId,
                          //                                                                                   true);
                          //
                          //                                                                               if (data['result']['message'] ==
                          //                                                                                   "success") {
                          //                                                                                 print(
                          //                                                                                     "starfalse");
                          //                                                                                 setState(() {
                          //                                                                                   starImage =
                          //                                                                                   true;
                          //                                                                                 });
                          //                                                                               }
                          //                                                                               }catch(e){
                          //                                                                                 errorMethod(e);
                          //                                                                               }
                          //                                                                             },
                          //                                                                             child: SvgPicture
                          //                                                                                 .asset(
                          //                                                                               'images/star6.svg',
                          //                                                                               // 'assets/page-1/images/group-20576.png',
                          //
                          //                                                                             ),
                          //                                                                           )
                          //                                                                       );
                          //                                                                     }
                          //                                                                 ),
                          //                                                               ),
                          //                                                               SizedBox(width: 3,),
                          //                                                               // SizedBox(width: 5,),
                          //                                                               //
                          //                                                               // Visibility(
                          //                                                               //   visible: lognoteoptions,
                          //                                                               //
                          //                                                               //   child: Expanded(
                          //                                                               //     child: InkWell(
                          //                                                               //       child: Container(
                          //                                                               //         margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                          //                                                               //         width: 13,
                          //                                                               //         height: 13,
                          //                                                               //         //color:Colors.red,
                          //                                                               //         child: SvgPicture.asset(
                          //                                                               //           'images/edit6.svg',
                          //                                                               //           // 'assets/page-1/images/group-20576.png',
                          //                                                               //
                          //                                                               //         ),
                          //                                                               //       ),
                          //                                                               //       onTap: (){
                          //                                                               //         int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //                                                               //         String logdata = logDataTitle[indexx][indexs]['body'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ') ?? "";
                          //                                                               //         Navigator.push(context, MaterialPageRoute(builder: (context) => LogNoteEdit(lodDataId, salesperImg!, token!, widget.leadId, logdata,"lead.lead")));
                          //                                                               //
                          //                                                               //       },
                          //                                                               //     ),
                          //                                                               //   ),
                          //                                                               // ),
                          //                                                               // SizedBox(width: 5,),
                          //                                                               //
                          //                                                               // Visibility(
                          //                                                               //   visible: lognoteoptions,
                          //                                                               //
                          //                                                               //   child: Expanded(
                          //                                                               //     child: InkWell(
                          //                                                               //       child: Container(
                          //                                                               //         margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                          //                                                               //         width: 13,
                          //                                                               //         height: 13,
                          //                                                               //         child: SvgPicture.asset(
                          //                                                               //           'images/delete6.svg',
                          //                                                               //           // 'assets/page-1/images/group-20576.png',
                          //                                                               //
                          //                                                               //         ),
                          //                                                               //       ),
                          //                                                               //       onTap: ()async{
                          //                                                               //         int lodDataId = logDataTitle[indexx][indexs]['id'];
                          //                                                               //         var data = await deleteLogData(lodDataId);
                          //                                                               //
                          //                                                               //         if (data['message'] == "Success") {
                          //                                                               //           print("final11");
                          //                                                               //           await getLeadDetails();
                          //                                                               //           setState(() {
                          //                                                               //             logDataHeader.clear();
                          //                                                               //             logDataTitle.clear();
                          //                                                               //             selectedImagesDisplay.clear();
                          //                                                               //           });
                          //                                                               //         }
                          //                                                               //       },
                          //                                                               //     ),
                          //                                                               //   ),
                          //                                                               // ),
                          //                                                               // SizedBox(width: 3,),
                          //                                                             ],
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                     ],
                          //                                                   ),
                          //                                                 ),
                          //                                               ),
                          //                                             ],
                          //                                           ),
                          //                                         ),
                          //
                          //                                         postProvider?.savefiles!=logDataTitle[indexx][indexs]['id']?
                          //                                         Visibility(
                          //                                           visible:  logDataTitle[indexx][indexs]['id'] == selectedItemIndex?true:false,
                          //                                           // visible: logDataTitle[indexx][indexs].lognoteEdit,
                          //                                           child: Container(
                          //                                             child: Column(
                          //                                               children: [
                          //                                                 Padding(
                          //                                                   padding: const EdgeInsets.only(
                          //                                                       left: 76, right: 25),
                          //                                                   child: Container(
                          //                                                     width: mediaQueryData
                          //                                                         .size
                          //                                                         .width ,
                          //
                          //                                                     // width:200,
                          //
                          //                                                     //height: 46,
                          //                                                     decoration: BoxDecoration(
                          //                                                         borderRadius: BorderRadius.all(
                          //                                                             Radius.circular(5)),
                          //                                                         color: Color(0xFFF6F6F6),
                          //                                                         border: Border.all(
                          //                                                           color: Color(0xFFEBEBEB),
                          //                                                         )),
                          //                                                     child: Row(
                          //                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                                                       children: [
                          //                                                         Container(
                          //                                                           width:mediaQueryData
                          //                                                               .size
                          //                                                               .width /
                          //                                                               1.92,
                          //
                          //                                                           // width:300,
                          //                                                           // height: 40,
                          //                                                           //color: Colors.red,
                          //                                                           child: Padding(
                          //                                                             padding: const EdgeInsets
                          //                                                                 .only(
                          //                                                                 left: 10),
                          //                                                             child:  Form(
                          //                                                               key: OpportunityDetail._editFormKey,
                          //                                                               child:  TextField(
                          //                                                                   textAlignVertical:
                          //                                                                   TextAlignVertical
                          //                                                                       .top,
                          //                                                                   style: TextStyle(
                          //                                                                     fontWeight: FontWeight
                          //                                                                         .w400,
                          //                                                                     fontFamily: 'Mulish',
                          //                                                                     fontSize: 11,
                          //                                                                     color: Color(
                          //                                                                         0xFF000000),
                          //                                                                   ),
                          //
                          //
                          //                                                                   maxLines: null,
                          //
                          //                                                                   // onChanged: (newValue) {
                          //                                                                   //   print("demodatatataadsaf");
                          //                                                                   //   // Handle text changes here if necessary
                          //                                                                   // },
                          //                                                                   controller:  lognoteEditController,
                          //
                          //                                                                   decoration:
                          //                                                                   const InputDecoration(
                          //                                                                       border:
                          //                                                                       InputBorder
                          //                                                                           .none,
                          //                                                                       hintText:
                          //                                                                       "Send a message to followers",
                          //                                                                       hintStyle: TextStyle(
                          //                                                                         //fontFamily: "inter",
                          //                                                                           fontWeight:
                          //                                                                           FontWeight
                          //                                                                               .w400,
                          //                                                                           fontFamily:
                          //                                                                           'Mulish',
                          //                                                                           fontSize: 11,
                          //                                                                           color: Color(
                          //                                                                               0xFFAFAFAF)))),
                          //                                                             ),
                          //                                                           ),
                          //                                                         ),
                          //                                                         Padding(
                          //                                                           padding: const EdgeInsets
                          //                                                               .only(left: 10),
                          //                                                           child: IconButton(
                          //                                                               onPressed: (){
                          //                                                                 myAlert("lognoteEdit");
                          //                                                                 postProvider?.fetchPosts(widget.opportunityId);
                          //                                                               },
                          //                                                               icon: Image.asset("images/pi.png")
                          //                                                           ),
                          //                                                         ),
                          //                                                       ],
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //
                          //
                          //                                                 selectedImagesEdit.isEmpty
                          //                                                     ? Padding(
                          //                                                   padding: const EdgeInsets.only(left: 73),
                          //                                                   child: Container(
                          //                                                     width:
                          //                                                     mediaQueryData
                          //                                                         .size
                          //                                                         .width,
                          //                                                     //width:400,
                          //                                                     //height: 40,
                          //                                                     //color: Colors.red,
                          //                                                   ),
                          //                                                 )
                          //                                                     : Padding(
                          //                                                   padding: const EdgeInsets.only(
                          //                                                       left: 70, right: 50, top: 5),
                          //                                                   child: Container(
                          //                                                     width:
                          //                                                     mediaQueryData
                          //                                                         .size
                          //                                                         .width,
                          //                                                     // width:400,
                          //                                                     // height: 40,
                          //                                                     child: Container(
                          //                                                       width: 40,
                          //                                                       //height: 40,
                          //                                                       child: GridView.builder(
                          //                                                         shrinkWrap: true,
                          //                                                         // Avoid scrolling
                          //                                                         physics:
                          //                                                         NeverScrollableScrollPhysics(),
                          //                                                         itemCount: selectedImagesEdit.length,
                          //                                                         gridDelegate:
                          //                                                         const SliverGridDelegateWithFixedCrossAxisCount(
                          //                                                             crossAxisCount: 8),
                          //                                                         itemBuilder: (BuildContext context,
                          //                                                             int index) {
                          //                                                           print("pdfffffffffff2");
                          //                                                           return selectedImagesEdit[index]
                          //                                                               .path
                          //                                                               .contains(".pdf")
                          //                                                               ? Container(
                          //                                                             width: 40,
                          //                                                             height: 40,
                          //                                                             color: Color(0xFFEF5350),
                          //                                                             child: Icon(Icons
                          //                                                                 .picture_as_pdf_sharp),
                          //                                                           )
                          //                                                               : selectedImagesEdit[index]
                          //                                                               .path
                          //                                                               .contains(".zip")
                          //                                                               ? Container(
                          //                                                             width: 40,
                          //                                                             height: 40,
                          //                                                             color:
                          //                                                             Color(0xFFFDD835),
                          //                                                             child: Icon(Icons
                          //                                                                 .folder_zip_outlined),
                          //                                                           )
                          //                                                               : selectedImagesEdit[index]
                          //                                                               .path
                          //                                                               .contains(".xlsx")
                          //                                                               ? Container(
                          //                                                             width: 40,
                          //                                                             height: 40,
                          //                                                             color: Color(
                          //                                                                 0xFF4CAF50),
                          //                                                             child: Icon(
                          //                                                                 Icons.clear),
                          //                                                           )
                          //                                                               : selectedImagesEdit[
                          //                                                           index]
                          //                                                               .path
                          //                                                               .contains(
                          //                                                               ".xml")
                          //                                                               ? Container(
                          //                                                             width: 40,
                          //                                                             height: 40,
                          //                                                             color: Color(
                          //                                                                 0xFF0277BD),
                          //                                                             child: Icon(Icons
                          //                                                                 .code_off),
                          //                                                           )
                          //                                                               : selectedImagesEdit[
                          //                                                           index]
                          //                                                               .path
                          //                                                               .contains(
                          //                                                               ".doc")
                          //                                                               ? Container(
                          //                                                             width: 40,
                          //                                                             height:
                          //                                                             40,
                          //                                                             color: Color(
                          //                                                                 0xFF2196F3),
                          //                                                             child: Icon(
                          //                                                                 Icons
                          //                                                                     .article_outlined),
                          //                                                           )
                          //                                                               : Center(
                          //                                                               child: kIsWeb
                          //                                                                   ? Image.network(
                          //                                                                   selectedImagesEdit[index]
                          //                                                                       .path)
                          //                                                                   : Image.file(
                          //                                                                   selectedImagesEdit[index]));
                          //                                                         },
                          //                                                       ),
                          //                                                     ),
                          //                                                   ),
                          //                                                 ),
                          //
                          //
                          //                                                 Padding(
                          //                                                   padding: const EdgeInsets.only(left:75),
                          //                                                   child: Row(
                          //                                                     children: [
                          //                                                       Text("escape to",style: TextStyle(color: Colors.grey),),
                          //                                                       InkWell(child: Container(child: Text("  cancel  ")),
                          //                                                         onTap: (){
                          //                                                           selectedItemIndex = -1;
                          //                                                           lognoteEditController.text= "";
                          //                                                           selectedImagesEdit.clear();
                          //                                                           myData1.clear();
                          //                                                           postProvider?.fetchPosts(widget.opportunityId);
                          //                                                         },
                          //                                                       ),
                          //                                                       //TextButton(onPressed:(){}, child: Text("cancel")),
                          //                                                       Text(","),
                          //                                                       Text("  enter to",style: TextStyle(color: Colors.grey),),
                          //                                                       InkWell(child: Container(child: Text("  save")),
                          //                                                           // onTap:_isSavingData
                          //                                                           //     ? null
                          //                                                           onTap :()async{
                          //
                          //
                          //                                                             int positionId= logDataTitle[indexx][indexs]['id'];
                          //                                                             postProvider?.fetchPosts1(positionId);
                          //
                          //
                          //
                          //                                                             for (int i = 0;
                          //                                                             i < selectedImagesEdit.length;
                          //                                                             i++) {
                          //                                                               imagepath =
                          //                                                                   selectedImagesEdit[i]
                          //                                                                       .path
                          //                                                                       .toString();
                          //                                                               File imagefile =
                          //                                                               File(imagepath);
                          //
                          //                                                               Uint8List imagebytes =
                          //                                                               await imagefile
                          //                                                                   .readAsBytes(); //convert to bytes
                          //                                                               base64string =
                          //                                                                   base64.encode(
                          //                                                                       imagebytes);
                          //
                          //                                                               //
                          //
                          //                                                               String dataImages =
                          //                                                                   '{"name":"name","type":"binary","datas":"${base64string
                          //                                                                   .toString()}"}';
                          //
                          //                                                               Map<String,
                          //                                                                   dynamic> jsondata =
                          //                                                               jsonDecode(dataImages);
                          //                                                               myData1.add(jsondata);
                          //                                                             }
                          //
                          //
                          //
                          //
                          //                                                             int lognoteId  = logDataTitle[indexx][indexs]['id'];
                          //                                                             String resMessage = await logNoteEditData(myData1,lognoteId);
                          //
                          //                                                             if(resMessage != 0){
                          //
                          //
                          //                                                               lognoteEditController.text= "";
                          //                                                               selectedImagesEdit.clear();
                          //                                                               myData1.clear();
                          //                                                               selectedItemIndex = -1;
                          //                                                               postProvider?.fetchPosts(widget.opportunityId);
                          //
                          //                                                               delayMethod();
                          //                                                             };
                          //                                                           }
                          //                                                       ),
                          //                                                       // TextButton(onPressed:(){}, child: Text("save")),
                          //                                                     ],
                          //                                                   ),
                          //                                                 )
                          //                                               ],
                          //                                             ),
                          //                                           ),
                          //                                         ):
                          //                                         Container(
                          //                                             width:20,
                          //                                             height:20,
                          //                                             child: CircularProgressIndicator()),
                          //
                          //
                          //
                          //                                         Container(
                          //
                          //                                           margin: EdgeInsets.only(top: 25,left: 24,right: 24),
                          //                                           //width: 350,
                          //                                           width:mediaQueryData.size.width,
                          //                                          // color:Colors.red,
                          //                                           // height: 450,
                          //                                           child: Column(
                          //                                             crossAxisAlignment: CrossAxisAlignment
                          //                                                 .start,
                          //                                             children: [
                          //
                          //                                               selectedImagesDisplay.length == 0 ?
                          //                                               Container() :
                          //                                               Column(
                          //                                                 children: [
                          //                                                   Container(
                          //                                                    // color: Colors.red,
                          //                                                     width:mediaQueryData
                          //                                                         .size
                          //                                                         .width,
                          //                                                     child: logattachmentImagesDisplay
                          //                                                         .length > 0 ? GridView
                          //                                                         .builder(
                          //                                                         shrinkWrap: true,
                          //                                                         // Avoid scrolling
                          //                                                         physics: NeverScrollableScrollPhysics(),
                          //                                                         itemCount: logattachmentImagesDisplay
                          //                                                             .length,
                          //                                                         // itemCount: 15,
                          //                                                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //                                                           crossAxisCount: 4,
                          //                                                           mainAxisSpacing: 1.0,
                          //                                                           crossAxisSpacing: 1.0,
                          //                                                           childAspectRatio: 1,
                          //                                                         ),
                          //                                                         itemBuilder: (
                          //                                                             BuildContext context,
                          //                                                             int index) {
                          //                                                           print(
                          //                                                               logattachmentImagesDisplay[index]["datas"]);
                          //                                                           print(
                          //                                                               "selectedImagesDisplay.length,");
                          //                                                           return Container(
                          //
                          //                                                             margin: EdgeInsets
                          //                                                                 .fromLTRB(
                          //                                                                 10, 0, 2, 0),
                          //                                                             width: 80,
                          //                                                             height: double.infinity,
                          //                                                             child: Stack(
                          //                                                               children: [
                          //                                                                 Positioned(
                          //                                                                   // rectangle4756kQ (1652:322)
                          //                                                                   left: 0,
                          //                                                                   top: 6,
                          //                                                                   child: Align(
                          //                                                                     child: SizedBox(
                          //                                                                       width: 75,
                          //                                                                       height: 71,
                          //                                                                       child: Container(
                          //                                                                         decoration: BoxDecoration(
                          //                                                                           borderRadius: BorderRadius
                          //                                                                               .circular(
                          //                                                                               3),
                          //                                                                           // color: Color(
                          //                                                                           //     0xffd9d9d9),
                          //                                                                           image: DecorationImage(
                          //                                                                             fit: BoxFit
                          //                                                                                 .cover,
                          //                                                                             image: NetworkImage(
                          //                                                                                 logattachmentImagesDisplay[index]["datas"]
                          //                                                                             ),
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 Positioned(
                          //                                                                   // group20514mrY (1652:323)
                          //                                                                   left: 60,
                          //                                                                   top: 0,
                          //                                                                   child: Align(
                          //                                                                     child: SizedBox(
                          //                                                                       width: 20,
                          //                                                                       height: 20,
                          //                                                                       child: Image
                          //                                                                           .asset(
                          //                                                                         'images/logimagedelete.png',
                          //                                                                         width: 20,
                          //                                                                         height: 20,
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //                                                                 Positioned(
                          //                                                                   // trash2G2c (1652:325)
                          //                                                                   left: 65,
                          //                                                                   top: 5,
                          //                                                                   child: Align(
                          //                                                                     child: InkWell(
                          //                                                                       onTap: () async {
                          //                                                                         int lodAttachmentId = logDataTitle[indexx][indexs]['attachment_ids']['images'][index]["id"];
                          //                                                                         var data = await deleteLogAttachment(
                          //                                                                             lodAttachmentId);
                          //
                          //                                                                         if (data['message'] ==
                          //                                                                             "Success") {
                          //                                                                           print(
                          //                                                                               "jhbdndsjbv");
                          //                                                                           // await getLeadDetails();
                          //                                                                           // setState(() {
                          //                                                                           //   logDataHeader
                          //                                                                           //       .clear();
                          //                                                                           //   logDataTitle
                          //                                                                           //       .clear();
                          //                                                                           //   selectedImagesDisplay
                          //                                                                           //       .clear();
                          //                                                                           // });
                          //                                                                           postProvider?.fetchPosts(widget.opportunityId);
                          //                                                                         }
                          //                                                                       },
                          //                                                                       child: SizedBox(
                          //                                                                         width: 9,
                          //                                                                         height: 10,
                          //                                                                         child: Image
                          //                                                                             .asset(
                          //                                                                           'images/logtrash.png',
                          //                                                                           width: 9,
                          //                                                                           height: 10,
                          //                                                                         ),
                          //                                                                       ),
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                 ),
                          //
                          //
                          //                                                               ],
                          //                                                             ),
                          //                                                           );
                          //                                                         }
                          //                                                     ) :
                          //                                                     Container(),
                          //                                                   ),
                          //
                          //                                                   SizedBox(height: 5),
                          //                                                   Container(
                          //                                                     width:mediaQueryData
                          //                                                         .size
                          //                                                         .width,
                          //                                                     child: logattachmentFileDisplay
                          //                                                         .length > 0 ? GridView
                          //                                                         .builder(
                          //                                                         shrinkWrap: true,
                          //                                                         // Avoid scrolling
                          //                                                         physics: NeverScrollableScrollPhysics(),
                          //                                                         itemCount: logattachmentFileDisplay
                          //                                                             .length,
                          //                                                         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //                                                           crossAxisCount: 1,
                          //                                                           //mainAxisSpacing: 5.0,
                          //                                                           crossAxisSpacing: 1.0,
                          //                                                           childAspectRatio: 5.5,
                          //                                                         ),
                          //                                                         itemBuilder: (
                          //                                                             BuildContext context,
                          //                                                             int index) {
                          //                                                           return
                          //                                                             Container(
                          //                                                               margin: EdgeInsets
                          //                                                                   .fromLTRB(
                          //                                                                   10, 0, 0, 2),
                          //                                                               // group20585QEc (1652:502)
                          //                                                               width: double.infinity,
                          //                                                               child: Column(
                          //                                                                 crossAxisAlignment: CrossAxisAlignment
                          //                                                                     .center,
                          //                                                                 children: [
                          //                                                                   Container(
                          //                                                                     // group20565Yrc (1652:364)
                          //                                                                     padding: EdgeInsets
                          //                                                                         .fromLTRB(
                          //                                                                         14, 11, 18,
                          //                                                                         9),
                          //                                                                     width: double
                          //                                                                         .infinity,
                          //                                                                     height: 52,
                          //                                                                     decoration: BoxDecoration(
                          //                                                                       border: Border
                          //                                                                           .all(
                          //                                                                           color: Color(
                          //                                                                               0xffebebeb)),
                          //                                                                       borderRadius: BorderRadius
                          //                                                                           .circular(
                          //                                                                           6),
                          //                                                                     ),
                          //                                                                     child: Row(
                          //                                                                       crossAxisAlignment: CrossAxisAlignment
                          //                                                                           .center,
                          //                                                                       children: [
                          //                                                                         Container(
                          //                                                                           // pdffile21FW8 (1652:378)
                          //                                                                           margin: EdgeInsets
                          //                                                                               .fromLTRB(
                          //                                                                               0, 0,
                          //                                                                               12, 0),
                          //                                                                           width: 23,
                          //                                                                           height: 29,
                          //                                                                           child: Image
                          //                                                                               .asset(
                          //                                                                             logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                 "application/pdf"
                          //                                                                                 ? 'images/logpdf.png'
                          //                                                                                 : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                 "application/msword"
                          //                                                                                 ? 'images/logword.png'
                          //                                                                                 : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                 "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                          //                                                                                 ? 'images/logexcel.png'
                          //                                                                                 : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                 "application/xml"
                          //                                                                                 ? 'images/logxml.png'
                          //                                                                                 : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                 "application/zip"
                          //                                                                                 ? 'images/logzip.png'
                          //                                                                                 : '',
                          //
                          //
                          //                                                                             width: 23,
                          //                                                                             height: 29,
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         Container(
                          //
                          //                                                                           width:mediaQueryData
                          //                                                                               .size
                          //                                                                               .width /
                          //                                                                               2,
                          //                                                                           //height: double.infinity,
                          //                                                                           child: Stack(
                          //                                                                             children: [
                          //                                                                               Positioned(
                          //                                                                                 // pdfnamearea1tc (1652:376)
                          //                                                                                 left: 0,
                          //                                                                                 top: 00,
                          //                                                                                 child: Align(
                          //                                                                                   child: SizedBox(
                          //                                                                                     width:mediaQueryData
                          //                                                                                         .size
                          //                                                                                         .width /
                          //                                                                                         2,
                          //                                                                                     child: Text(
                          //                                                                                       logattachmentFileDisplay[index]["name"],
                          //                                                                                       style: TextStyle(
                          //                                                                                         fontFamily: 'Mulish',
                          //                                                                                         fontSize: 12,
                          //                                                                                         fontWeight: FontWeight
                          //                                                                                             .w600,
                          //                                                                                         color: Color(
                          //                                                                                             0xff202020),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                               Positioned(
                          //                                                                                 // pdfuDJ (1652:377)
                          //                                                                                 left: 0,
                          //                                                                                 top: 18,
                          //                                                                                 child: Align(
                          //                                                                                   child: SizedBox(
                          //                                                                                     width: 50,
                          //                                                                                     // height: 15,
                          //                                                                                     child: Text(
                          //                                                                                       logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                           "application/pdf"
                          //                                                                                           ?
                          //                                                                                       "PDF"
                          //                                                                                           : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                           "application/msword"
                          //                                                                                           ?
                          //                                                                                       "WORD"
                          //                                                                                           : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                           "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                          //                                                                                           ?
                          //                                                                                       "EXCEL"
                          //                                                                                           : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                           "application/xml"
                          //                                                                                           ?
                          //                                                                                       "XML"
                          //                                                                                           : logattachmentFileDisplay[index]["mimetype"] ==
                          //                                                                                           "application/zip"
                          //                                                                                           ?
                          //                                                                                       "ZIP"
                          //                                                                                           : "",
                          //
                          //                                                                                       style: TextStyle(
                          //                                                                                         fontFamily: 'Mulish',
                          //                                                                                         fontSize: 9,
                          //                                                                                         fontWeight: FontWeight
                          //                                                                                             .w500,
                          //
                          //                                                                                         color: Color(
                          //                                                                                             0xff666666),
                          //                                                                                       ),
                          //                                                                                     ),
                          //                                                                                   ),
                          //                                                                                 ),
                          //                                                                               ),
                          //                                                                             ],
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         Spacer(),
                          //                                                                         Container(
                          //
                          //                                                                           child: InkWell(
                          //                                                                             child: Container(
                          //                                                                               // trash2Qvk (1652:366)
                          //                                                                               margin: EdgeInsets
                          //                                                                                   .fromLTRB(
                          //                                                                                   0,
                          //                                                                                   0,
                          //                                                                                   15,
                          //                                                                                   1),
                          //                                                                               width: 15,
                          //                                                                               height: 16,
                          //                                                                               child: Image
                          //                                                                                   .asset(
                          //                                                                                 'images/logtrash.png',
                          //                                                                                 width: 15,
                          //                                                                                 height: 16,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             onTap: () async {
                          //                                                                               int lodAttachmentId = logDataTitle[indexx][indexs]['attachment_ids']['files'][index]["id"];
                          //                                                                               var data = await deleteLogAttachment(
                          //                                                                                   lodAttachmentId);
                          //
                          //                                                                               if (data['message'] ==
                          //                                                                                   "Success") {
                          //                                                                                 print(
                          //                                                                                     "jhbdndsjbv");
                          //                                                                                 // await getLeadDetails();
                          //                                                                                 // setState(() {
                          //                                                                                 //   logDataHeader
                          //                                                                                 //       .clear();
                          //                                                                                 //   logDataTitle
                          //                                                                                 //       .clear();
                          //                                                                                 //   selectedImagesDisplay
                          //                                                                                 //       .clear();
                          //                                                                                 // });
                          //                                                                                 postProvider?.fetchPosts(widget.opportunityId);
                          //                                                                               }
                          //                                                                             },
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                         Container(
                          //                                                                           child: InkWell(
                          //                                                                             child: Container(
                          //                                                                               // download6oa (1652:371)
                          //                                                                               margin: EdgeInsets
                          //                                                                                   .fromLTRB(
                          //                                                                                   0,
                          //                                                                                   0,
                          //                                                                                   0,
                          //                                                                                   2),
                          //                                                                               width: 14,
                          //                                                                               height: 14,
                          //                                                                               child: Image
                          //                                                                                   .asset(
                          //                                                                                 'images/logdownload.png',
                          //                                                                                 width: 14,
                          //                                                                                 height: 14,
                          //                                                                               ),
                          //                                                                             ),
                          //                                                                             onTap: () {
                          //                                                                               String mimetypes = logDataTitle[indexx][indexs]['attachment_ids']['files'][index]["mimetype"];
                          //                                                                               //String mimetypes = "application/pdf";
                          //
                          //                                                                               String itemName,
                          //                                                                                   itemNamefinal;
                          //
                          //                                                                               itemName =
                          //                                                                               logDataTitle[indexx][indexs]['attachment_ids']['files'][index]["name"];
                          //
                          //                                                                               mimetypes ==
                          //                                                                                   "application/pdf"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.pdf"
                          //                                                                                   : mimetypes ==
                          //                                                                                   "application/msword"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.doc"
                          //                                                                                   : mimetypes ==
                          //                                                                                   "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.xlsx"
                          //                                                                                   : mimetypes ==
                          //                                                                                   "application/xml"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.xml"
                          //                                                                                   : mimetypes ==
                          //                                                                                   "application/zip"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.zip"
                          //                                                                                   : mimetypes ==
                          //                                                                                   "image/jpeg"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.jpeg"
                          //                                                                                   : mimetypes ==
                          //                                                                                   "image/png"
                          //                                                                                   ?
                          //                                                                               itemNamefinal =
                          //                                                                               "${itemName}.png"
                          //                                                                                   : itemNamefinal =
                          //                                                                               "${itemName}";
                          //
                          //                                                                               print(
                          //                                                                                   index);
                          //
                          //                                                                               print(
                          //                                                                                   logattachmentFileDisplay);
                          //
                          //                                                                               print(
                          //                                                                                   itemNamefinal);
                          //                                                                               print(
                          //                                                                                   mimetypes);
                          //                                                                               print(
                          //                                                                                   "final print dataaa");
                          //
                          //                                                                               FlutterDownloader
                          //                                                                                   .registerCallback(
                          //                                                                                   downloadCallback);
                          //
                          //                                                                               requestPermission(
                          //                                                                                   itemNamefinal,
                          //                                                                                   logDataTitle[indexx][indexs]['attachment_ids']['files'][index]["datas"]);
                          //                                                                               postProvider?.fetchPosts(widget.opportunityId);
                          //
                          //                                                                             },
                          //                                                                           ),
                          //                                                                         ),
                          //                                                                       ],
                          //                                                                     ),
                          //                                                                   ),
                          //                                                                   SizedBox(
                          //                                                                     height: 9,
                          //                                                                   ),
                          //
                          //
                          //                                                                 ],
                          //                                                               ),
                          //                                                             );
                          //                                                         }
                          //                                                     ) :
                          //                                                     Container(),
                          //                                                   ),
                          //
                          //                                                 ],
                          //                                               ),
                          //                                               emojiSet.length > 0 ?
                          //                                               Container(
                          //                                                 width:mediaQueryData
                          //                                                     .size
                          //                                                     .width,
                          //
                          //                                                 child: GridView.builder(
                          //                                                     shrinkWrap: true,
                          //                                                     // Avoid scrolling
                          //                                                     physics: NeverScrollableScrollPhysics(),
                          //                                                     itemCount: emojiSet.length,
                          //                                                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          //                                                       crossAxisCount: 6,
                          //                                                       mainAxisSpacing: 5.0,
                          //                                                       crossAxisSpacing: 5.0,
                          //                                                       childAspectRatio: 2.1,
                          //                                                     ),
                          //                                                     itemBuilder: (
                          //                                                         BuildContext context,
                          //                                                         int index) {
                          //                                                       return InkWell(
                          //
                          //                                                           child: Container(
                          //
                          //                                                             margin: EdgeInsets
                          //                                                                 .fromLTRB(
                          //                                                                 10, 0, 0, 2),
                          //                                                             // width: 40,
                          //                                                             height: 15,
                          //                                                             decoration: BoxDecoration(
                          //                                                                 color: Colors.white,
                          //                                                                 borderRadius: BorderRadius
                          //                                                                     .all(
                          //                                                                     Radius.circular(
                          //                                                                         3)),
                          //                                                                 border: Border.all(
                          //                                                                     color: Color(
                          //                                                                         0XFFEBEBEB),
                          //
                          //                                                                     width: 1)),
                          //                                                             // color: Colors.red,
                          //                                                             child: Row(
                          //
                          //                                                               children: [
                          //                                                                 Padding(
                          //                                                                   padding: const EdgeInsets
                          //                                                                       .only(left: 5),
                          //                                                                   child: Container(
                          //                                                                     // width:18,
                          //                                                                       height: 19,
                          //                                                                       child: Text(
                          //                                                                           emojiSet[index]['emoji'])),
                          //                                                                 ),
                          //                                                                 SizedBox(width: 3),
                          //
                          //                                                                 Text(
                          //                                                                   emojiSet[index]['count']
                          //                                                                       .toString(),
                          //                                                                   style: TextStyle(
                          //                                                                       fontSize: 10
                          //                                                                   ),),
                          //                                                               ],
                          //                                                             ),
                          //                                                           ),
                          //                                                           onTap: () async {
                          //                                                             var data = await deleteEmoji(
                          //                                                                 emojiSet[index]['emoji'],
                          //                                                                 logDataTitle[indexx][indexs]['id']);
                          //
                          //                                                             if (data['result']['message'] ==
                          //                                                                 "success") {
                          //                                                               postProvider?.fetchPosts(widget.opportunityId);
                          //
                          //                                                             }
                          //                                                           }
                          //                                                       );
                          //                                                     }
                          //                                                 ),
                          //                                               ) :
                          //                                               Container(),
                          //                                             ],
                          //                                           ),
                          //                                         ),
                          //
                          //                                       ],
                          //                                     ),
                          //                                   );
                          //                                 })
                          //                           ],
                          //                         );
                          //                       });
                          //
                          //                 } );
                          //
                          //
                          //
                          //           } else {
                          //             return Container();
                          //           }
                          //         }
                          //
                          //
                          //
                          //       }
                          //
                          //
                          //       return Center(
                          //           child: const CircularProgressIndicator());
                          //
                          //
                          //     }),

                          postProvider?.posts != null
                              ? Consumer<PostProvideropportunity>(
                                  builder: (mcontext, provider, child) {
                                  return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: postProvider?.posts.length ?? 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var entry = postProvider?.posts.entries
                                          .elementAt(index);

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            child: Container(
                                              width: mediaQueryData.size.width,
                                              height: 42,
                                              color: Color(0xffffffff),
                                              child: Center(
                                                  child: Text(
                                                entry.key,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                    fontFamily: 'Mulish',
                                                    color: Color(0xFF212121)),
                                              )),
                                            ),
                                          ),
                                          Column(
                                            children:
                                                entry.value.map<Widget>((item) {
                                              return ListView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      entry.key[index].length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int indexs) {
                                                    print(indexs);
                                                    print(entry.value.length);
                                                    print("logitemss");
                                                    print(item['body']);
                                                    print(
                                                        item['attachment_ids']);

                                                    selectedImagesDisplay =
                                                        item['attachment_ids'];

                                                    if (selectedImagesDisplay
                                                            .length !=
                                                        0) {
                                                      logattachmentImagesDisplay =
                                                          selectedImagesDisplay[
                                                              'images'];
                                                      logattachmentFileDisplay =
                                                          selectedImagesDisplay[
                                                              'files'];
                                                    }

                                                    print(
                                                        item['attachment_ids']);

                                                    print(item['reaction_ids']);
                                                    print("hjvdbjsbdv");

                                                    List emojiSet =
                                                        item['reaction_ids'];

                                                    if (emojiSet.length > 0) {
                                                      print(
                                                          emojiSet[0]['emoji']);
                                                      print(
                                                          emojiSet[0]['count']);
                                                      print("fsvdsvdvdv");
                                                    }

                                                    print(emojiSet);
                                                    print("various hbfuhebin");
                                                    print(item['reaction_ids']);
                                                    print("hbfuhebin");

                                                    print(
                                                        "selectedImagesDisplaysss");

                                                    starImage =
                                                        item['starred'] ??
                                                            false;
                                                    lognoteoptions =
                                                        item['is_editable'] ??
                                                            true;

                                                    print(item['is_editable']);

                                                    print('is_editable');

                                                    item['icon'] == "envelope"
                                                        ? logNoteIcon =
                                                            const Icon(
                                                            Icons.email,
                                                            color: Colors.red,
                                                            size: 15,
                                                          )
                                                        : item['icon'] ==
                                                                "ad_units"
                                                            ? logNoteIcon =
                                                                Icon(
                                                                Icons.phone,
                                                                color:
                                                                    Colors.red,
                                                                size: 15,
                                                              )
                                                            : item['icon'] ==
                                                                    "telegram"
                                                                ? logNoteIcon =
                                                                    Icon(
                                                                    Icons
                                                                        .telegram,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 15,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 8,
                                                                  );

                                                    return Card(
                                                      color: Color(0xFFF5F5F5),
                                                      // elevation: 1,
                                                      child: Column(
                                                        // crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    left: 24,
                                                                    right: 24),
                                                            width:
                                                                mediaQueryData
                                                                    .size.width,
                                                            //height:80,
                                                            //  color: Colors.yellow,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [

                                                                // item['image']==""?
                                                                Container(
                                                                  // group20507jZA (1636:7)
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          25,
                                                                          27,
                                                                          3,
                                                                          0),
                                                                  width: 35,
                                                                  height: 35,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            17.5),
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: NetworkImage(
                                                                          "${item['image']}?token=${token}"),
                                                                    ),
                                                                  ),
                                                                  child: Align(
                                                                    // ellipse123qs6 (1636:32)
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    child:
                                                                        SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      height: 7,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(3),
                                                                          border:
                                                                              Border.all(color: Color(0xffffffff)),
                                                                          color:
                                                                              Color(0xff167b33),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                // Stack(
                                                                //   children: [
                                                                //     Container(
                                                                //
                                                                //       width: 35,
                                                                //       height:
                                                                //       35,
                                                                //       decoration:
                                                                //       BoxDecoration(
                                                                //         color: Colors
                                                                //             .blue, // Replace with your desired background color
                                                                //         shape: BoxShape
                                                                //             .circle,
                                                                //       ),
                                                                //       child:
                                                                //       Center(
                                                                //         child:
                                                                //         Text(
                                                                //
                                                                //           item['create_uid'][1][0],
                                                                //           style:
                                                                //           TextStyle(
                                                                //             color:
                                                                //             Colors.white,
                                                                //             fontWeight:
                                                                //             FontWeight.bold,
                                                                //             fontSize:
                                                                //             18,
                                                                //           ),
                                                                //         ),
                                                                //       ),
                                                                //     ),
                                                                //     Positioned(
                                                                //       bottom: 0,
                                                                //       right: 5,
                                                                //       child:
                                                                //       Container(
                                                                //         width:
                                                                //         7,
                                                                //         height:
                                                                //         7,
                                                                //         decoration:
                                                                //         BoxDecoration(
                                                                //           borderRadius:
                                                                //           BorderRadius.circular(3),
                                                                //           border:
                                                                //           Border.all(color: Color(0xffffffff)),
                                                                //           color:
                                                                //           Color(0xff167b33),
                                                                //         ),
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // ),



                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    // autogroup8ggpMqS (D1Ah1azZTcaTxt74iV8ggp)
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            19,
                                                                            2,
                                                                            2,
                                                                            2),

                                                                    child: Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Container(
                                                                            //  color: Colors.blue,
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                0,
                                                                                20,
                                                                                0),
                                                                            // height: double.infinity,
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  // color:Colors.red,

                                                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                                                                  child: RichText(
                                                                                    text: TextSpan(
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Mulish',
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        height: 0,
                                                                                        color: Color(0xff000000),
                                                                                      ),
                                                                                      children: [
                                                                                        TextSpan(
                                                                                          text: item['create_uid'][1],
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Mulish',
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            height: 1,
                                                                                            color: Color(0xff000000),
                                                                                          ),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: ' -',
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Mulish',
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            height: 1,
                                                                                            color: Color(0xffa29d9d),
                                                                                          ),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: ' ',
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Mulish',
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            height: 1,
                                                                                            color: Color(0xff000000),
                                                                                          ),
                                                                                        ),
                                                                                        TextSpan(
                                                                                          text: item["period"],
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Mulish',
                                                                                            fontSize: 9,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            height: 1.5,
                                                                                            color: Color(0xff948e8e),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  // color:Colors.pink,
                                                                                  //height:60,
                                                                                  child: Text(
                                                                                    removeHtmlTagsAndSpaces(item['body'].toString() ?? ""),

                                                                                    // logDataTitle[indexx][indexs]['body'] .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                                                                                    //     .toString() ??
                                                                                    //     "",
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Mulish',
                                                                                      fontSize: 9,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      // height: 1.5,
                                                                                      color: Color(0xff787878),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                1),
                                                                            width:
                                                                                25,
                                                                            height:
                                                                                20,
                                                                            child:
                                                                                Container(child: logNoteIcon),
                                                                          ),
                                                                        ),
                                                                        lognoteoptions ==
                                                                                true
                                                                            ? Expanded(
                                                                                flex: 2,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(1.0),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                                    // Specifies rounded corners
                                                                                    border: Border.all(
                                                                                      color: Color(0XFFD9D9D9),
                                                                                      // Border color

                                                                                      width: 1.0, // Border width
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: InkWell(
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                            width: 13,
                                                                                            height: 13,
                                                                                            child: SvgPicture.asset(
                                                                                              'images/emoji6.svg',
                                                                                              // 'assets/page-1/images/group-20576.png',
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {
                                                                                            logDataIdEmoji = item['id'];
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) => _buildEmojiPopupDialog(mcontext),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                                                          return Container(
                                                                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                              width: 13,
                                                                                              height: 13,
                                                                                              child: starImage == true
                                                                                                  ? InkWell(
                                                                                                      onTap: () async {
                                                                                                        try {
                                                                                                          int lodDataId = item['id'];

                                                                                                          var data = await logStarChange(lodDataId, false);

                                                                                                          if (data['result']['message'] == "success") {
                                                                                                            print("startrue");
                                                                                                            setState(() {
                                                                                                              starImage = false;
                                                                                                            });
                                                                                                          }
                                                                                                        } catch (e) {
                                                                                                          errorMethod(e);
                                                                                                        }
                                                                                                      },
                                                                                                      child: SvgPicture.asset(
                                                                                                        'images/st3.svg',
                                                                                                        // 'assets/page-1/images/group-20576.png',
                                                                                                      ),
                                                                                                    )
                                                                                                  : InkWell(
                                                                                                      onTap: () async {
                                                                                                        try {
                                                                                                          int lodDataId = item['id'];

                                                                                                          var data = await logStarChange(lodDataId, true);

                                                                                                          if (data['result']['message'] == "success") {
                                                                                                            print("starfalse");
                                                                                                            setState(() {
                                                                                                              starImage = true;
                                                                                                            });
                                                                                                          }
                                                                                                        } catch (e) {
                                                                                                          errorMethod(e);
                                                                                                        }
                                                                                                      },
                                                                                                      child: SvgPicture.asset(
                                                                                                        'images/star6.svg',
                                                                                                        // 'assets/page-1/images/group-20576.png',
                                                                                                      ),
                                                                                                    ));
                                                                                        }),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: InkWell(
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                            width: 13,
                                                                                            height: 13,
                                                                                            //color:Colors.red,
                                                                                            child: SvgPicture.asset(
                                                                                              'images/edit6.svg',
                                                                                              // 'assets/page-1/images/group-20576.png',
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {
                                                                                            int lodDataId = item['id'];
                                                                                            String logdata = item['body'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ') ?? "";
                                                                                            // Navigator.push(
                                                                                            //     context,
                                                                                            //     MaterialPageRoute(
                                                                                            //         builder: (
                                                                                            //             context) =>
                                                                                            //             LogNoteEdit(
                                                                                            //                 lodDataId,
                                                                                            //                 salesperImg!,
                                                                                            //                 token!,
                                                                                            //                 widget
                                                                                            //                     .opportunityId,
                                                                                            //                 logdata,
                                                                                            //                 "crm.lead")));

                                                                                            selectedItemIndex = lodDataId;
                                                                                            lognoteEditController.text = logdata;
                                                                                            postProvider?.fetchPosts(widget.opportunityId);
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: InkWell(
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                            width: 13,
                                                                                            height: 13,
                                                                                            child: SvgPicture.asset(
                                                                                              'images/delete6.svg',
                                                                                              // 'assets/page-1/images/group-20576.png',
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () async {
                                                                                            try {
                                                                                              int lodDataId = item['id'];
                                                                                              var data = await deleteLogData(lodDataId);

                                                                                              if (data['message'] == "Success") {
                                                                                                print("final11");
                                                                                                postProvider?.fetchPosts(widget.opportunityId);
                                                                                              }
                                                                                            } catch (e) {
                                                                                              errorMethod(e);
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Expanded(
                                                                                flex: 1,
                                                                                child: Container(
                                                                                  padding: EdgeInsets.all(1.0),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(5.0),
                                                                                    // Specifies rounded corners
                                                                                    border: Border.all(
                                                                                      color: Color(0XFFD9D9D9),
                                                                                      // Border color
                                                                                      width: 1.0, // Border width
                                                                                    ),
                                                                                  ),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: InkWell(
                                                                                          child: Container(
                                                                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                            width: 13,
                                                                                            height: 13,
                                                                                            child: SvgPicture.asset(
                                                                                              'images/emoji6.svg',
                                                                                              // 'assets/page-1/images/group-20576.png',
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {
                                                                                            logDataIdEmoji = item['id'];
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (BuildContext context) => _buildEmojiPopupDialog(mcontext),
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 5,
                                                                                      ),

                                                                                      Expanded(
                                                                                        child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                                                          return Container(
                                                                                              margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                              width: 13,
                                                                                              height: 13,
                                                                                              child: starImage == true
                                                                                                  ? InkWell(
                                                                                                      onTap: () async {
                                                                                                        try {
                                                                                                          int lodDataId = item['id'];

                                                                                                          var data = await logStarChange(lodDataId, false);

                                                                                                          if (data['result']['message'] == "success") {
                                                                                                            print("startrue");
                                                                                                            setState(() {
                                                                                                              starImage = false;
                                                                                                            });
                                                                                                          }
                                                                                                        } catch (e) {
                                                                                                          errorMethod(e);
                                                                                                        }
                                                                                                      },
                                                                                                      child: SvgPicture.asset(
                                                                                                        'images/st3.svg',
                                                                                                        // 'assets/page-1/images/group-20576.png',
                                                                                                      ),
                                                                                                    )
                                                                                                  : InkWell(
                                                                                                      onTap: () async {
                                                                                                        try {
                                                                                                          int lodDataId = item['id'];

                                                                                                          var data = await logStarChange(lodDataId, true);

                                                                                                          if (data['result']['message'] == "success") {
                                                                                                            print("starfalse");
                                                                                                            setState(() {
                                                                                                              starImage = true;
                                                                                                            });
                                                                                                          }
                                                                                                        } catch (e) {
                                                                                                          errorMethod(e);
                                                                                                        }
                                                                                                      },
                                                                                                      child: SvgPicture.asset(
                                                                                                        'images/star6.svg',
                                                                                                        // 'assets/page-1/images/group-20576.png',
                                                                                                      ),
                                                                                                    ));
                                                                                        }),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 3,
                                                                                      ),
                                                                                      // SizedBox(width: 5,),
                                                                                      //
                                                                                      // Visibility(
                                                                                      //   visible: lognoteoptions,
                                                                                      //
                                                                                      //   child: Expanded(
                                                                                      //     child: InkWell(
                                                                                      //       child: Container(
                                                                                      //         margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                      //         width: 13,
                                                                                      //         height: 13,
                                                                                      //         //color:Colors.red,
                                                                                      //         child: SvgPicture.asset(
                                                                                      //           'images/edit6.svg',
                                                                                      //           // 'assets/page-1/images/group-20576.png',
                                                                                      //
                                                                                      //         ),
                                                                                      //       ),
                                                                                      //       onTap: (){
                                                                                      //         int lodDataId = logDataTitle[indexx][indexs]['id'];
                                                                                      //         String logdata = logDataTitle[indexx][indexs]['body'].replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ') ?? "";
                                                                                      //         Navigator.push(context, MaterialPageRoute(builder: (context) => LogNoteEdit(lodDataId, salesperImg!, token!, widget.leadId, logdata,"lead.lead")));
                                                                                      //
                                                                                      //       },
                                                                                      //     ),
                                                                                      //   ),
                                                                                      // ),
                                                                                      // SizedBox(width: 5,),
                                                                                      //
                                                                                      // Visibility(
                                                                                      //   visible: lognoteoptions,
                                                                                      //
                                                                                      //   child: Expanded(
                                                                                      //     child: InkWell(
                                                                                      //       child: Container(
                                                                                      //         margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                                                                      //         width: 13,
                                                                                      //         height: 13,
                                                                                      //         child: SvgPicture.asset(
                                                                                      //           'images/delete6.svg',
                                                                                      //           // 'assets/page-1/images/group-20576.png',
                                                                                      //
                                                                                      //         ),
                                                                                      //       ),
                                                                                      //       onTap: ()async{
                                                                                      //         int lodDataId = logDataTitle[indexx][indexs]['id'];
                                                                                      //         var data = await deleteLogData(lodDataId);
                                                                                      //
                                                                                      //         if (data['message'] == "Success") {
                                                                                      //           print("final11");
                                                                                      //           await getLeadDetails();
                                                                                      //           setState(() {
                                                                                      //             logDataHeader.clear();
                                                                                      //             logDataTitle.clear();
                                                                                      //             selectedImagesDisplay.clear();
                                                                                      //           });
                                                                                      //         }
                                                                                      //       },
                                                                                      //     ),
                                                                                      //   ),
                                                                                      // ),
                                                                                      // SizedBox(width: 3,),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          postProvider?.savefiles !=
                                                                  item['id']
                                                              ? Visibility(
                                                                  visible: item[
                                                                              'id'] ==
                                                                          selectedItemIndex
                                                                      ? true
                                                                      : false,
                                                                  // visible: logDataTitle[indexx][indexs].lognoteEdit,
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              left: 76,
                                                                              right: 25),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                mediaQueryData.size.width,

                                                                            // width:200,

                                                                            //height: 46,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                                                                color: Color(0xFFF6F6F6),
                                                                                border: Border.all(
                                                                                  color: Color(0xFFEBEBEB),
                                                                                )),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Container(
                                                                                  width: mediaQueryData.size.width / 1.92,

                                                                                  // width:300,
                                                                                  // height: 40,
                                                                                  //color: Colors.red,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                    child: Form(
                                                                                      key: OpportunityDetail._editFormKey,
                                                                                      child: TextField(
                                                                                          textAlignVertical: TextAlignVertical.top,
                                                                                          style: TextStyle(
                                                                                            fontWeight: FontWeight.w400,
                                                                                            fontFamily: 'Mulish',
                                                                                            fontSize: 11,
                                                                                            color: Color(0xFF000000),
                                                                                          ),
                                                                                          maxLines: null,

                                                                                          // onChanged: (newValue) {
                                                                                          //   print("demodatatataadsaf");
                                                                                          //   // Handle text changes here if necessary
                                                                                          // },
                                                                                          controller: lognoteEditController,
                                                                                          decoration: const InputDecoration(
                                                                                              border: InputBorder.none,
                                                                                              hintText: "Send a message to followers",
                                                                                              hintStyle: TextStyle(
                                                                                                  //fontFamily: "inter",
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                  fontFamily: 'Mulish',
                                                                                                  fontSize: 11,
                                                                                                  color: Color(0xFFAFAFAF)))),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 10),
                                                                                  child: IconButton(
                                                                                      onPressed: () {
                                                                                        myAlert("lognoteEdit");
                                                                                        postProvider?.fetchPosts(widget.opportunityId);
                                                                                      },
                                                                                      icon: Image.asset("images/pi.png")),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        selectedImagesEdit.isEmpty
                                                                            ? Padding(
                                                                                padding: const EdgeInsets.only(left: 73),
                                                                                child: Container(
                                                                                  width: mediaQueryData.size.width,
                                                                                  //width:400,
                                                                                  //height: 40,
                                                                                  //color: Colors.red,
                                                                                ),
                                                                              )
                                                                            : Padding(
                                                                                padding: const EdgeInsets.only(left: 70, right: 50, top: 5),
                                                                                child: Container(
                                                                                  width: mediaQueryData.size.width,
                                                                                  // width:400,
                                                                                  // height: 40,
                                                                                  child: Container(
                                                                                    width: 40,
                                                                                    //height: 40,
                                                                                    child: GridView.builder(
                                                                                      shrinkWrap: true,
                                                                                      // Avoid scrolling
                                                                                      physics: NeverScrollableScrollPhysics(),
                                                                                      itemCount: selectedImagesEdit.length,
                                                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                                                                                      itemBuilder: (BuildContext context, int index) {
                                                                                        print("pdfffffffffff2");
                                                                                        return selectedImagesEdit[index].path.contains(".pdf")
                                                                                            ? Container(
                                                                                                width: 40,
                                                                                                height: 40,
                                                                                                color: Color(0xFFEF5350),
                                                                                                child: Icon(Icons.picture_as_pdf_sharp),
                                                                                              )
                                                                                            : selectedImagesEdit[index].path.contains(".zip")
                                                                                                ? Container(
                                                                                                    width: 40,
                                                                                                    height: 40,
                                                                                                    color: Color(0xFFFDD835),
                                                                                                    child: Icon(Icons.folder_zip_outlined),
                                                                                                  )
                                                                                                : selectedImagesEdit[index].path.contains(".xlsx")
                                                                                                    ? Container(
                                                                                                        width: 40,
                                                                                                        height: 40,
                                                                                                        color: Color(0xFF4CAF50),
                                                                                                        child: Icon(Icons.clear),
                                                                                                      )
                                                                                                    : selectedImagesEdit[index].path.contains(".xml")
                                                                                                        ? Container(
                                                                                                            width: 40,
                                                                                                            height: 40,
                                                                                                            color: Color(0xFF0277BD),
                                                                                                            child: Icon(Icons.code_off),
                                                                                                          )
                                                                                                        : selectedImagesEdit[index].path.contains(".doc")
                                                                                                            ? Container(
                                                                                                                width: 40,
                                                                                                                height: 40,
                                                                                                                color: Color(0xFF2196F3),
                                                                                                                child: Icon(Icons.article_outlined),
                                                                                                              )
                                                                                                            : Center(child: kIsWeb ? Image.network(selectedImagesEdit[index].path) : Image.file(selectedImagesEdit[index]));
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(left: 75),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "escape to",
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              InkWell(
                                                                                child: Container(child: Text("  cancel  ")),
                                                                                onTap: () {
                                                                                  selectedItemIndex = -1;
                                                                                  lognoteEditController.text = "";
                                                                                  selectedImagesEdit.clear();
                                                                                  myData1.clear();
                                                                                  postProvider?.fetchPosts(widget.opportunityId);
                                                                                },
                                                                              ),
                                                                              //TextButton(onPressed:(){}, child: Text("cancel")),
                                                                              Text(","),
                                                                              Text(
                                                                                "  enter to",
                                                                                style: TextStyle(color: Colors.grey),
                                                                              ),
                                                                              InkWell(
                                                                                  child: Container(child: Text("  save")),
                                                                                  // onTap:_isSavingData
                                                                                  //     ? null
                                                                                  onTap: () async {
                                                                                    int positionId = item['id'];
                                                                                    postProvider?.fetchPosts1(positionId);

                                                                                    for (int i = 0; i < selectedImagesEdit.length; i++) {
                                                                                      imagepath = selectedImagesEdit[i].path.toString();
                                                                                      File imagefile = File(imagepath);

                                                                                      Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
                                                                                      base64string = base64.encode(imagebytes);

                                                                                      //

                                                                                      String dataImages = '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                                                                                      Map<String, dynamic> jsondata = jsonDecode(dataImages);
                                                                                      myData1.add(jsondata);
                                                                                    }

                                                                                    int lognoteId = item['id'];
                                                                                    String resMessage = await logNoteEditData(myData1, lognoteId);

                                                                                    if (resMessage != 0) {
                                                                                      lognoteEditController.text = "";
                                                                                      selectedImagesEdit.clear();
                                                                                      myData1.clear();
                                                                                      selectedItemIndex = -1;
                                                                                      postProvider?.fetchPosts(widget.opportunityId);

                                                                                      delayMethod();
                                                                                    }
                                                                                    ;
                                                                                  }),
                                                                              // TextButton(onPressed:(){}, child: Text("save")),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: 20,
                                                                  height: 20,
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 25,
                                                                    left: 24,
                                                                    right: 24),
                                                            //width: 350,
                                                            width:
                                                                mediaQueryData
                                                                    .size.width,
                                                            // color:Colors.red,
                                                            // height: 450,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                selectedImagesDisplay
                                                                            .length ==
                                                                        0
                                                                    ? Container()
                                                                    : Column(
                                                                        children: [
                                                                          Container(
                                                                            // color: Colors.red,
                                                                            width:
                                                                                mediaQueryData.size.width,
                                                                            child: logattachmentImagesDisplay.length > 0
                                                                                ? GridView.builder(
                                                                                    shrinkWrap: true,
                                                                                    // Avoid scrolling
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    itemCount: logattachmentImagesDisplay.length,
                                                                                    // itemCount: 15,
                                                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                      crossAxisCount: 4,
                                                                                      mainAxisSpacing: 1.0,
                                                                                      crossAxisSpacing: 1.0,
                                                                                      childAspectRatio: 1,
                                                                                    ),
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      print(logattachmentImagesDisplay[index]["datas"]);
                                                                                      print("selectedImagesDisplay.length,");
                                                                                      return Container(
                                                                                        margin: EdgeInsets.fromLTRB(10, 0, 2, 0),
                                                                                        width: 80,
                                                                                        height: double.infinity,
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            Positioned(
                                                                                              // rectangle4756kQ (1652:322)
                                                                                              left: 0,
                                                                                              top: 6,
                                                                                              child: Align(
                                                                                                child: SizedBox(
                                                                                                  width: 75,
                                                                                                  height: 71,
                                                                                                  child: Container(
                                                                                                    decoration: BoxDecoration(
                                                                                                      borderRadius: BorderRadius.circular(3),
                                                                                                      // color: Color(
                                                                                                      //     0xffd9d9d9),
                                                                                                      image: DecorationImage(
                                                                                                        fit: BoxFit.cover,
                                                                                                        image: NetworkImage(logattachmentImagesDisplay[index]["datas"]),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Positioned(
                                                                                              // group20514mrY (1652:323)
                                                                                              left: 60,
                                                                                              top: 0,
                                                                                              child: Align(
                                                                                                child: SizedBox(
                                                                                                  width: 20,
                                                                                                  height: 20,
                                                                                                  child: Image.asset(
                                                                                                    'images/logimagedelete.png',
                                                                                                    width: 20,
                                                                                                    height: 20,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Positioned(
                                                                                              // trash2G2c (1652:325)
                                                                                              left: 65,
                                                                                              top: 5,
                                                                                              child: Align(
                                                                                                child: InkWell(
                                                                                                  onTap: () async {
                                                                                                    int lodAttachmentId = item['attachment_ids']['images'][index]["id"];
                                                                                                    var data = await deleteLogAttachment(lodAttachmentId);

                                                                                                    if (data['message'] == "Success") {
                                                                                                      print("jhbdndsjbv");
                                                                                                      // await getLeadDetails();
                                                                                                      // setState(() {
                                                                                                      //   logDataHeader
                                                                                                      //       .clear();
                                                                                                      //   logDataTitle
                                                                                                      //       .clear();
                                                                                                      //   selectedImagesDisplay
                                                                                                      //       .clear();
                                                                                                      // });
                                                                                                      postProvider?.fetchPosts(widget.opportunityId);
                                                                                                    }
                                                                                                  },
                                                                                                  child: SizedBox(
                                                                                                    width: 9,
                                                                                                    height: 10,
                                                                                                    child: Image.asset(
                                                                                                      'images/logtrash.png',
                                                                                                      width: 9,
                                                                                                      height: 10,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    })
                                                                                : Container(),
                                                                          ),
                                                                          SizedBox(
                                                                              height: 5),
                                                                          Container(
                                                                            width:
                                                                                mediaQueryData.size.width,
                                                                            child: logattachmentFileDisplay.length > 0
                                                                                ? GridView.builder(
                                                                                    shrinkWrap: true,
                                                                                    // Avoid scrolling
                                                                                    physics: NeverScrollableScrollPhysics(),
                                                                                    itemCount: logattachmentFileDisplay.length,
                                                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                                      crossAxisCount: 1,
                                                                                      //mainAxisSpacing: 5.0,
                                                                                      crossAxisSpacing: 1.0,
                                                                                      childAspectRatio: 5.5,
                                                                                    ),
                                                                                    itemBuilder: (BuildContext context, int index) {
                                                                                      return Container(
                                                                                        margin: EdgeInsets.fromLTRB(10, 0, 0, 2),
                                                                                        // group20585QEc (1652:502)
                                                                                        width: double.infinity,
                                                                                        child: Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                          children: [
                                                                                            Container(
                                                                                              // group20565Yrc (1652:364)
                                                                                              padding: EdgeInsets.fromLTRB(14, 11, 18, 9),
                                                                                              width: double.infinity,
                                                                                              height: 52,
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: Color(0xffebebeb)),
                                                                                                borderRadius: BorderRadius.circular(6),
                                                                                              ),
                                                                                              child: Row(
                                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    // pdffile21FW8 (1652:378)
                                                                                                    margin: EdgeInsets.fromLTRB(0, 0, 12, 0),
                                                                                                    width: 23,
                                                                                                    height: 29,
                                                                                                    child: Image.asset(
                                                                                                      logattachmentFileDisplay[index]["mimetype"] == "application/pdf"
                                                                                                          ? 'images/logpdf.png'
                                                                                                          : logattachmentFileDisplay[index]["mimetype"] == "application/msword"
                                                                                                              ? 'images/logword.png'
                                                                                                              : logattachmentFileDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                                                                                                  ? 'images/logexcel.png'
                                                                                                                  : logattachmentFileDisplay[index]["mimetype"] == "application/xml"
                                                                                                                      ? 'images/logxml.png'
                                                                                                                      : logattachmentFileDisplay[index]["mimetype"] == "application/zip"
                                                                                                                          ? 'images/logzip.png'
                                                                                                                          : '',
                                                                                                      width: 23,
                                                                                                      height: 29,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    width: mediaQueryData.size.width / 2,
                                                                                                    //height: double.infinity,
                                                                                                    child: Stack(
                                                                                                      children: [
                                                                                                        Positioned(
                                                                                                          // pdfnamearea1tc (1652:376)
                                                                                                          left: 0,
                                                                                                          top: 00,
                                                                                                          child: Align(
                                                                                                            child: SizedBox(
                                                                                                              width: mediaQueryData.size.width / 2,
                                                                                                              child: Text(
                                                                                                                logattachmentFileDisplay[index]["name"],
                                                                                                                style: TextStyle(
                                                                                                                  fontFamily: 'Mulish',
                                                                                                                  fontSize: 12,
                                                                                                                  fontWeight: FontWeight.w600,
                                                                                                                  color: Color(0xff202020),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Positioned(
                                                                                                          // pdfuDJ (1652:377)
                                                                                                          left: 0,
                                                                                                          top: 18,
                                                                                                          child: Align(
                                                                                                            child: SizedBox(
                                                                                                              width: 50,
                                                                                                              // height: 15,
                                                                                                              child: Text(
                                                                                                                logattachmentFileDisplay[index]["mimetype"] == "application/pdf"
                                                                                                                    ? "PDF"
                                                                                                                    : logattachmentFileDisplay[index]["mimetype"] == "application/msword"
                                                                                                                        ? "WORD"
                                                                                                                        : logattachmentFileDisplay[index]["mimetype"] == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                                                                                                            ? "EXCEL"
                                                                                                                            : logattachmentFileDisplay[index]["mimetype"] == "application/xml"
                                                                                                                                ? "XML"
                                                                                                                                : logattachmentFileDisplay[index]["mimetype"] == "application/zip"
                                                                                                                                    ? "ZIP"
                                                                                                                                    : "",
                                                                                                                style: TextStyle(
                                                                                                                  fontFamily: 'Mulish',
                                                                                                                  fontSize: 9,
                                                                                                                  fontWeight: FontWeight.w500,
                                                                                                                  color: Color(0xff666666),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  Spacer(),
                                                                                                  Container(
                                                                                                    child: InkWell(
                                                                                                      child: Container(
                                                                                                        // trash2Qvk (1652:366)
                                                                                                        margin: EdgeInsets.fromLTRB(0, 0, 15, 1),
                                                                                                        width: 15,
                                                                                                        height: 16,
                                                                                                        child: Image.asset(
                                                                                                          'images/logtrash.png',
                                                                                                          width: 15,
                                                                                                          height: 16,
                                                                                                        ),
                                                                                                      ),
                                                                                                      onTap: () async {
                                                                                                        int lodAttachmentId = item['attachment_ids']['files'][index]["id"];
                                                                                                        var data = await deleteLogAttachment(lodAttachmentId);

                                                                                                        if (data['message'] == "Success") {
                                                                                                          print("jhbdndsjbv");
                                                                                                          // await getLeadDetails();
                                                                                                          // setState(() {
                                                                                                          //   logDataHeader
                                                                                                          //       .clear();
                                                                                                          //   logDataTitle
                                                                                                          //       .clear();
                                                                                                          //   selectedImagesDisplay
                                                                                                          //       .clear();
                                                                                                          // });
                                                                                                          postProvider?.fetchPosts(widget.opportunityId);
                                                                                                        }
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                  Container(
                                                                                                    child: InkWell(
                                                                                                      child: Container(
                                                                                                        // download6oa (1652:371)
                                                                                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                                                                                                        width: 14,
                                                                                                        height: 14,
                                                                                                        child: Image.asset(
                                                                                                          'images/logdownload.png',
                                                                                                          width: 14,
                                                                                                          height: 14,
                                                                                                        ),
                                                                                                      ),
                                                                                                      onTap: () {
                                                                                                        String mimetypes = item['attachment_ids']['files'][index]["mimetype"];
                                                                                                        //String mimetypes = "application/pdf";

                                                                                                        String itemName, itemNamefinal;

                                                                                                        itemName = item['attachment_ids']['files'][index]["name"];

                                                                                                        mimetypes == "application/pdf"
                                                                                                            ? itemNamefinal = "${itemName}.pdf"
                                                                                                            : mimetypes == "application/msword"
                                                                                                                ? itemNamefinal = "${itemName}.doc"
                                                                                                                : mimetypes == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                                                                                                    ? itemNamefinal = "${itemName}.xlsx"
                                                                                                                    : mimetypes == "application/xml"
                                                                                                                        ? itemNamefinal = "${itemName}.xml"
                                                                                                                        : mimetypes == "application/zip"
                                                                                                                            ? itemNamefinal = "${itemName}.zip"
                                                                                                                            : mimetypes == "image/jpeg"
                                                                                                                                ? itemNamefinal = "${itemName}.jpeg"
                                                                                                                                : mimetypes == "image/png"
                                                                                                                                    ? itemNamefinal = "${itemName}.png"
                                                                                                                                    : itemNamefinal = "${itemName}";

                                                                                                        print(index);

                                                                                                        print(logattachmentFileDisplay);

                                                                                                        print(itemNamefinal);
                                                                                                        print(mimetypes);
                                                                                                        print("final print dataaa");

                                                                                                        FlutterDownloader.registerCallback(downloadCallback);

                                                                                                        requestPermission(itemNamefinal, item['attachment_ids']['files'][index]["datas"]);
                                                                                                        postProvider?.fetchPosts(widget.opportunityId);
                                                                                                      },
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 9,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    })
                                                                                : Container(),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                emojiSet.length >
                                                                        0
                                                                    ? Container(
                                                                        width: mediaQueryData
                                                                            .size
                                                                            .width,
                                                                        child: GridView.builder(
                                                                            shrinkWrap: true,
                                                                            // Avoid scrolling
                                                                            physics: NeverScrollableScrollPhysics(),
                                                                            itemCount: emojiSet.length,
                                                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                              crossAxisCount: 6,
                                                                              mainAxisSpacing: 5.0,
                                                                              crossAxisSpacing: 5.0,
                                                                              childAspectRatio: 2.1,
                                                                            ),
                                                                            itemBuilder: (BuildContext context, int index) {
                                                                              return InkWell(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 2),
                                                                                    // width: 40,
                                                                                    height: 15,
                                                                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Color(0XFFEBEBEB), width: 1)),
                                                                                    // color: Colors.red,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(left: 5),
                                                                                          child: Container(
                                                                                              // width:18,
                                                                                              height: 19,
                                                                                              child: Text(emojiSet[index]['emoji'])),
                                                                                        ),
                                                                                        SizedBox(width: 3),
                                                                                        Text(
                                                                                          emojiSet[index]['count'].toString(),
                                                                                          style: TextStyle(fontSize: 10),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  onTap: () async {
                                                                                    var data = await deleteEmoji(emojiSet[index]['emoji'], item['id']);

                                                                                    if (data['result']['message'] == "success") {
                                                                                      postProvider?.fetchPosts(widget.opportunityId);
                                                                                    }
                                                                                  });
                                                                            }),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                })
                              : CircularProgressIndicator(),
                        ],
                      ),
                    ),
                    //color: Colors.green,
                  ),
                );
              }),
              bottomNavigationBar: MyBottomNavigationBar(2),
            ),
    );
  }

  getOpportunityDetails() async {
    token = await getUserJwt();
    baseUrl = await getUrlString();
    var notificationMessage = await getNotificationCount();

    notificationCount = notificationMessage['activity_count'].toString();

    messageCount = notificationMessage['message_count'].toString();

    sendMailData = await sendMailsFollowers(widget.opportunityId, "crm.lead");

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
    await postProvider?.fetchPosts(widget.opportunityId);
    await getScheduleDetails();
  }

  opportunityLost(String action) async {
    try {
      String value =
          await lostOpportunity(widget.opportunityId, lostreasonId, action);
      return value;
    } catch (e) {
      errorMethod(e);
    }
  }

  opportunityWonRestore(String action) async {
    try {
      String value = await restoreWonOpportunity(
          widget.opportunityId, lostreasonId, action);
      return value;
    } catch (e) {
      errorMethod(e);
    }
  }

  opportunityarchive(bool action) async {
    try {
      String value =
          await archiveOpportunity(widget.opportunityId, lostreasonId, action);
      return value;
    } catch (e) {
      errorMethod(e);
    }
  }

  StageChangeOpportunity(int state) async {
    String value = await opportunityStageChange(state, widget.opportunityId);
    return value;
  }

  defaultScheduleValues() async {
    token = await getUserJwt();
    baseUrl = await getUrlString();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 8),
                  child: IconButton(
                    icon: SvgPicture.asset("images/cr.svg"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: SearchChoices.single(
                    fieldPresentationFn: (Widget fieldWidget,
                        {bool? selectionIsValid}) {
                      return Container(
                        padding: const EdgeInsets.all(0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                            ),
                            labelText: 'Activity Type',
                            isDense: true,
                            labelStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w500),
                            fillColor: Colors.white,
                          ),
                          child: fieldWidget,
                        ),
                      );
                    },
                    //items: items,

                    value: activityTypeName,
                    // hint: Text(
                    //   "Activity Type",
                    //   style: TextStyle(
                    //       color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                    // ),
                    searchHint: null,
                    autofocus: true,
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
                        // width: 300,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          item["name"],
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Mulish',
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
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
                                        child: Text("${item["name"]}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Mulish',
                                                fontWeight: FontWeight.w600)),
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
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
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
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500)),
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
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Mulish',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                enabled: false,
                                controller: DuedateTime,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Due Date",
                                    hintStyle: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 14,
                                        fontFamily: 'Mulish',
                                        fontWeight: FontWeight.w500))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                        child: SearchChoices.single(
                          fieldPresentationFn: (Widget fieldWidget,
                              {bool? selectionIsValid}) {
                            return Container(
                              padding: const EdgeInsets.all(0),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFAFAFAF)),
                                  ),
                                  labelText: 'Assigned To',
                                  isDense: true,
                                  labelStyle: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 14,
                                      fontFamily: 'Mulish',
                                      fontWeight: FontWeight.w500),
                                  fillColor: Colors.white,
                                ),
                                child: fieldWidget,
                              ),
                            );
                          },
                          //items: items,

                          value: assignedToname,
                          // hint: Text(
                          //   "Assigned To",
                          //   style: TextStyle(
                          //       color: Color(0xFF666666), fontSize: 14,fontFamily: 'Mulish',fontWeight: FontWeight.w500),
                          // ),
                          searchHint: null,
                          autofocus: true,
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
                              //width: 300,
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                item["name"],
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Mulish',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
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
                                .map<DropdownMenuItem>((item) =>
                                    DropdownMenuItem(
                                      value: item,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text("${item["name"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: 'Mulish',
                                                  fontWeight: FontWeight.w600)),
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
                              fontSize: 14,
                              fontFamily: 'Mulish',
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
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
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w500)),
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
                            onPressed: _isSavingData
                                ? null // Disable the button if saving is in progress
                                : () async {
                                    setState(() {
                                      _isSavingData = true;
                                    });
                                    String resmessage;
                                    typeIds == 0
                                        ? resmessage = await activitySchedule()
                                        : resmessage =
                                            await editactivitySchedule(typeIds);

                                    int resmessagevalue = int.parse(resmessage);
                                    if (resmessagevalue != 0) {
                                      setState(() {
                                        _isSavingData = false;
                                      });

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
                              primary: Color(0xFF043565),
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
                                onPressed: _isSavingData
                                    ? null // Disable the button if saving is in progress
                                    : () async {
                                        setState(() {
                                          _isSavingData = true;
                                        });
                                        String resmessage;

                                        typeIds == 0
                                            ? resmessage =
                                                await activitySchedule()
                                            : resmessage =
                                                await editactivitySchedule(
                                                    typeIds);
                                        //resmessage=  await activitySchedule();
                                        int resmessagevalue =
                                            int.parse(resmessage);
                                        if (resmessagevalue != 0) {
                                          await getScheduleDetails();
                                          setState(() {
                                            _isSavingData = false;
                                          });

                                          Navigator.pop(context);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF043565),
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
                                onPressed: _isSavingData
                                    ? null // Disable the button if saving is in progress
                                    : () async {
                                        setState(() {
                                          _isSavingData = true;
                                        });
                                        String resmessage;
                                        typeIds == 0
                                            ? resmessage = await markDone()
                                            : resmessage =
                                                await editMarkDone(typeIds);

                                        int resmessagevalue =
                                            int.parse(resmessage);
                                        if (resmessagevalue != 0) {
                                          await getScheduleDetails();
                                          setState(() {
                                            _isSavingData = false;
                                          });
                                          postProvider?.fetchPosts(
                                              widget.opportunityId);
                                          Navigator.pop(context);
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF043565),
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
                              onPressed: _isSavingData
                                  ? null // Disable the button if saving is in progress
                                  : () async {
                                      setState(() {
                                        _isSavingData = true;
                                      });
                                      String resmessage;
                                      typeIds == 0
                                          ? resmessage = await markDone()
                                          : resmessage =
                                              await editMarkDone(typeIds);

                                      int resmessagevalue =
                                          int.parse(resmessage);
                                      if (resmessagevalue != 0) {
                                        await defaultScheduleValues();

                                        setState(() {
                                          summaryController.text = "";
                                          commandsController.text = "";
                                          _isSavingData = false;
                                          typeIds = 0;
                                        });
                                        postProvider
                                            ?.fetchPosts(widget.opportunityId);
                                        //Navigator.pop(context);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF043565),
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
                              onPressed: _isSavingData
                                  ? null // Disable the button if saving is in progress
                                  : () async {
                                      setState(() {
                                        _isSavingData = true;
                                      });

                                      await getOpportunityDetails();
                                      setState(() {
                                        _isSavingData = false;
                                      });
                                      Navigator.pop(context);
                                    },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF043565),
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
                        postProvider?.fetchPosts(widget.opportunityId);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildOrderPopupDialog(context, 0),
                        ).then((value) => setState(() {}));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF043565),
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
                          postProvider?.fetchPosts(widget.opportunityId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF043565),
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
    try {
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
    } catch (e) {
      errorMethod2(e);
    }
  }

  editactivitySchedule(int typeIds) async {
    try {
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
    } catch (e) {
      errorMethod2(e);
    }
  }

  markDone() async {
    try {
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
    } catch (e) {
      errorMethod2(e);
    }
  }

  editMarkDone(int typeIds) async {
    try {
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
    } catch (e) {
      errorMethod2(e);
    }
  }

  logNoteData(List myData1) async {
    try {
      var value = await logNoteCreate(
          lognoteController.text, "crm.lead", widget.opportunityId, myData1);

      print(value);
      print("valuesss");
      return value;
    } catch (e) {
      errorMethod1(e);
    }
  }

  void myAlert(String modelType) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select',
                style: TextStyle(
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
                        backgroundColor:
                            MaterialStateProperty.all(Color(0XFF043565)),
                        // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Color(0xFF212121)))),
                    onPressed: () {
                      Navigator.pop(context);
                      modelType == "lognote"
                          ? getImages()
                          : modelType == "lognoteEdit"
                              ? getImagesEdit()
                              : getImagesAttachment();
                      //getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0XFF043565)),
                        // padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                        textStyle: MaterialStateProperty.all(TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            color: Color(0xFF212121)))),
                    onPressed: () {
                      Navigator.pop(context);
                      print("system 2");
                      modelType == "lognote"
                          ? getImage(ImageSource.camera)
                          : modelType == "lognoteEdit"
                              ? getImageEdit(ImageSource.camera)
                              : getImageAttachment(ImageSource.camera);

                      //getImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera',
                            style: TextStyle(
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

    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print("system 2");

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

  Future getImageEdit(ImageSource media) async {
    print("final datatata55");
    // setState(() {
    isLoading = true;
    // });
    print("system 1");
    // var img = await picker.pickImage(source: media));
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    List imageData = [];
    imageData.add(img);
    print("system 2");
    // var img = await picker.pickMultiImage();

    if (img != null) {
      // setState(
      //       () {
      if (imageData.isNotEmpty) {
        print("system 3");
        for (var i = 0; i < imageData.length; i++) {
          selectedImagesEdit.add(File(imageData[i].path));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
      }
      //   },
      // );
    }
    print(selectedImages);
    print("system 4");

    // setState(() {
    //focusEditText();
    print("aytofocuusss");
    // print(shouldFocus);
    isLoading = false;
    // });
    postProvider?.fetchPosts(widget.opportunityId);
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

  Future getImagesEdit() async {
    print("final datatata2211");
    final pickedFile = await picker.pickMultipleMedia(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    // setState(
    //       () {
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        //  if(xfilePick[i].path.contains(".pdf")||xfilePick[i].path.contains(".zip")){
        //    print("pdf detected");
        //  }
        // else {
        //    selectedImages.add(File(xfilePick[i].path));
        //  }
        selectedImagesEdit.add(File(xfilePick[i].path));
        print("pdf detected test");
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
    }
    //   },
    // );
    postProvider?.fetchPosts(widget.opportunityId);
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
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
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
                      icon: SvgPicture.asset("images/cr.svg"),
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
                  padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  child: Center(
                    child: SizedBox(
                      //width: 340,
                      width: MediaQuery.of(context).size.width,
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
                          onPressed: _isSavingData
                              ? null // Disable the button if saving is in progress
                              : () async {
                                  try {
                                    setState(() {
                                      _isSavingData = true;
                                    });
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
                                      setState(() {
                                        _isSavingData = false;
                                      });

                                      subject2Controller.clear();
                                      phonenumberController.clear();
                                      nameController.clear();
                                      smsId = 0;
                                      type = "";

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OpportunityDetail(
                                                      widget.opportunityId)));
                                    }
                                  } catch (e) {
                                    setState(() {
                                      _isSavingData = false;
                                    });
                                    Navigator.pop(context);
                                    errorMethod(e);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF043565),
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
              message = responce['message']
                      .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
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
                              child: CircleAvatar(
                                radius: 12,
                                child: Icon(
                                  Icons.person,
                                  size: 20,

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Invite Follower",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: 'Mulish',
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset("images/cr.svg"),
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: MultiSelectDropDown.network(
                    hint: 'Add contacts to notify...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                    ),
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Checkbox(
                    activeColor: Color(0xFF043565),
                    value: isCheckedEmail,
                    onChanged: (bool? value) {
                      setState(() {
                        isCheckedEmail = value!;
                      });
                    },
                  ),
                ),
                Container(
                  //color: Colors.red,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 5,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        expands: true,
                        maxLines: null,
                        controller: bodyController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 38,
                      child: ElevatedButton(
                          child: Center(
                            child: Text(
                              "Add Followers",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.57,
                                  color: Colors.white,
                                  fontFamily: 'Mulish'),
                            ),
                          ),
                          onPressed: _isSavingData
                              ? null // Disable the button if saving is in progress
                              : () async {
                                  setState(() {
                                    _isSavingData = true;
                                  });

                                  String resmessage = await followerCreate(
                                      message,
                                      followerId,
                                      recipient,
                                      send_mail);

                                  if (resmessage == "success") {
                                    bodyController.clear();
                                    followerId = 0;
                                    setState(() {
                                      _isSavingData = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OpportunityDetail(
                                                    widget.opportunityId)));
                                  }

                                  print(recipient);
                                  print("tagattagagaga");
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF043565),
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

  _buildEditfollowersPopupDialog(
      BuildContext context, List followerSub, int followerId) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
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
                      icon: SvgPicture.asset("images/cr.svg"),
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
                                  activeColor: Color(0xFF043565),
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
                            primary: Color(0xFF043565),
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

  defaultSendmsgvalues() async {
    List<int> selectedIds = sendMailData
        .where((item) => item["selected"] == true)
        .map((item) => item["id"] as int)
        .toList();

    print("sjbkjbnkjnsdvkn");

    recipient!.clear();
    token = await getUserJwt();
    baseUrl = await getUrlString();
    var data = await defaultSendmessageData(
        widget.opportunityId, "crm.lead", selectedIds);
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
      lognoteController.text != ""
          ? bodyController.text = lognoteController.text
          : bodyController.text = "";

      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
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
                      icon: SvgPicture.asset("images/cr.svg"),
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
                Visibility(
                  visible: recipientsVisibility,
                  child: Text(
                    "Recipients",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
                Visibility(
                  visible: recipientsVisibility,
                  child: SizedBox(
                    height: 5,
                  ),
                ),
                Visibility(
                  visible: recipientsVisibility,
                  child: Text(
                    "Followers of the document and",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Mulish',
                    ),
                  ),
                ),
                Visibility(
                  visible: recipientsVisibility,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: recipientsVisibility,
                  child: Padding(
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
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  width: MediaQuery.of(context).size.width,
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
                            onPressed: () {
                              myAlert("lognote");
                            },
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
                                return selectedImages[index]
                                        .path
                                        .contains(".pdf")
                                    ? Container(
                                        width: 40,
                                        height: 40,
                                        color: Color(0xFFEF5350),
                                        child: Icon(Icons.picture_as_pdf_sharp),
                                      )
                                    : selectedImages[index]
                                            .path
                                            .contains(".zip")
                                        ? Container(
                                            width: 40,
                                            height: 40,
                                            color: Color(0xFFFDD835),
                                            child:
                                                Icon(Icons.folder_zip_outlined),
                                          )
                                        : selectedImages[index]
                                                .path
                                                .contains(".xlsx")
                                            ? Container(
                                                width: 40,
                                                height: 40,
                                                color: Color(0xFF4CAF50),
                                                child: Icon(Icons.clear),
                                              )
                                            : selectedImages[index]
                                                    .path
                                                    .contains(".xml")
                                                ? Container(
                                                    width: 40,
                                                    height: 40,
                                                    color: Color(0xFF0277BD),
                                                    child: Icon(Icons.code_off),
                                                  )
                                                : selectedImages[index]
                                                        .path
                                                        .contains(".doc")
                                                    ? Container(
                                                        width: 40,
                                                        height: 40,
                                                        color:
                                                            Color(0xFF2196F3),
                                                        child: Icon(Icons
                                                            .article_outlined),
                                                      )
                                                    : Center(
                                                        child: kIsWeb
                                                            ? Image.network(
                                                                selectedImages[
                                                                        index]
                                                                    .path)
                                                            : Image.file(
                                                                selectedImages[
                                                                    index]));
                              },
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: SearchChoices.single(
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
                    autofocus: true,
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
                  padding: const EdgeInsets.only(top: 20, left: 0, right: 0),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
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
                          onPressed: _isSavingData
                              ? null // Disable the button if saving is in progress
                              : () async {
                                  setState(() {
                                    _isSavingData = true;
                                  });
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

                                    String dataImages =
                                        '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                                    Map<String, dynamic> jsondata =
                                        jsonDecode(dataImages);
                                    myData1.add(jsondata);
                                  }

                                  var resMessage =
                                      await createSendmessage(myData1);

                                  if (resMessage['message'] == "success") {
                                    setState(() {
                                      _isSavingData = false;
                                      attachmentCount = resMessage['data']
                                              ['att_count']
                                          .toString();
                                      logDataHeader.clear();
                                      logDataTitle.clear();

                                      if (selectedImagesDisplay != null) {
                                        if (selectedImagesDisplay.length > 0) {
                                          selectedImagesDisplay.clear();
                                        }
                                      }

                                      lognoteController.text = "";
                                      selectedImages.clear();
                                      myData1.clear();
                                      editRecipientName.clear();
                                      recipient?.clear();
                                      selctedRecipient.clear();
                                    });
                                    postProvider
                                        ?.fetchPosts(widget.opportunityId);
                                    Navigator.pop(context);

                                    print(recipient);
                                    print("tagattagagaga");
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF043565),
                          )),
                    ),
                  ),
                ),
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
    try {
      var value = await sendMessageCreate(
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
    } catch (e) {
      errorMethod1(e);
    }
  }

  _buildEmojiPopupDialog(BuildContext mcontext) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width / 1.6,
            height: MediaQuery.of(context).size.height / 2.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: Image.asset("images/image24.png"),
                        onPressed: () {
                          emojiClick(mcontext, "😃");
                        }),
                    IconButton(
                      icon: Image.asset("images/image1.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😄");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image23.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😊");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image3.png"),
                      onPressed: () {
                        emojiClick(mcontext, "🤩");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image4.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😎");
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset("images/image5.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😢");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image2.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😇");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image28.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😲");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image31.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😭");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image21.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😕");
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset("images/image32.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😱");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image26.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😂");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image25.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😋");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image22.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😐");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image33.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😨");
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset("images/image15.png"),
                      onPressed: () {
                        emojiClick(mcontext, "🤪");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image16.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😔");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image17.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😘");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image18.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😝");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image19.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😠");
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset("images/image20.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😢");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image30.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😍");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image29.png"),
                      onPressed: () {
                        emojiClick(mcontext, "😉");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image7.png"),
                      onPressed: () {
                        emojiClick(mcontext, "👍🏻");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image27.png"),
                      onPressed: () {
                        emojiClick(mcontext, "👎🏻");
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Image.asset("images/image8.png"),
                      onPressed: () {
                        emojiClick(mcontext, "🙏🏻");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image12.png"),
                      onPressed: () {
                        emojiClick(mcontext, "🔥");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image10.png"),
                      onPressed: () {
                        emojiClick(mcontext, "🌹");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image6.png"),
                      onPressed: () {
                        emojiClick(mcontext, "❤️");
                      },
                    ),
                    IconButton(
                      icon: Image.asset("images/image13.png"),
                      onPressed: () {
                        emojiClick(mcontext, "🎉");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ));
    });
  }

  void emojiClick(mcontext, String emoji) async {
    try {
      print(logDataIdEmoji);
      String value = await EmojiReaction(emoji, logDataIdEmoji!);
      postProvider?.fetchPosts(widget.opportunityId);
      _dismissDialog(context);
    } catch (e) {
      errorMethod3(e);
    }
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      print("finaldata11");
      // Notification permissions granted
    } else if (status.isDenied) {
      await openAppSettings();
      print("finaldata12");
    } else if (status.isPermanentlyDenied) {
      print("finaldata13");

      await openAppSettings();
    }
  }

  Future<void> _initDownloadPath() async {
    final directory = await getExternalStorageDirectory();
    // _localPath = "${directory!.path} + '/Download'";

    _localPath = "${directory!.path}";

    final savedDir = Directory(_localPath!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  // Function to start the download task
  Future<void> _startDownload(String name, String urldata) async {
    var status = await Permission.storage.request();

    try {
      print("status3");
      final taskId = await FlutterDownloader.enqueue(
          url: urldata,
          savedDir: _localPath!,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true,
          fileName: name);
      print("dddddtask2");
      print(_localPath);
      // setState(() {
      //   _taskId = taskId;
      // });
    } catch (e) {
      print('Download error: $e');
    }
  }

  static void downloadCallback(String id, int status, int progress) {
    print('Download task ($id) is in status ($status) and $progress% complete');
  }

  Future<void> requestPermission(String name, String urldata) async {
    var status = await Permission.mediaLibrary.request();
    print(status);

    if (status.isGranted || await Permission.storage.request().isGranted) {
      _startDownload(name, urldata);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Required'),
          content: Text(
            'Please grant permission to access storage for downloading files.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Permission.mediaLibrary.request();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  _buildMailPopupDialog(BuildContext context, int typeIds, String emails) {
    return StatefulBuilder(builder: (context, setState) {
      sendemailController.text = emails.toString();
      sendnameController.text = emails.toString();
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        insetPadding: EdgeInsets.all(10),
        content: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 8),
                  child: IconButton(
                    icon: SvgPicture.asset("images/cr.svg"),
                    onPressed: () {
                      setState(() {
                        sendnameController.text = "";
                        sendemailController.text = "";
                        sendjobController.text = "";
                        sendphoneController.text = "";
                        sendmobileController.text = "";
                        schedulecompanyId = null;
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      child: RadioListTile(
                        title: Text(
                          "Individual",
                          style: TextStyle(fontSize: 12, fontFamily: 'Mulish'),
                        ),
                        value: "person",
                        groupValue: radioInput,
                        onChanged: (value) {
                          setState(() {
                            radioInput = value.toString();
                            // cmpVisibility = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 30,
                      child: RadioListTile(
                        title: Text(
                          "Company",
                          style: TextStyle(fontSize: 12, fontFamily: 'Mulish'),
                        ),
                        value: "company",
                        groupValue: radioInput,
                        onChanged: (value) {
                          setState(() {
                            radioInput = value.toString();
                            //   cmpVisibility = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.emailAddress,
                    controller: sendnameController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAFAFAF), width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: SearchChoices.single(
                    //items: items,
                    fieldPresentationFn: (Widget fieldWidget,
                        {bool? selectionIsValid}) {
                      return Container(
                        padding: const EdgeInsets.all(0),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Company Name',
                            isDense: true,
                            labelStyle: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w500),
                            fillColor: Colors.white,
                          ),
                          child: fieldWidget,
                        ),
                      );
                    },

                    value: schedulecompanyName,

                    searchHint: null,
                    autofocus: true,
                    onClear: () {
                      setState(() {
                        //cmpbasedVisible = true;
                      });
                    },
                    onChanged: (value) async {
                      setState(() {
                        schedulecompanyName = value;
                        schedulecompanyId = value["id"];
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
                        //width: 320,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          item["display_name"],
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Mulish',
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      )));
                    },
                    futureSearchFn: (String? keyword,
                        String? orderBy,
                        bool? orderAsc,
                        List<Tuple2<String, String>>? filters,
                        int? pageNb) async {
                      token = await getUserJwt();
                      baseUrl = await getUrlString();
                      Response response = await get(
                        Uri.parse(
                            "${baseUrl}api/customers?page_no=${pageNb ?? 1}&count=10${keyword == null ? "" : "&filter=$keyword"}&model=partner"),
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
                                        child: Text("${item["display_name"]}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Mulish',
                                                fontWeight: FontWeight.w600)),
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
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    controller: sendjobController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAFAFAF), width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Job Position',
                        labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.emailAddress,
                    controller: sendemailController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAFAFAF), width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),

                        // border: UnderlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.phone,
                    // maxLength: 10,
                    controller: sendphoneController,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAFAFAF), width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Phone',
                        labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }

                      if (int.tryParse(value) == null) {
                        return 'Phone number should only contain digits';
                      }

                      if (value.length < 10) {
                        return 'Phone number should contain at least 10 digits';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    keyboardType: TextInputType.phone,
                    // maxLength: 10,
                    controller: sendmobileController,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAFAFAF), width: 0.5),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFAFAFAF)),
                        ),
                        labelText: 'Mobile',
                        labelStyle: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w500)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return null;
                      }

                      if (int.tryParse(value) == null) {
                        return 'Mobile number should only contain digits';
                      }

                      if (value.length < 10) {
                        return 'Mobile number should contain at least 10 digits';
                      }

                      return null;
                    },
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
                                  "Save",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.57,
                                      color: Colors.white,
                                      fontFamily: 'Mulish'),
                                ),
                              ),
                              onPressed: () async {
                                scheduleCustcreateId =
                                    await schedulecreateCustomer(
                                        radioInput,
                                        sendnameController.text,
                                        sendemailController.text,
                                        sendjobController.text,
                                        sendphoneController.text,
                                        sendmobileController.text,
                                        schedulecompanyId);

                                print(scheduleCustcreateId);
                                print("final responce");

                                if (scheduleCustcreateId != 0) {
                                  setState(() {
                                    sendnameController.text = "";
                                    sendemailController.text = "";
                                    sendjobController.text = "";
                                    sendphoneController.text = "";
                                    sendmobileController.text = "";
                                    schedulecompanyId = null;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF043565),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
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
                              onPressed: () {
                                setState(() {
                                  sendnameController.text = "";
                                  sendemailController.text = "";
                                  sendjobController.text = "";
                                  sendphoneController.text = "";
                                  sendmobileController.text = "";
                                  schedulecompanyId = null;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF043565),
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

  _buildColorPopupDialog(BuildContext context, var colors, int selectedtagId) {
    print(colors.length);
    print(selectedtagId);
    print("final colorss");
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width / 1.5,
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal, // Direction is horizontal
              spacing: 8.0, // Space between items
              runSpacing: 8.0, // Space between rows (if wrapping)
              children: List.generate(colors.length ?? 0, (int index) {
                return FractionallySizedBox(
                  widthFactor: null,
                  child: InkWell(
                    onTap: () async {
                      int selectedColorId = colors[index]["color"];

                      String value = await colorChange(
                          selectedtagId, selectedColorId, "crm.tag");

                      print(value);
                      print("finalidididid");
                      if (value == "success") {
                        setState(() {
                          tagChangeColoir = colors[index]["code"];
                        });
                      }

                      Navigator.pop(context);
                      print(colors[index]["code"]);
                      print(colors[index]["color"]);
                      print("color code");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(int.parse(colors[index]["code"])),
                      ),
                      width: 30,
                      height: 30,
                    ),
                  ),
                );
              }),
            ),
          ));
    });
  }

  getColors() async {
    var data = await colorsData();

    print(data['records']);
    print("lastlast");
    print(data.length);

    data.length == 0 ? data = [] : data = data['records'];

    return data;
  }

  String removeHtmlTagsAndSpaces(String input) {
    // Remove HTML tags
    final noHtmlTags = input.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove extra white spaces
    final noExtraSpaces = noHtmlTags.replaceAll(RegExp(r'\s+'), ' ');

    // Trim leading and trailing spaces
    return noExtraSpaces.trim();
  }

  void _dismissDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  logNoteEditData(List myData1, int lognoteId) async {
    try {
      var value = await EditlogNote(lognoteEditController.text, "crm.lead",
          widget.opportunityId, myData1, lognoteId);

      print(value);
      print("valuesss");
      return value;
    } catch (e) {
      errorMethod(e);
    }
  }

  void errorMethod(e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('${e.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void errorMethod1(e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('${e.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                lognoteController.text = "";
                setState(() {
                  _isSavingData = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void errorMethod2(e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('${e.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {
                  _isSavingData = false;
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void errorMethod3(e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('${e.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void convertQuotationError(e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('${e.toString()}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void delayMethod() {
    Future.delayed(Duration(seconds: 1), () {
      // Ensure that the widget is still mounted before rebuilding
      if (mounted) {
        postProvider?.fetchPosts(widget.opportunityId);
      }
    });
  }
}

class PostProvideropportunity extends ChangeNotifier {
  Map<String, List<Map<String, dynamic>>>? _posts;
  int _savefile = -1;

  // List<Post> get posts => _posts!;
  get posts => _posts;
  get savefiles => _savefile;

  Future fetchPosts1(int positionId) async {
    print("SdcondClickss");
    _savefile = positionId;

    notifyListeners();
  }

  Future fetchPosts(opportunityId) async {
    _posts = await getlogNoteData(opportunityId, "crm.lead");
    _savefile = -1;
    print("SdcondClick");
    print(_posts);
    notifyListeners();
    // return _posts;
  }
}
