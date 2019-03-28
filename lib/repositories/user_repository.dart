import 'package:personal_chat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../mixins/connection.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

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

  /// Delete all data about user on that phone,
  /// especially cache, firebase data
  Future logOutUser() async {
    var prefs = await SharedPreferences.getInstance();
    //Clear cache
    await prefs.clear();
    //Clear firebase user
    await FirebaseAuth.instance.signOut();
  }

  ///Write new field about user into the firestore if it's not exist
  /// [_user] must not be null
  /// This method should be used after the [signInByPhoneNumber] method
  Future<Null> createFieldInDatabase() async {
    if (!await isConnected()) throw 'Check internet connectivity!';
    assert(_user == null, 'User must not be null');

    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .where('userPhone', isEqualTo: _user.phoneNumber)
        .getDocuments();

    ///Create new record in firestore
    if (snap.documents.length == 0)
      await Firestore.instance
          .collection('users')
          .document(_user.hashCode.toString())
          .setData({
        'userName': _user.name,
        'userPhone': _user.phoneNumber,
        'userHash': _user.hashCode
      });
  }

  /// Verify phone number using firebase
  /// There needs 4 points: [userName] the name of user,
  /// [phone] the number of phone which need verify
  /// [dialog] the callback that creates dialog to enter sms code
  /// [auth] the callback that notified when user had been authenticated
  Future<Null> signInByPhoneNumber(String userName, String phone,
      ShowSmsCheckDialog dialog, UserAuthenticated auth) async {
    if (!await isConnected()) throw 'Check internet connectivity!';

    String verificationId;

    ///Verify sms code by checking is user already authenticated
    /// if not then sign in with credential
    final ConfirmSmsFunc verifySmsCode = (String sms) async {
      var fireUser = await FirebaseAuth.instance.currentUser();
      _user = User(userName, phone);

      if (fireUser == null)
        await FirebaseAuth.instance.signInWithCredential(
            PhoneAuthProvider.getCredential(
                verificationId: verificationId, smsCode: sms));

      await createFieldInDatabase();
      auth(true);
    };

    ///Supporting callbacks for verifying phone number
    final autoRetrieve = (String verId) => verificationId = verId;
    final smsCodeSent = (String verId, [int forceCodeResult]) {
      verificationId = verId;
      print('VerId : $verificationId');
      dialog(verifySmsCode);
    };
    final verifiedSuccess = (FirebaseUser user) => auth(true);
    final verifiedFailed = (AuthException exception) => auth(false);

    //Calling method to verify phone number with sms code
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiedFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }
}

//This callback needs to notify UI that user had been authenticated
typedef UserAuthenticated = Function(bool auth);

//This callback needs to show dialog to verify sms code
typedef ShowSmsCheckDialog = Function(ConfirmSmsFunc verifySmsFunc);

///This callback must be called into [ShowSmsCheckDialog] to verify sms
typedef ConfirmSmsFunc = Function(String sms);
