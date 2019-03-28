import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              maxLines: 1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: '+7 777 666 33 22'),
            ),
            RaisedButton(
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .dispatch(AuthAuthenticatedEvent());
              },
              elevation: 5.0,
              color: Colors.purpleAccent[400],
              textColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text('Войти'),
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
