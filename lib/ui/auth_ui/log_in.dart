import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';
import 'package:personal_chat/repositories/user_repository.dart';
import 'package:personal_chat/ui/auth_ui/sms_dialog.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({Key key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Callback that notify when user authenticated
    UserAuthenticated authenticated = (bool auth) {
      if (!auth)
        Fluttertoast.showToast(msg: 'Неверный SMS код');
      else
        BlocProvider.of<AuthenticationBloc>(context)
            .dispatch(AuthAuthenticatedEvent());
    };

    //Callback to show dialog to confirm SMS code
    ShowSmsCheckDialog dialog = (ConfirmSmsFunc func) {
      showDialog(
          context: context,
          builder: (context) => SmsVerifyDialog(
                smsFunc: func,
              ));
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 170.0,
              child: TextField(
                textAlign: TextAlign.center,
                controller: _phoneController,
                maxLines: 1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '+7 777 666 33 22'),
                onChanged: (newText) {
                  if (!_phoneController.text.contains('\+'))
                    _phoneController.text = '+${newText}';
                },
              ),
            ),

            SizedBox(
              height: 10.0,
            ),

            Container(
              width: 300.0,
              child: Text(
                'На указанный номер телефона будет отправлено SMS '
                    'для подтверждения, оно будет действительно в течение 60 сек.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            RaisedButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .userRepository
                    .logInByPhoneNumber(_phoneController.text, dialog, authenticated)
                    .catchError(
                        (err) => Fluttertoast.showToast(msg: err.toString()));
              },
              elevation: 5.0,
              color: Colors.purpleAccent[400],
              textColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                'Войти',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 30.0),
            FlatButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(AuthSignInEvent());
              },
              textColor: Colors.purpleAccent[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text('Нет аккаунта?'),
            ),
          ],
        ),
      ),
    );
  }
}
