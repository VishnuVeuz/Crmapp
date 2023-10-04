import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
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
                    child: Container(
                      width: 200,
                      //color: Colors.red,
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            // border: OutlineInputBorder(
                            //
                            // ),
                            hintText: 'Enter a search term',
                            hintStyle: TextStyle(
                                color: Colors.grey
                            )
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(color: Colors.grey[800],),
                  IconButton(onPressed: (){}, icon:Icon(Icons.emoji_emotions_outlined),

                  ),
                  IconButton(onPressed: (){}, icon:Icon(Icons.attachment_outlined),
                  ),
                  SizedBox(width: 5,),

                  InkWell(
                    child: Container(
                      width: MediaQuery.of(context).size.width/6.2,
                      height:MediaQuery.of(context).size.height,
                      color: Color(0xFFF9246A),
                      child: Icon(Icons.near_me,color: Colors.white,),
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
    );
  }
}





