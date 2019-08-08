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
        appBar: _page == 3
            ? AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.ColorsTheme.primaryColor,
                elevation: 0,
                actions: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.white54,
                    child: Row(
                      children: <Widget>[
                        Text(
                          "SAIR",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontFamily: "WorkSansSemiBold"),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Icon(
                              FontAwesomeIcons.signOutAlt,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    onPressed: () {
                      _showDialog();
                    },
                  ),
                ],
              )
            : null,
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
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
            });
          },
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
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
    return SingleChildScrollView(
      physics: MediaQuery.of(context).size.height >= 600
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 800
                    ? MediaQuery.of(context).size.height - 60
                    : 740,
                color: Theme.ColorsTheme.primaryColor,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          width: 220,
                          height: 220,
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
                      padding: EdgeInsets.only(top: 50, bottom: 5),
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
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 11,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            "SAIR",
            style: TextStyle(
              fontFamily: "WorkSansSemiBold",
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 200,
            width: 260,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 25),
                    child: Text(
                      "Tem certeza que deseja sair?",
                      style:
                          TextStyle(fontFamily: "WorkSansMedium", fontSize: 20),
                    )),
                Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      gradient: new LinearGradient(
                          colors: [
                            Theme.ColorsTheme.secondaryColor,
                            Theme.ColorsTheme.primaryColor
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Theme.ColorsTheme.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "SAIR",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () {
                        UserModel().signOut();
                        _googleSignIn.signOut();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                    )),
                MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                          fontSize: 20.0, fontFamily: "WorkSansMedium"),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
