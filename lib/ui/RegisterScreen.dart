import 'package:flutter/material.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tcc_ubs/ui/LoginScreen.dart';
import 'package:email_validator/email_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final _formKey = GlobalKey<FormState>();
bool _togglePassword = false;

class _RegisterScreenState extends State<RegisterScreen> {
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
              child: _buildSignUpCard(),
            ),
          ),
        ));
  }

  Widget _buildDivider() {
    return Container(
      width: 250,
      height: 1,
      color: Colors.grey,
    );
  }

  Widget _buildSignUpCard() {
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/images/logo.png",
          height: 140,
          width: 140,
        ),
        Container(
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  child: Card(
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
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 25, 20),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
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
                                        hintText: "Nome completo",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  _buildDivider(),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 25, 15),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      style: TextStyle(
                                          fontFamily: "WorkSansRegular",
                                          fontSize: 18,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          FontAwesomeIcons.idCard,
                                          size: 24,
                                        ),
                                        border: InputBorder.none,
                                        hintText: "CPF",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  _buildDivider(),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 25, 15),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      style: TextStyle(
                                          fontFamily: "WorkSansRegular",
                                          fontSize: 18,
                                          color: Colors.black),
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          FontAwesomeIcons.addressCard,
                                          size: 24,
                                        ),
                                        border: InputBorder.none,
                                        hintText: "Endereço",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  _buildDivider(),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 25, 15),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      textCapitalization:
                                          TextCapitalization.none,
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
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 25, 15),
                                    child: TextFormField(
                                      obscureText: _togglePassword,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.none,
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
                                        suffixIcon: GestureDetector(
                                          onTap: _toggleSingUp,
                                          child: Icon(
                                            _togglePassword
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                          ),
                                        ),
                                        hintText: "Senha",
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  _buildDivider(),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 25, 15),
                                    child: TextFormField(
                                      obscureText: _togglePassword,
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.none,
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
                                        hintText: "Confirmar senha",
                                        suffixIcon: GestureDetector(
                                          onTap: _toggleSingUp,
                                          child: Icon(
                                            _togglePassword
                                                ? FontAwesomeIcons.eye
                                                : FontAwesomeIcons.eyeSlash,
                                            size: 18,
                                          ),
                                        ),
                                        hintStyle: TextStyle(
                                            fontFamily: "WorkSansSemiBold",
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 15, bottom: 20),
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
                                      vertical: 10.0, horizontal: 32.0),
                                  child: Text(
                                    "CADASTRAR",
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
                  padding: EdgeInsets.only(bottom: 20),
                )
              ],
            ))
      ],
    );
  }

  void _toggleSingUp() {
    setState(() {
      _togglePassword = !_togglePassword;
    });
  }
}

/*

Column(
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                height: 140,
                width: 140,
              ),
              Container(
                  padding: EdgeInsets.only(top: 15),
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
                                  child: ListView(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
                                        child: TextFormField(
                                          validator: (text) {
                                            if (text.isEmpty) {
                                              return "Nome inválido";
                                            }
                                          },
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.words,
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
                                            hintText: "Nome completo",
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
                                            if (text.isEmpty || text.length < 11) {
                                              return "CPF inválido";
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          textCapitalization: TextCapitalization.none,
                                          style: TextStyle(
                                              fontFamily: "WorkSansRegular",
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            icon: Icon(
                                              FontAwesomeIcons.idCard,
                                              size: 24,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "CPF",
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
                                            if (text.isEmpty) {
                                              return "Endereço inválido";
                                            }
                                          },
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.none,
                                          style: TextStyle(
                                              fontFamily: "WorkSansRegular",
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            icon: Icon(
                                              FontAwesomeIcons.addressCard,
                                              size: 24,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Endereço",
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
                                            bool validator =
                                            EmailValidator.validate(text);

                                            if (validator == true) {
                                            } else {
                                              return "Email inválido";
                                            }
                                          },
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
                                          validator: (text) {
                                            if (text.isEmpty || text.length < 6)
                                              return "Digite uma senha com mais de 6 carácteres inválido";
                                          },
                                          obscureText: _togglePassword,
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.none,
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
                                            suffixIcon: GestureDetector(
                                              onTap: _toggleSingUp,
                                              child: Icon(
                                                _togglePassword
                                                    ? FontAwesomeIcons.eye
                                                    : FontAwesomeIcons.eyeSlash,
                                                size: 18,
                                              ),
                                            ),
                                            hintText: "Senha",
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
                                          obscureText: _togglePassword,
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.none,
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
                                            hintText: "Confirmar senha",
                                            suffixIcon: GestureDetector(
                                              onTap: _toggleSingUp,
                                              child: Icon(
                                                _togglePassword
                                                    ? FontAwesomeIcons.eye
                                                    : FontAwesomeIcons.eyeSlash,
                                                size: 18,
                                              ),
                                            ),
                                            hintStyle: TextStyle(
                                                fontFamily: "WorkSansSemiBold",
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 20),
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
                                          vertical: 10.0, horizontal: 32.0),
                                      child: Text(
                                        "CADASTRAR",
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
                  ))
            ],
          ))


 */
