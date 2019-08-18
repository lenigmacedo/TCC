import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/models/place_model.dart';
import 'package:tcc_ubs/models/user_model.dart';
import 'package:tcc_ubs/services/place_services.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as Path;
import 'package:tcc_ubs/ui/LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String _userName;
  File profilePick;
  String url =
      "https://firebasestorage.googleapis.com/v0/b/tccubs.appspot.com/o/ABS.png?alt=media&token=36c108cf-dfdb-4808-8805-20ebb6842961";

  int _page = 0;
  final GlobalKey _bottomNavigationKey = GlobalKey();
  final PageController _pageController = PageController();
  List<Place> _places;

  @override
  void initState() {
    super.initState();
    PlaceService.get().getNearbyPlaces().then((data) {
      this.setState(() {
        _places = data;
      });
    });
  }

  Widget build(BuildContext context) {
    Theme.Settings.statusBar;
    Theme.Settings.orientation;

    return ModalProgressHUD(
      child: Scaffold(
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
          )),
      inAsyncCall: _isLoading,
    );
  }

  Widget _buildNearbyPlaces(BuildContext context) {
    return _createContent();
  }

  Widget _createContent() {
    if (_places == null) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.ColorsTheme.primaryColor,
          child: Center(
            child: CircularProgressIndicator(
                backgroundColor: Theme.ColorsTheme.primaryColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
          ));
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.ColorsTheme.primaryColor,
          child: SafeArea(
            minimum: EdgeInsets.only(top: 50),
            child: ListView(
              children: _places.map((f) {
                return Card(
                  margin: EdgeInsets.all(15),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    title: Text(f.name),
                    subtitle: Text(f.vicinity),
                  ),
                );
              }).toList(),
            ),
          ));
    }
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
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 120,
                          child: ClipOval(
                            child: SizedBox(
                                height: 250.0,
                                width: 250.0,
                                child: (profilePick == null
                                    ? Image.network(
                                        model.userData["photoURL"],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        profilePick,
                                        fit: BoxFit.cover,
                                      ))),
                          )),
                    ),
                    Icon(FontAwesomeIcons.plusCircle),
                    Padding(
                      padding: EdgeInsets.only(top: 50, bottom: 5),
                      child: Text(
                        _userName == null ? "  " : _userName,
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
                          "Alterar foto",
                          style: TextStyle(
                              fontFamily: "WorksSansRegular",
                              fontSize: 22,
                              color: Colors.white),
                        ),
                        onTap: getImage,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: GestureDetector(
                        child: Text(
                          "Alterar nome",
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
            height: 160,
            width: 260,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
                    child: Text(
                      "Tem certeza que \n deseja sair?",
                      style: TextStyle(
                          fontFamily: "WorkSansMedium",
                          fontSize: 19,
                          height: 1),
                    )),
                Row(
                  children: <Widget>[
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        )),
                    MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImage() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);

    setState(() {
      profilePick = img;
      _isLoading = true;
    });

    String fileName = Path.basename(profilePick.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(profilePick);

    url = await (await uploadTask.onComplete).ref.getDownloadURL();

    String userID = await FirebaseAuth.instance.currentUser().then((user) {
      return user.uid;
    });

    Firestore.instance
        .collection("users")
        .document(userID)
        .updateData({"photoURL": url});

    if (uploadTask.isComplete) {
      setState(() {
        _isLoading = false;
        Flushbar(
          animationDuration: Duration(milliseconds: 500),
          icon: Icon(
            FontAwesomeIcons.exclamation,
            color: Colors.white,
            size: 26,
          ),
          backgroundColor: Theme.ColorsTheme.primaryColor,
          flushbarStyle: FlushbarStyle.GROUNDED,
          messageText: Text(
            "Foto atualizada",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "WorkSansSemiBold"),
          ),
          duration: Duration(seconds: 2),
          flushbarPosition: FlushbarPosition.TOP,
        ).show(context);
      });
    }
  }
}
