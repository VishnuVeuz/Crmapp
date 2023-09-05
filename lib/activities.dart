 import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'drawer.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {

  String ? salesperImg;
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
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(icon: SvgPicture.asset("images/messages.svg"),
                    onPressed: () {

                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: IconButton(icon: SvgPicture.asset("images/clock2.svg"),
                    onPressed: () {

                    },
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
          child: ListView.builder(
            itemCount: 4,

            itemBuilder: (_, i) {

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Text("lead"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0,bottom: 0,left: 180,right: 20),
                              child: IconButton(icon: SvgPicture.asset("images/clock.svg"),
                                onPressed: () {

                                },
                              ),
                            ),
                          ],
                        )

                      ],
                ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 65),
                            child: TextButton(onPressed: (){},
                                child:Row(
                                  children: [
                                    Text("4",style: TextStyle(color: Colors.green[800]),),
                                    SizedBox(width: 5,),
                                    Text("Late",style: TextStyle(color: Colors.green[800])),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: TextButton(onPressed: (){},
                                child:Row(
                                  children: [
                                    Text("4",style: TextStyle(color: Colors.green[800])),
                                    SizedBox(width: 5,),
                                    Text("Today",style: TextStyle(color: Colors.green[800])),
                                  ],
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 45),
                            child: TextButton(onPressed: (){},
                                child:Row(
                                  children: [
                                    Text("4",style: TextStyle(color: Colors.green[800])),
                                    SizedBox(width: 5,),
                                    Text("Future",style: TextStyle(color: Colors.green[800])),
                                  ],
                                )),
                          ),

                        ],
                      )
                    ],
                  ),
              );
            },
          ),
      ),
    );
  }
}
