import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';
import 'package:personal_chat/ui/auth_ui/sms_dialog.dart';
import '../../repositories/user_repository.dart';

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
        print('Bad');
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
      appBar: AppBar(title: Text('Регистрация')),
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
                  Text('Номер телефона'),
                  Container(
                    width: 150.0,
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(hintText: '+7 777 666 33 22'),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Text(
                'На указанный номер телефона будет отправлено SMS для подтверждения',
                style: TextStyle(color: Colors.grey[600], fontSize: 16.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Имя пользователя'),
                  Container(
                    width: 150.0,
                    child: TextField(
                      controller: _nameController,
                      maxLines: 1,
                      decoration: InputDecoration(hintText: 'Фёдоров Василий'),
                    ),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context)
                      .userRepository
                      .signInByPhoneNumber(_nameController.text,
                          _phoneController.text, dialog, authenticated);
                },
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: Colors.purple[400],
                textColor: Colors.white,
                child: Text('Зарегистрироваться'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
