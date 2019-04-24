import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key, this.bloc}) : super(key: key);

  final AuthenticationBloc bloc;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AuthenticationBloc get bloc => widget.bloc;
  bool nightMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Настройки')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Ночной режим'),
              trailing: Switch(
                  value: nightMode,
                  onChanged: (newValue) {
                    setState(() => nightMode = newValue);
                    DynamicTheme.of(context).setBrightness(
                        nightMode ? Brightness.dark : Brightness.light);
                  }),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Выйти'),
              onTap: () {
                Navigator.of(context).pop();

                bloc
                  ..userRepository.logOutUser()
                  ..dispatch(AuthLogInEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}
