import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_ubs/ui/RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

bool _obscureTextLogin = true;
final _formKey = GlobalKey<FormState>();

final googleSignIn = GoogleSignIn();

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Theme.Settings.orientation;
    Theme.Settings.statusBar;

    return Scaffold(
        appBar: null,
        body: SingleChildScrollView(
          child: Container(
              width: MediaQuery.of(context).size.width,
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
                          child: Text(
                            "Esqueceu a senha?",
                            style: TextStyle(
                                fontFamily: "WorkSansRegular",
                                color: Colors.white,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.solid),
                          ),
                        ),
                      ],
                    ),
                    _buildOr(),
                    _buildLoginButtons(),
                    Padding(
                      padding: EdgeInsets.only(top: 35,bottom: 20),
                      child: Center(
                        child: Text(
                          "Entrar como convidado",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "WorkSansMedium",
                              decoration: TextDecoration.underline,
                              fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ));
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
                    Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                              child: TextFormField(
                                validator: (text) {
                                  if (text.isEmpty || !text.contains("@"))
                                    return "Email inválido";
                                },
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.words,
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
                                  validator: (text) {
                                    if (text.isEmpty || text.length < 6)
                                      return "Senha inválida";
                                  },
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
                                          size: 18,
                                        ),
                                      ))),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 5, bottom: 20),
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
                            if (_formKey.currentState.validate()) {}
                          },
                        ))
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

  Widget _buildLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15.0, right: 40.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: new Icon(
                FontAwesomeIcons.facebookF,
                color: Theme.ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: new Icon(
                FontAwesomeIcons.google,
                color: Theme.ColorsTheme.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }
}
