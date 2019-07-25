import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class ColorsTheme {
  static const Color primaryColor = Color(0xFF52B9E7);
  static const Color secondaryColor = Color(0xFF65C9E2);

  static LinearGradient gradient = LinearGradient(
    colors: const [primaryColor, secondaryColor],

  );
}

class Settings {
  static final orientation = SystemChrome.setPreferredOrientations(
      ([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]));
  static final statusBar = SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}


class Fonts {

  static const TextStyle a = TextStyle(

  );

}