import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/models/user_model.dart';
import 'package:tcc_ubs/ui/HomeScreen.dart';
import 'package:tcc_ubs/ui/LoginScreen.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;

class SplashScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1700),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.Settings.orientation;
    Theme.Settings.statusBar;

    return ScopedModelDescendant<UserModel>(builder: (context, child, model) {
      if (!model.isLoggedIn()) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()));
        });
      }

      return Scaffold(
          appBar: null,
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: Theme.ColorsTheme.gradient,
                ),
              ),
              ScaleTransition(
                scale: _animation,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: 250,
                  height: 250,
                ),
              ),
            ],
          ));
    });

/*

return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }else if (user != null){
            return HomeScreen();
          }
        } else {

 */
  }
}
