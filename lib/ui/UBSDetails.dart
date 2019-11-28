import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:url_launcher/url_launcher.dart';

class UBSDetails extends StatelessWidget {
  String name;
  String endereco;
  String place_id;

  UBSDetails(this.name, this.endereco, this.place_id);

  @override
  Widget build(BuildContext context) {
    Theme.Settings.statusBar;
    Theme.Settings.orientation;

    return Scaffold(
      backgroundColor: Theme.ColorsTheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.ColorsTheme.primaryColor,
        centerTitle: true,
        title: Text(
          name,
          style: TextStyle(fontSize: 22, fontFamily: "WorkSansRegular"),
        ),
      ),
      body: SafeArea(
          minimum: EdgeInsets.only(top: 10),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.ColorsTheme.primaryColor,
              child: SingleChildScrollView(
                physics: MediaQuery.of(context).size.height >= 700
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Remédios",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "WorkSansMedium",
                            fontSize: 22,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 20),
                        child: Container(
                            width: 300,
                            height: 300,
                            child: Card(
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: FutureBuilder(
                                future: getRemedios(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: LoadingBouncingGrid.circle(
                                          backgroundColor: Colors.white,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    default:
                                      return ListView.builder(
                                        itemBuilder: (context, index) {
                                          return CardRemedios(
                                              snapshot.data[index].data);
                                        },
                                        itemCount: snapshot.data.length,
                                      );
                                  }
                                },
                              ),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Especialidades e Exames",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "WorkSansMedium",
                            fontSize: 22,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        width: 300,
                        height: 120,
                        child: Card(
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: FutureBuilder(
                            future: getExames(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Center(
                                    child: LoadingBouncingGrid.circle(
                                      backgroundColor: Colors.white,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                default:
                                  return ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 10, 20, 10),
                                        child: Text(
                                          snapshot.data[index]["name"],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "WorkSansMedium"),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                launchMap(endereco, context);
                              },
                              child: Text(
                                "Como chegar á $name?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "WorkSansSemiBold",
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      child: Container(
                        height: 50,
                        child: Card(
                            elevation: 11,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    FontAwesomeIcons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Favoritar UBS",
                                    style: TextStyle(
                                        fontFamily: "WorkSansMedium",
                                        fontSize: 22),
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }

  getRemedios() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("ubs")
        .document(place_id)
        .collection("remedios")
        .getDocuments();

    return querySnapshot.documents;
  }

  getExames() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("ubs")
        .document(place_id)
        .collection("exames_especialidades")
        .getDocuments();

    return querySnapshot.documents;
  }

  launchMap(String address, BuildContext context) async {
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

class CardRemedios extends StatelessWidget {
  final Map<String, dynamic> data;

  CardRemedios(this.data);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            data["name"],
            style: TextStyle(
              fontFamily: "WorkSansMedium",
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: data["tem"] == "false"
              ? Icon(FontAwesomeIcons.thumbsDown)
              : Icon(FontAwesomeIcons.thumbsUp),
        )
      ],
    );
  }
}
