import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;

class Fake extends StatelessWidget {
  int x = 0;
  String hm;

  Fake(this.hm);

  String name;

  @override
  Widget build(BuildContext context) {
    Theme.Settings.statusBar;
    Theme.Settings.orientation;

    return Scaffold(
        backgroundColor: Theme.ColorsTheme.primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.ColorsTheme.primaryColor,
        ),
        body: SafeArea(
            minimum: EdgeInsets.only(top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Theme.ColorsTheme.primaryColor,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 80),
                    child: Text(
                      hm,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "WorkSansBold",
                          fontSize: 28,
                          color: Colors.white),
                    ),
                  ),
                  Text(
                    "Especialidades",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "WorkSansMedium",
                        fontSize: 22,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Card(
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: PageView(
                          scrollDirection: Axis.vertical,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text(
                                      "Odontologia",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "WorkSansMedium",
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    FontAwesomeIcons.arrowDown,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text(
                                      "Pediatria",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "WorkSansMedium",
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    FontAwesomeIcons.arrowDown,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "Fonoaudiologia",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "WorkSansMedium",
                                      fontSize: 22,
                                      color: Colors.black),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Exames",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "WorkSansMedium",
                          fontSize: 22,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Container(
                      width: 300,
                      height: 100,
                      child: Card(
                        elevation: 11,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text(
                                      "Hepatite B",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "WorkSansMedium",
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: Text(
                                      "Ressonância",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "WorkSansMedium",
                                          fontSize: 22,
                                          color: Colors.black),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    FontAwesomeIcons.arrowRight,
                                    size: 15,
                                  ),
                                )
                              ],
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "Raio-X",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "WorkSansMedium",
                                      fontSize: 22,
                                      color: Colors.black),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 60),
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
                  )
                ],
              ),
            )));
  }
}
