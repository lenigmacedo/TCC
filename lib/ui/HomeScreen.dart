import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/models/user_model.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_ubs/ui/LoginScreen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userName;

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  Widget build(BuildContext context) {
    Theme.Settings.statusBar;
    Theme.Settings.orientation;

    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: 0,
          animationDuration: Duration(milliseconds: 500),
          backgroundColor: Theme.ColorsTheme.primaryColor,
          height: 60,
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(FontAwesomeIcons.locationArrow, size: 20),
            Icon(FontAwesomeIcons.search, size: 20),
            Icon(FontAwesomeIcons.shoppingCart, size: 20),
            Icon(FontAwesomeIcons.user, size: 20),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: SingleChildScrollView(
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              FirebaseAuth.instance.currentUser().then((user) {
                setState(() {
                  this._userName = user.displayName;
                });
              });

              if (_userName == null) {
                this._userName = model.userData["name"];
              }

              return Column(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height >= 800
                          ? MediaQuery.of(context).size.height
                          : 800,
                      color: Theme.ColorsTheme.primaryColor,
                      child: Center(
                        child: Text(
                          "Olá, $_userName",
                          style: TextStyle(
                              fontFamily: "WorkSansRegular",
                              fontSize: 35,
                              color: Colors.white),
                        ),
                      )),
                  FlatButton(
                      onPressed: () {
                        model.signOut();
                        _googleSignIn.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Text("Sair"))
                ],
              );
            },
          ),
        ));
  }
}
