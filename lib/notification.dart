import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'chatpage.dart';
import 'drawer.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
 // int _selectedIndex = 0;

  String ? salesperImg;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  //}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          children: [

          ],
        ),
        leading: Builder(
          builder: (context) => Padding(
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
                        IconButton(icon: SvgPicture.asset("images/messages.svg"),
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
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.3,
              //color: Colors.red,

              child: ListView.builder(
                itemCount: 4,

                itemBuilder: (_, i) {

                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20,bottom: 10),
                          child: Row(
                            children: [
                              salesperImg != ""
                                  ? Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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

                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text("lead"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 0,bottom: 0,left: 140,right: 20),
                                  child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width/3.5,
                                //color: Colors.red,
                                      child: Text("3 months ago",style: TextStyle(color: Colors.grey[800]),))


                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,top: 10),
                              child: Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width/1.5,
                                //color: Colors.red,
                                  child: Text("message",style: TextStyle(color: Colors.grey),)),
                            ),

                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Card(),
            Spacer(),
            // Divider(color: Colors.grey[800],),
            Container(
              // width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/13.5,
              //color: Colors.blue,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey
                  )
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      child: Container(
                        width: 100,
                        //color: Colors.red,
                        child: Column(
                          children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(Icons.person),
                              ),
                            Text("Chat")
                          ],
                        ),

                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ChatPage()),
                        );
                      },
                    ),
                  ),
                  VerticalDivider(color: Colors.grey[800],),
                  InkWell(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Text("New message",style: TextStyle(fontSize: 16),),
                      ),
                    ),
                    onTap: (){},
                  )

                ],
              ),

              //color: Colors.white,
            )

          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //
      //       icon: Icon(Icons.business),
      //       label: 'Business',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.school),
      //       label: 'School',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
    );
  }
}
