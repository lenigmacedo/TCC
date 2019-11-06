import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/models/user_model.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:tcc_ubs/ui/HomeScreen.dart';
import 'package:tcc_ubs/ui/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _alwaysValidate = false;
  bool _obscureTextLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formResetKey = GlobalKey<FormState>();
  final Geolocator geolocator = Geolocator();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailControllerReset = TextEditingController();

  _getPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }

  @override
  void initState() {
    super.initState();

    geolocator.checkGeolocationPermissionStatus().then((status) {
      if (status != GeolocationStatus.granted) {
        _showPermission();
        _getPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.Settings.orientation;
    Theme.Settings.statusBar;

    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: null,
          body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height >= 800
                    ? MediaQuery.of(context).size.height
                    : 800,
                decoration: BoxDecoration(gradient: Theme.ColorsTheme.gradient),
                child: SafeArea(
                  minimum: EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/logo.png",
                        height: 180,
                        width: 180,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: FlatButton(
                          onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegisterScreen())),
                          child: Text.rich(TextSpan(
                              text: "Não tem uma conta? ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "WorkSansSemiBold"),
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Cadastre-se",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "WorkSansSemiBold"),
                                )
                              ])),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                      _buildCardSignIn(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: GestureDetector(
                                onTap: _showDialog,
                                child: Text(
                                  "Esqueceu a senha?",
                                  style: TextStyle(
                                      fontFamily: "WorkSansRegular",
                                      color: Colors.white,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.solid),
                                ),
                              )),
                        ],
                      ),
                      _buildOr(),
                      _buildSocialLoginButtons(),
                      Padding(
                        padding: EdgeInsets.only(top: 35),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              _buildFlushbar(
                                  "Ainda não implementado", 2, Colors.red);
                            },
                            child: Text(
                              "Entrar como convidado",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "WorkSansMedium",
                                  decoration: TextDecoration.underline,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          )),
    );
  }

  Widget _buildCardSignIn() {
    return Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 11,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                width: 300.0,
                child: Column(
                  children: <Widget>[
                    ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                      if (model.isLoading) {
                        return Center(
                            child: Container(
                          padding: EdgeInsets.all(100),
                          child: CircularProgressIndicator(),
                        ));
                      }
                      return Form(
                        autovalidate: _alwaysValidate,
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                              child: TextFormField(
                                controller: _emailController,
                                validator: _validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                                style: TextStyle(
                                    fontFamily: "WorkSansRegular",
                                    fontSize: 18,
                                    color: Colors.black),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    FontAwesomeIcons.envelope,
                                    size: 24,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      fontFamily: "WorkSansSemiBold",
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            _buildDivider(),
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 20, 25, 15),
                              child: TextFormField(
                                  controller: _passwordController,
                                  validator: _validatePassword,
                                  obscureText: _obscureTextLogin,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(
                                      fontFamily: "WorkSansRegular",
                                      fontSize: 18,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        FontAwesomeIcons.lock,
                                        size: 24,
                                      ),
                                      border: InputBorder.none,
                                      hintText: "Senha",
                                      hintStyle: TextStyle(
                                          fontFamily: "WorkSansSemiBold",
                                          fontSize: 18),
                                      suffixIcon: GestureDetector(
                                        onTap: _toggleLogin,
                                        child: Icon(
                                          _obscureTextLogin
                                              ? FontAwesomeIcons.eye
                                              : FontAwesomeIcons.eyeSlash,
                                          size: 24,
                                        ),
                                      ))),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5, bottom: 20),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 42.0),
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontFamily: "WorkSansBold"),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      model.signIn(
                                          email: _emailController.text,
                                          onFail: _onFail,
                                          onSucess: _onSucess,
                                          pass: _passwordController.text);
                                    } else {
                                      setState(() {
                                        _alwaysValidate = true;
                                      });
                                    }
                                  },
                                ))
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildDivider() {
    return Container(
      width: 250,
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _buildOr() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.white10,
                        Colors.white,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Ou",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "WorkSansMedium"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.white10,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                width: 100.0,
                height: 1.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: GestureDetector(
        onTap: () {
          _buildFlushbar("Login com Google desativado", 2, Colors.red);
        },
        child: Container(
            width: 150,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    FontAwesomeIcons.google,
                    color: Theme.ColorsTheme.primaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Google",
                    style:
                        TextStyle(fontFamily: "WorkSansMedium", fontSize: 22),
                  ),
                )
              ],
            )),
      ),
    );
  }

  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Null> _loginWithGoogle() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if (user == null) {
      user = await _googleSignIn.signInSilently();
    }

    if (user == null) {
      user = await _googleSignIn.signIn();
    }

    if (await _auth.currentUser() == null) {
      GoogleSignInAuthentication credentials =
          await _googleSignIn.currentUser.authentication;

      await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: credentials.idToken, accessToken: credentials.accessToken));
    }

    if (user != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
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
            "Recuperar senha",
            style: TextStyle(
              fontFamily: "WorkSansMedium",
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 182,
            width: 260,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Form(
                      autovalidate: _alwaysValidate,
                      key: _formResetKey,
                      child: TextFormField(
                        validator: (email) {
                          if (email.isEmpty) {
                            return "Preencha o campo";
                          }
                          return '';
                        },
                        controller: _emailControllerReset,
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        style: TextStyle(
                            fontFamily: "WorkSansRegular",
                            fontSize: 18,
                            color: Colors.black),
                        decoration: InputDecoration(
                          icon: Icon(
                            FontAwesomeIcons.envelope,
                            size: 24,
                          ),
                          border: InputBorder.none,
                          hintText: "Email",
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
                          "RECUPERAR",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () {
                        if (_formResetKey.currentState.validate()) {
                          _recoverPass(_emailControllerReset.text);
                          _buildFlushbar("Confira seu email", 1,
                              Theme.ColorsTheme.primaryColor);
                          Future.delayed(Duration(milliseconds: 1500))
                              .then((a) {
                            Navigator.of(context).pop();
                            _emailControllerReset.text = "";
                          });
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

  _recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return "Preencha o campo";
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Preencha o campo";
    } else {
      return null;
    }
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _onFail() {
    Flushbar(
      animationDuration: Duration(milliseconds: 600),
      icon: Icon(
        FontAwesomeIcons.exclamation,
        color: Colors.white,
        size: 26,
      ),
      backgroundColor: Colors.red,
      flushbarStyle: FlushbarStyle.GROUNDED,
      messageText: Text(
        "Falha ao entrar",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontFamily: "WorkSansSemiBold"),
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _onSucess() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  Future<void> _buildFlushbar(String text, int duration, Color color) {
    return Flushbar(
      animationDuration: Duration(milliseconds: 500),
      icon: Icon(
        FontAwesomeIcons.exclamation,
        color: Colors.white,
        size: 26,
      ),
      backgroundColor: color,
      flushbarStyle: FlushbarStyle.GROUNDED,
      messageText: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontFamily: "WorkSansSemiBold"),
      ),
      duration: Duration(seconds: duration),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _showPermission() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 11,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Text(
            "PERMISSÃO",
            style: TextStyle(
              fontFamily: "WorkSansSemiBold",
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 180,
            width: 260,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 25),
                  child: Text(
                    "Para utilizar nosso app precisamos que o GPS esteja ativo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "WorkSansMedium", fontSize: 19, height: 1),
                  ),
                ),
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
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: "WorkSansBold"),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _exitApp() {
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
                            "Tem certeza que deseja sair do app?",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    "SAIR",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: "WorkSansBold"),
                                  ),
                                ),
                                onPressed: () {
                                  SystemNavigator.pop();
                                },
                              )),
                          MaterialButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.grey[200],
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: "WorkSansMedium"),
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
            ) ??
            false;
      },
    );
  }
}
