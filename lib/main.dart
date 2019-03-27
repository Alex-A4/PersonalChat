import 'package:flutter/material.dart';
import 'package:personal_chat/ui/app.dart';


void main() {
  runApp(MaterialApp(
    theme: theme,
    home: App(),
  ));
}

final theme = ThemeData(
  primaryColor: Colors.purpleAccent[400],
);