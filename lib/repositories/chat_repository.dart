import 'package:personal_chat/models/chat.dart';
import 'package:personal_chat/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository that describes communication between firebase and phone
///
/// This repository is a singleton instance that creates with [buildInstance]
///
/// That's contains info about all chats where user participate
class ChatRepository {
  //Json codec to decode/encode json objects
  final JsonCodec _codec = JsonCodec();

  //Instance of user repository, needs to get info about user
  UserRepository _userRepository;

  //Singleton instance of class
  static ChatRepository _instance;

  static ChatRepository getInstance() => _instance;

  ///Build instance of chat by restoring from cache
  /// It must be called before [getInstance]
  static Future buildInstance(UserRepository userRepo) async {
    _instance = ChatRepository._();
    _instance._userRepository = userRepo;

    await _instance._restoreFromCache();
  }

  //List of chats where user participate
  final List<Chat> chats;

  //Default constructor where chats initialize
  ChatRepository._() : chats = [];

  //Restore chat instance from local cache
  Future _restoreFromCache() async {
    var prefs = await SharedPreferences.getInstance();

    String chatsString = prefs.getString('chats');
    if (chatsString != null) {
      _codec
          .decode(chatsString)
          .forEach((chatJson) => chats.add(Chat.fromJson(chatJson)));
    }
  }

  //Save info about chats to local cache
  Future saveToCache() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'chats', _codec.encode(chats.map((chat) => chat.toJson()).toList()));
  }

  ///Get all chats where user participate
  /// Chats in firebase looks like:
  /// (collection)chats -> (document){} ->
  Future getUserChats() async {
//    Firestore.instance.collection('chats').document('111').collection('').snapshots()

    //Find any chats where user participate
    QuerySnapshot doc1 = await Firestore.instance
        .collection('chats')
        .where('person1', isEqualTo: _userRepository.user.hashCode.toString())
        .getDocuments();
    QuerySnapshot doc2 = await Firestore.instance
        .collection('chats')
        .where('person2', isEqualTo: _userRepository.user.hashCode.toString())
        .getDocuments();

    //Put all founded chats references into one list
    List<DocumentReference> chatsWithUser = [];
    chatsWithUser..addAll(
        doc1.documents.map((doc) => doc.reference).toList())..addAll(
        doc2.documents.map((doc) => doc.reference).toList());
  }
}
