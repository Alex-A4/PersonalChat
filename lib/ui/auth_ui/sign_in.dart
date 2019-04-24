import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';
import 'package:personal_chat/main.dart';
import 'package:personal_chat/ui/auth_ui/sms_dialog.dart';
import '../../repositories/user_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
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
                key: ValueKey("SmsDialog"),
                smsFunc: func,
              ));
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Регистрация'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .dispatch(AuthLogInEvent());
            }),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Номер телефона', style: TextStyle(fontSize: 16.0)),
                  Container(
                    width: 150.0,
                    child: TextField(
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: true),
                      textAlign: TextAlign.center,
                      controller: _phoneController,
                      decoration: InputDecoration(hintText: '+7 777 666 33 22'),
                      maxLines: 1,
                      onChanged: (newText) {
                        if (!_phoneController.text.contains('\+'))
                          _phoneController.text = '+${newText}';
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'На указанный номер телефона будет отправлено SMS '
                    'для подтверждения, оно будет действительно в течение 60 сек.',
                style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Имя пользователя', style: TextStyle(fontSize: 16.0)),
                  Container(
                    width: 150.0,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: _nameController,
                      maxLines: 1,
                      decoration: InputDecoration(hintText: 'Фёдоров Василий'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50.0,
              ),
              RaisedButton(
                //TODO: add checking phone with RegExp
                onPressed: () {
                  if (_phoneController.text.isNotEmpty)
                    BlocProvider.of<AuthenticationBloc>(context)
                        .userRepository
                        .signInByPhoneNumber(_nameController.text,
                            _phoneController.text, dialog, authenticated)
                        .catchError((err) =>
                            Fluttertoast.showToast(msg: err.toString()));
                },
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: lightTheme.buttonColor,
                textColor: Colors.white,
                child: Text(
                  'Зарегистрироваться',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
