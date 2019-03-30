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

    //Check is user already exist and skip error
    if (await isAccountExistInFirestore(phone).catchError((err) {}))
      throw 'Пользователь с таким номером телефона уже существует';

    await _signInByPhone(userName, phone, dialog, auth);
  }

  //Method to sign in into firebaseAuth, it uses to log in or sign in
  Future<Null> _signInByPhone(String userName, String phone,
      ShowSmsCheckDialog dialog, UserAuthenticated auth) async {
    String verificationId;

    ///Verify sms code by checking is user already authenticated
    /// if not then sign in with credential
    final ConfirmSmsFunc verifySmsCode = (String sms) async {
      var fireUser = await FirebaseAuth.instance.currentUser();
      _user = User(userName, phone);

      print('Firebase user in signIn: ${fireUser}');
      if (fireUser == null) {
        try {
          await FirebaseAuth.instance.signInWithCredential(
              PhoneAuthProvider.getCredential(
                  verificationId: verificationId, smsCode: sms));
        } catch (e) {
          //If SMS code is wrong
          auth(false);
          return;
        }
      }

      await createFieldInDatabase();
      await saveToCache();
      auth(true);
    };

    ///Supporting callbacks for verifying phone number
    final autoRetrieve = (String verId) async {
      verificationId = verId;

      _user = User(userName, phone);
      if (!await isAccountExistInFirestore(phone))
        await createFieldInDatabase();

      auth(true);
    };
    final smsCodeSent = (String verId, [int forceCodeResult]) {
      verificationId = verId;
      dialog(verifySmsCode);
    };
    final verifiedSuccess = (FirebaseUser user) async {
      _user = User(userName, phone);
      if (!await isAccountExistInFirestore(phone))
        await createFieldInDatabase();

      auth(true);
    };
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

  ///Check is user exist in firestore
  Future<bool> isAccountExistInFirestore(String phone) async {
    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .where('userPhone', isEqualTo: phone)
        .getDocuments();

    if (snap.documents.length == 0) return false;

    return true;
  }

  ///Log in user with it's phone number
  Future<Null> logInByPhoneNumber(String phone, ShowSmsCheckDialog dialog,
      UserAuthenticated auth) async {
    //Check is user already exist
    if (!await isAccountExistInFirestore(phone))
      throw 'Пользователь с таким номером не существует';

    QuerySnapshot snap = await Firestore.instance
        .collection('users')
        .where('userPhone', isEqualTo: phone)
        .getDocuments();

    await _signInByPhone(
        snap.documents[0].data['userName'], phone, dialog, auth);
  }
}

//This callback needs to notify UI that user had been authenticated
typedef UserAuthenticated = Function(bool auth);

//This callback needs to show dialog to verify sms code
typedef ShowSmsCheckDialog = Function(ConfirmSmsFunc verifySmsFunc);

///This callback must be called into [ShowSmsCheckDialog] to verify sms
typedef ConfirmSmsFunc = Function(String sms);
