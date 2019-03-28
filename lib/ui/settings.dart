import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_chat/bloc/authentication/auth.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool nightMode = false;

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
                    nightMode = newValue;
                    DynamicTheme.of(context).setBrightness(
                        nightMode ? Brightness.dark : Brightness.light);
                  }),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Выйти'),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
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
