 import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'api.dart';
import 'drawer.dart';

class ActivitiesNotification extends StatefulWidget {
  const ActivitiesNotification({Key? key}) : super(key: key);

  @override
  State<ActivitiesNotification> createState() => _ActivitiesNotificationState();
}

class _ActivitiesNotificationState extends State<ActivitiesNotification> {

  String ? salesperImg;
  List notificationData=[];
  bool _isInitialized = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifications();
  }

  String? token;

  @override
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
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        elevation: 0,
        title: Row(
          children: [
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
                Container(
                  child: Stack(
                      alignment: Alignment
                          .center,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset("images/messages.svg"),
                          onPressed: () {

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
                            child: Center(child: Text("12", style: TextStyle(
                                color: Colors.white, fontSize: 8),)),
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
                            child: Center(child: Text("12", style: TextStyle(
                                color: Colors.white, fontSize: 8),)),
                          ),
                        ),
                      ]
                  ),
                ),

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
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: ListView.builder(
          itemCount: notificationData.length,

          itemBuilder: (_, i) {
            return Card(
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      notificationData[i]["icon"] != ""
                          ? Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Container(
                          width: 45,
                          height: 55,

                          child: CircleAvatar(
                            radius: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1),
                              child: Image.network(
                                  notificationData[i]["icon"]),
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),

                        ),
                      ),

                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(notificationData[i]["name"]),
                          ),
                          Column(
                            children: [
                              IconButton(

                                icon: SvgPicture.asset("images/clock.svg"),
                                onPressed: () {

                                },
                              ),

                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left:20,bottom: 20),
                            child: InkWell(
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(notificationData[i]["overdue_count"]
                                        .toString(),
                                      style: TextStyle(color: Colors.green[800]),),
                                    SizedBox(width: 5,),
                                    Text("Late",
                                        style: TextStyle(color: Colors.green[800])),
                                  ],
                                ),
                              ),
                              onTap: (){

                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:50,bottom: 20),
                            child: InkWell(
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(notificationData[i]["today_count"]
                                        .toString(),
                                        style: TextStyle(color: Colors.green[800])),
                                    SizedBox(width: 5,),
                                    Text("Today",
                                        style: TextStyle(color: Colors.green[800])),
                                  ],
                                ),
                              ),
                              onTap: (){},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 50,bottom: 20),
                            child: InkWell(
                              child: Container(
                                child: Row(
                                  children: [
                                    Text(notificationData[i]["planned_count"]
                                        .toString(),
                                        style: TextStyle(color: Colors.green[800])),
                                    SizedBox(width: 5,),
                                    Text("Future",
                                        style: TextStyle(color: Colors.green[800])),
                                  ],
                                ),
                              ),
                              onTap: (){},
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  }


  notifications() async {
    token = await getUserJwt();

    var data = await getNotificationActivity();
    setState(() {

      notificationData = data;
      _isInitialized = true;
    });



  }
}
