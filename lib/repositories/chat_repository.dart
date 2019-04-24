import 'package:personal_chat/models/chat.dart';
import 'package:personal_chat/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mixins/connection.dart';

/// Repository that describes communication between firebase and phone
///
/// This repository is a singleton instance that creates with [buildInstance]
///
/// That's contains info about all chats where user participate
class ChatRepository with Connection {
  //Json codec to decode/encode json objects
  final JsonCodec _codec = JsonCodec();

  //Instance of user repository, needs to get info about user
  UserRepository _userRepository;

  //Singleton instance of class
  static ChatRepository _instance;

  static ChatRepository getInstance() => _instance;

  ///Build instance of chat by restoring from cache
  /// It must be called before [getInstance]
  static Future<void> buildInstance(UserRepository userRepo) async {
    _instance = ChatRepository._();
    _instance._userRepository = userRepo;

    await _instance._restoreFromCache();
  }

  //List of chats where user participate
  final List<Chat> chats;

  //Default constructor where chats initialize
  ChatRepository._() : chats = [];

  //Restore chat instance from local cache
  Future<void> _restoreFromCache() async {
    var prefs = await SharedPreferences.getInstance();

    String chatsString = prefs.getString('chats');
    if (chatsString != null) {
      _codec
          .decode(chatsString)
          .forEach((chatJson) => chats.add(Chat.fromJson(chatJson)));
    }
  }

  //Save info about chats to local cache
  Future<void> saveToCache() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('chats', getChatsInJsonString());
  }

  String getChatsInJsonString() =>
      _codec.encode(chats.map((chat) => chat.toJson()).toList());

  ///Get all chats where user participate
  /// Chats in firebase looks like:
  /// (collection)chats -> (document){} ->
  Future<void> getUserChats() async {
    if (!await isConnected()) throw 'Check inet';

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
    chatsWithUser
      ..addAll(doc1.documents.map((doc) => doc.reference).toList())
      ..addAll(doc2.documents.map((doc) => doc.reference).toList());

    print('Count of chats with user : ${chatsWithUser.length}');

    /// TODO: add listening of streams
    chatsWithUser.forEach((chat) {
      chat.snapshots().listen(
          (snap) => print('In Chat ${chat.documentID}, data : ${snap.data}'));
    });
  }

  ///Creating new chat into firebase with specified interlocutor which could
  /// be identify with [interlocutorHash]
  Future<void> createNewChat(int interlocutorHash) async {
    if (!await isConnected()) throw 'Check inet';

    Chat chat = Chat(
        hashPerson1: _userRepository.user.hashCode,
        hashPerson2: interlocutorHash);

    chats.add(chat);

    //Add new chat instance to firebase
    DocumentReference chatRef =
        await Firestore.instance.collection('chats').add({
      'person1': _userRepository.user.hashCode,
      'person2': interlocutorHash,
      'chatHash': chat.hashCode
    });
  }

  /// Read DB and find user with [phoneNumber] and then return his hash
  /// or null if there is no user with that number
  Future<int> findUserHashByPhoneNumber(String phoneNumber) async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .where('userPhone', isEqualTo: phoneNumber)
        .getDocuments();
    if (snap.documents.length != 0)
      return snap.documents[0].data['userHash'];
    else return null;
  }
}
