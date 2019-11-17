import 'dart:io';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as path;
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/models/place_model.dart';
import 'package:tcc_ubs/models/user_model.dart';
import 'package:tcc_ubs/services/place_services.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:tcc_ubs/ui/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'fake.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  String _userName;
  File profilePick;
  String urlGoogle;
  bool _alwaysValidate = false;
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;
  String idAlgolia = "M8Z6XTFU22";
  String apiAlgolia = "60625b97ef296463b95a9cd9c5412be2";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Geolocator geolocator = Geolocator();
  Position userLocation;

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

    _getLocation().then((position) {
      userLocation = position;
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
              _buildSearch(context),
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
            child: LoadingBouncingGrid.circle(
          backgroundColor: Colors.white,
          duration: Duration(seconds: 1),
        )),
      );
    } else {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Theme.ColorsTheme.primaryColor,
          child: SafeArea(
              minimum: EdgeInsets.only(top: 0),
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 6,
                      backgroundColor: Theme.ColorsTheme.primaryColor,
                      expandedHeight: 100.0,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          "UBS Próximas",
                          style: TextStyle(
                            fontFamily: "WorkSansRegular",
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        titlePadding: EdgeInsets.only(bottom: 30),
                      ),
                    ),
                  ];
                },
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        children: _places.map((f) {
                          return Card(
                            margin: EdgeInsets.all(15),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: ExpandablePanel(
                                header: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                  child: ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          print(f.id);
                                          print(f.name);
                                        },
                                        child: Text(
                                          f.name,
                                          style: TextStyle(
                                              fontFamily: "WorkSansMedium",
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(f.vicinity,
                                        style: TextStyle(
                                            fontFamily: "WorkSansMedium",
                                            fontSize: 17,
                                            color: Colors.grey[700])),
                                  ),
                                ),
                                expanded: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 5, left: 30),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              var name = f.id;

                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Fake(name)));
                                            },
                                            child: Text(
                                              "Remédios e Especialidades",
                                              style: TextStyle(
                                                  fontFamily: "WorkSansMedium",
                                                  fontSize: 22,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 15, left: 30),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(-1, 0),
                                          child: GestureDetector(
                                            onTap: () {
                                              launchMap(f.vicinity);
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Como chegar",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "WorkSansMedium",
                                                      fontSize: 22,
                                                      color: Colors.black),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .mapMarkerAlt,
                                                    size: 20,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ],
                                )),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              )));
    }
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.ColorsTheme.primaryColor,
        child: SafeArea(
            minimum: EdgeInsets.only(top: 50),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.ColorsTheme.primaryColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      height: 60,
                      width: 380,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          elevation: 5,
                          child: ListTile(
                            trailing: GestureDetector(
                              onTap: searchText,
                              child: Icon(
                                Icons.search,
                                size: 30,
                              ),
                            ),
                            title: SafeArea(
                              child: TextField(
                                onEditingComplete: searchText,
                                controller: _searchController,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                    border: InputBorder.none,
                                    focusColor: Colors.transparent,
                                    filled: false,
                                    hintText: "Buscar...",
                                    hintStyle: TextStyle(
                                        fontFamily: "WorkSansRegular",
                                        fontSize: 16)),
                                autofocus: false,
                              ),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      child: _searching == true
                          ? Center(
                              child: LoadingBouncingGrid.circle(
                              backgroundColor: Colors.white,
                              duration: Duration(seconds: 1),
                            ))
                          : _results.length == 0
                              ? Center(
                                  child: Text(
                                  "Não houve resultados para sua pesquisa.",
                                  style: TextStyle(
                                      fontFamily: "WorkSansMedium",
                                      fontSize: 16),
                                ))
                              : ListView.builder(
                                  itemCount: _results.length,
                                  itemBuilder: (context, index) {
                                    AlgoliaObjectSnapshot snap =
                                        _results[index];

                                    return Container(
                                      margin:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      child: Card(
                                        child: ListTile(
                                          title: Text(snap.data["name"]),
                                          subtitle: Text(snap.data["endereco"]),
                                        ),
                                      ),
                                    );
                                  },
                                ))
                ],
              ),
            )));
  }

  Widget _buildPartners(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 60,
        color: Theme.ColorsTheme.primaryColor,
        child: Column());
  }

  Widget _buildProfile(BuildContext context) {
    return SingleChildScrollView(
      physics: MediaQuery.of(context).size.height >= 600
          ? NeverScrollableScrollPhysics()
          : AlwaysScrollableScrollPhysics(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          this._userName = model.userData["name"];

          /*
          if (_userName == null) {
            FirebaseAuth.instance.currentUser().then((user) {
              setState(() {
                this._userName = user.displayName;
              });
            });
          }

          */

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
                                    ? Image.network(model.userData["photoURL"])
                                    : Image.file(profilePick))),
                          )),
                    ),
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
                        onTap: _dialogUserName,
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
            child: ScopedModelDescendant<UserModel>(
                builder: (context, child, model) {
              return Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
                      child: Text(
                        "Tem certeza que deseja sair?",
                        textAlign: TextAlign.center,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
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
                            onPressed: () async {
                              await model.signOut();
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
              );
            }),
          ),
        );
      },
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      currentLocation = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      currentLocation = null;
    }
    return currentLocation;
  }

  void _dialogUserName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 11,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            "ALTERAR NOME",
            style: TextStyle(
              fontFamily: "WorkSansMedium",
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 162,
            width: 260,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Form(
                      autovalidate: _alwaysValidate,
                      key: _formKey,
                      child: TextFormField(
                        validator: _validateName,
                        controller: _nameController,
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(
                            fontFamily: "WorkSansRegular",
                            fontSize: 18,
                            color: Colors.black),
                        decoration: InputDecoration(
                          icon: Icon(
                            FontAwesomeIcons.user,
                            size: 24,
                          ),
                          border: InputBorder.none,
                          hintText: "Nome",
                          hintStyle: TextStyle(
                              fontFamily: "WorkSansSemiBold", fontSize: 18),
                        ),
                      ),
                    )),
                Container(
                  width: 230,
                  height: 1,
                  color: Colors.grey,
                ),
                Container(
                    margin: EdgeInsets.only(top: 31, bottom: 20),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          "ALTERAR",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _updateName();
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            _alwaysValidate = true;
                          });
                        }
                      },
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  _updateName() async {
    String name = _nameController.text;

    String userID = await FirebaseAuth.instance.currentUser().then((user) {
      return user.uid;
    });
    Firestore.instance
        .collection("users")
        .document(userID)
        .updateData({"name": name});

    setState(() {
      _userName = name;
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
          "Seu nome será atualizado no próximo login",
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

  Future getImage() async {
    File img = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);
    String fileName;

    setState(() {
      profilePick = img;
      _isLoading = true;
    });

    try {
      fileName = path.basename(profilePick.path);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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

  String _validateName(String value) {
    String pattern = r'(^[a-zA-ZáàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ\s]*$)';
    RegExp regExp = RegExp(pattern);

    if (value.isEmpty || value == " ") {
      return "Campo obrigatório";
    } else if (!regExp.hasMatch(value)) {
      return "Apenas letras";
    }
    return null;
  }

  searchText() async {
    setState(() {
      _searching = true;
    });

    Algolia algolia =
        Algolia.init(applicationId: idAlgolia, apiKey: apiAlgolia);

    AlgoliaQuery query = algolia.instance.index('ubs');
    query = query.search(_searchController.text);

    if (_searchController.text.isEmpty) {
      setState(() {
        _searching = false;
        _results = [];
      });
    } else {
      _results = (await query.getObjects()).hits;

      setState(() {
        _searching = false;
      });
    }
  }

  launchMap(String address) async {
    String googleURL =
        "https://www.google.com/maps/search/?api=1&query=$address";
    String appleURL = "https:///maps.apple.com/?sll=$address";

    if (await canLaunch(googleURL)) {
      await launch(googleURL);
    } else if (await canLaunch(appleURL)) {
      await launch(appleURL);
    } else {
      Flushbar(
        animationDuration: Duration(milliseconds: 500),
        icon: Icon(
          FontAwesomeIcons.exclamation,
          color: Colors.white,
          size: 26,
        ),
        backgroundColor: Colors.red,
        flushbarStyle: FlushbarStyle.GROUNDED,
        messageText: Text(
          "Não foi possível abrir o mapa",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "WorkSansSemiBold"),
        ),
        duration: Duration(seconds: 2),
        flushbarPosition: FlushbarPosition.TOP,
      ).show(context);
    }
  }
}
