import 'package:personal_chat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mixins/connection.dart';
import 'dart:convert';

class UserRepository with Connection {
  final JsonCodec codec = JsonCodec();

  User _user;

  User get user => _user;

  UserRepository();

  ///Restore data about user from local cache
  Future<Null> restoreFromCache() async {
    var prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('user');
    if (data != null) _user = User.fromJson(codec.decode(data));
  }

  ///Check is user had been loaded
  bool isUserExist() => _user != null;

  ///Save data about user to local cache
  Future<Null> saveToCache() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', codec.encode(_user.toJson()));
  }

  ///Save all data about user to cloud firestore
  Future<Null> saveToCloud() async {
    if (!await isConnected()) throw 'Check internet connectivity!';

    await Firestore.instance
        .collection('users')
        .document(_user.hashCode.toString())
        .setData({'userName': _user.name, 'userPhone': _user.phoneNumber});
  }

  //Restore all data about user from cloud firestore
  Future<Null> restoreFromCloud() async {
    if (!await isConnected()) throw 'Check internet connectivity!';

    DocumentSnapshot snapshot = await Firestore.instance
        .collection('users')
        .document(_user.hashCode.toString())
        .get();

    //TODO: Add getting data from [data]
    Map<String, dynamic> data = snapshot.data;

    await saveToCache();
  }
}
