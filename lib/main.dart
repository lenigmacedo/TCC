import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/ui/SplashScreen.dart';
import 'package:tcc_ubs/ui/HomeScreen.dart';

import 'models/user_model.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
        child: MaterialApp(
            title: "UBS",
            debugShowCheckedModeBanner: false,
            home: SplashScreen()
        ),
    );
  }
}
