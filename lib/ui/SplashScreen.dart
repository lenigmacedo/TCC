import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_ubs/ui/LoginScreen.dart';

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
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.forward();

    //Function that goes to another page and user can't go back
    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  static Color primaryColor = Color(0xFF52B9E7);
  static Color secondaryColor = Color(0xFF52d2e7);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.red));

    return Scaffold(
        appBar: null,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [primaryColor, primaryColor]),
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
  }
}
