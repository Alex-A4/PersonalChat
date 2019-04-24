import 'package:flutter/material.dart';
import 'package:personal_chat/ui/app.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(DynamicTheme(
    defaultBrightness: Brightness.light,
    data: (brightness) => ThemeData(
          primarySwatch:
              lightTheme.copyWith(brightness: brightness).primaryColor,
          primaryTextTheme:
              TextTheme(title: TextStyle(color: Colors.white, fontSize: 22.0)),
          brightness: brightness,
        ),
    themedWidgetBuilder: (context, theme) {
      return MaterialApp(
        theme: theme,
        home: App(),
      );
    },
  ));
}

var lightTheme = ThemeData(
  primaryColor: Colors.deepPurple,
  accentColor: Color(0xFF0B5FA5),
  buttonColor: Color(0xFFFF9400),
);
