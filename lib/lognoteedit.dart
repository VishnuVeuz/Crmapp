import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'api.dart';
import 'drawer.dart';
import 'lead_detail.dart';

class LogNoteEdit extends StatefulWidget {

  int lognoteId,typeId;
  String salesperImg,token,logdata;

  LogNoteEdit(this.lognoteId,this.salesperImg,this.token,this.typeId,this.logdata);
  @override
  State<LogNoteEdit> createState() => _LogNoteEditState();
}

class _LogNoteEditState extends State<LogNoteEdit> {
  bool isLoading = true;
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();



  TextEditingController lognoteController = TextEditingController();

  List<dynamic> selectedImagesDisplay = [];
  String imagepath = "";
  String personImg="";
  List base64string1 = [];
  List<Map<String, dynamic>> myData1 = [];
  String base64string="";
  int lognoteDatalength = 0;

  Map<String, dynamic>? lognoteData;
  List logDataHeader = [];
  List logDataTitle=[];
  List ddd2=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lognoteController.text = widget.logdata;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0,
        title: Row(
          children: [
            // Text("New", style: TextStyle(
            //     fontWeight: FontWeight.w700,
            //     fontSize: 15,
            //     color: Colors.white,
            //     decoration: TextDecoration.none),)
          ],
        ),
        leading: Builder(
          builder: (context) =>
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: IconButton(icon: Image.asset("images/back.png"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(icon: SvgPicture.asset("images/drawer.svg"),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            );
          })
        ],
      ),
      body:  Container(
        width: MediaQuery.of(context).size.width,

        height: MediaQuery.of(context).size.height,
        // color: Colors.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                widget.salesperImg != "" ?
                Padding(
                  padding: const EdgeInsets
                      .only(left: 25),
                  child: Container(
                    width: 30,
                    height: 30,

                    decoration: BoxDecoration(
                      border: Border.all(
                      ),
                      borderRadius: BorderRadius
                          .all(
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
                            "${widget.salesperImg!}?token=${widget.token}"),


                      ),


                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(left: 25),
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
                  padding: const EdgeInsets.only(left: 20,right: 20,top: 60),
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    //height: 46,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(
                                0xFFEBEBEB))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/1.5,
                          // height: 40,
                          // color: Colors.red,
                          child:Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                                controller: lognoteController,
                                decoration:
                                const InputDecoration(
                                    border:
                                    InputBorder.none,
                                    hintText:
                                    "Send a message to followers",
                                    hintStyle: TextStyle(
                                      //fontFamily: "inter",
                                        fontWeight:
                                        FontWeight
                                            .w400,
                                        fontFamily: 'Mulish',
                                        fontSize: 10,
                                        color: Colors.grey))),
                          ),
                        ),
                        Divider(color: Colors.grey,),

                        IconButton(
                          icon: Image.asset(
                              "images/pin.png"),
                          onPressed: () {

                            myAlert();
                          },
                        ),
                      ],
                    ),
                  ),
                )

              ],
            ),


            selectedImages.isEmpty ?  Padding(
              padding: const EdgeInsets.only(left:73),
              child: Container(

                width:
                MediaQuery
                    .of(context)
                    .size
                    .width,
                // height: 40,
              ),
            )
                :
            Padding(
              padding: const EdgeInsets.only(left:70,right: 50),
              child: Container(

                width:
                MediaQuery
                    .of(context)
                    .size
                    .width,
                // height: 40,
                child: Container(
                  width: 40,
                  //height: 40,
                  child: GridView.builder(
                    shrinkWrap: true, // Avoid scrolling
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                    selectedImages.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8),
                    itemBuilder:
                        (BuildContext context,
                        int index) {
                      return Center(
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
              padding: const EdgeInsets.only(
                  bottom: 20,left: 73,top: 5),
              child: SizedBox(
                width: 56,
                height: 28,
                child: ElevatedButton(
                    child: Center(
                      child: Text(
                        "Log",
                        style: TextStyle(
                            fontWeight: FontWeight
                                .w700,
                            fontSize: 11,
                            fontFamily: 'Mulish',
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      for (int i = 0;
                      i < selectedImages.length;
                      i++) {
                        imagepath = selectedImages[i]
                            .path
                            .toString();
                        File imagefile = File(
                            imagepath); //convert Path to File
                        Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
                        base64string = base64.encode(imagebytes);

                        // base64string1.add(
                        //     base64string);
                        //

                        String dataImages =
                            '{"name":"name","type":"binary","datas":"${base64string.toString()}"}';

                        Map<String, dynamic> jsondata = jsonDecode(dataImages);
                        myData1.add(jsondata);

                      }
                      // print(myData1);
                      // print("final datatata");

                      String resMessage = await logNoteData(myData1);



                      if(resMessage != 0){

                        setState(() {
                          lognoteController.text= "";
                          selectedImages.clear();
                          myData1.clear();
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LeadDetail(widget.typeId)),);

                      }

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF9246A),
                    )),
              ),
            ),
          ],
        ),



      ),
    );
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImages();
                      //getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      print("system 2");
                      getImage(ImageSource.camera);

                      //getImages();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
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

  logNoteData(List myData1) async{

    String value = await EditlogNote(lognoteController.text,"lead.lead",widget.typeId,myData1,widget.lognoteId);

    print(value);
    print("valuesssdemooooo");
    return value;

  }

}

