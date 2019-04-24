import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';
import 'package:personal_chat/models/chat.dart';
import 'package:personal_chat/repositories/chat_repository.dart';
import 'package:personal_chat/ui/settings.dart';

//TODO: wrap listView with streamBuilder to update chats in real time
class MainScreen extends StatelessWidget {
  ChatRepository _chatRepo = ChatRepository.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Диалоги'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              var bloc = BlocProvider.of<AuthenticationBloc>(context);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SettingsScreen(bloc: bloc)));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _chatRepo.chats.length,
        itemBuilder: (context, index) {
          return getListItem(_chatRepo.chats[index]);
        },
      ),
    );
  }

  //Get the item of list
  Widget getListItem(Chat chat) {
    var interlocutorPhone =
        chat.person1Phone == _chatRepo.userRepository.user.phoneNumber
            ? chat.person2Phone
            : chat.person1Phone;
    return ListTile(
      title: Text(interlocutorPhone),
      subtitle: Text(
        chat.messages.first.context,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),

      //If last message not read so show icon
      trailing: chat.messages.first.isRead
          ? Container()
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
