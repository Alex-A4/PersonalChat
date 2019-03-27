import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({Key key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
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
          ],
        ),
      ),
    );
  }
}
