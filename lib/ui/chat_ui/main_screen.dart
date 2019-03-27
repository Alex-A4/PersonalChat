import 'package:flutter/material.dart';
import 'package:personal_chat/models/chat.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

//TODO: wrap listView with streamBuilder to update chats in real time
class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Диалоги'),
      ),
      body: ListView.builder(
        itemCount: 25,
        itemBuilder: (context, index) {
          return getListItem(null, index);
        },
      ),
    );
  }

  //Get the item of list
  //TODO: add getting info about user by hash
  Widget getListItem(Chat chat, int index) {
    return ListTile(
      title: Text('User Name'),
      subtitle: Text(
        'The last message that other user past to that user. We need to do something with that',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),

      //If last message not read so show icon
      trailing: index % 2 == 0
          ? Container(
              width: 1,
              height: 1,
            )
          : Container(
              decoration: ShapeDecoration(
                  color: Colors.purpleAccent[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
              width: 6,
              height: 6,
            ),
    );
  }
}
