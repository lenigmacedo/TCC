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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _userName;

  int _page = 0;
  final GlobalKey _bottomNavigationKey = GlobalKey();
  final PageController _pageController = PageController();

  Widget build(BuildContext context) {
    Theme.Settings.statusBar;
    Theme.Settings.orientation;

    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.decelerate,
          index: 0,
          animationDuration: Duration(milliseconds: 400),
          backgroundColor: Theme.ColorsTheme.primaryColor,
          height: 60,
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(FontAwesomeIcons.locationArrow, size: 20),
            Icon(FontAwesomeIcons.search, size: 20),
            Icon(FontAwesomeIcons.shoppingCart, size: 20),
            Icon(FontAwesomeIcons.userAlt, size: 20),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              _pageController.animateToPage(_page,
                  duration: Duration(milliseconds: 500), curve: Curves.decelerate);
            });
          },
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            _buildNearbyPlaces(context),
            _buildSerch(context),
            _buildPartners(context),
            _buildProfile(context),
          ],
        ));
  }

  Widget _buildNearbyPlaces(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 60,
      color: Theme.ColorsTheme.primaryColor,
      child: Center(
        child: Text("Nearby Places"),
      ),
    );
  }

  Widget _buildSerch(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 60,
      color: Theme.ColorsTheme.primaryColor,
      child: Center(
        child: Text("Search"),
      ),
    );
  }

  Widget _buildPartners(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 60,
      color: Theme.ColorsTheme.primaryColor,
      child: Center(
        child: Text("Partners"),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
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
                height: MediaQuery.of(context).size.height - 60,
                color: Theme.ColorsTheme.primaryColor,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 60),
                        child: Container(
                          width: 200,
                          height: 200,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: Image.asset(
                              "assets/images/member.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 5),
                      child: Text(
                        _userName,
                        style: TextStyle(
                            fontFamily: "WorkSansMedium",
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(120, 255, 255, 255),
                              Colors.white,
                            ],
                            begin: const FractionalOffset(1.0, 1.0),
                            end: const FractionalOffset(0.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      width: 230.0,
                      height: 1.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: GestureDetector(
                        child: Text(
                          "Editar dados",
                          style: TextStyle(
                              fontFamily: "WorksSansRegular",
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: GestureDetector(
                        child: Text(
                          "Sobre",
                          style: TextStyle(
                              fontFamily: "WorksSansRegular",
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: GestureDetector(
                        child: Text(
                          "Contato",
                          style: TextStyle(
                              fontFamily: "WorksSansRegular",
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        onTap: () {},
                      ),
                    )
                  ],
                )),
          ],
        );
      },
    );
  }
}

/*

 FlatButton(
                  onPressed: () {
                    model.signOut();
                    _googleSignIn.signOut();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Sair"))


 */
