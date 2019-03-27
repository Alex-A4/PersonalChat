import 'package:flutter/material.dart';
import 'package:personal_chat/ui/app.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  runApp(DynamicTheme(
    defaultBrightness: Brightness.light,
    data: (brightness) => ThemeData(
      primaryColor: Colors.purpleAccent[400],
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