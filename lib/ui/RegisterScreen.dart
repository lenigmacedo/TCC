import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_ubs/models/user_model.dart';
import 'package:tcc_ubs/theme/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _alwaysValidate = false;
  bool _togglePassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.Settings.orientation;
    Theme.Settings.statusBar;

    return Scaffold(
        appBar:null,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= 800
                ? MediaQuery.of(context).size.height
                : 800,
            decoration: BoxDecoration(gradient: Theme.ColorsTheme.gradient),
            child: SafeArea(
              minimum: EdgeInsets.only(top: 60),
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
          height: 180,
          width: 180,
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
                          ScopedModelDescendant<UserModel>(
                            builder: (context, child, model) {
                              if (model.isLoading) {
                                return Center(
                                  child:Container(
                                    padding: EdgeInsets.all(100),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              return Form(
                                  autovalidate: _alwaysValidate,
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(25, 20, 25, 20),
                                        child: TextFormField(
                                          controller: _nameController,
                                          validator: _validateName,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          style: TextStyle(
                                              fontFamily: "WorkSansRegular",
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                            icon: Icon(
                                              FontAwesomeIcons.user,
                                              size: 24,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Nome",
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
                                          controller: _emailController,
                                          validator: _validateEmail,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          style: TextStyle(
                                              fontFamily: "WorkSansRegular",
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              fontSize: 12,
                                            ),
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
                                          controller: _passwordController,
                                          validator: _validatePassword,
                                          obscureText: _togglePassword,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          style: TextStyle(
                                              fontFamily: "WorkSansRegular",
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              fontSize: 12,
                                            ),
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
                                          validator: _validateConfirmPassword,
                                          obscureText: _togglePassword,
                                          keyboardType: TextInputType.text,
                                          textCapitalization:
                                              TextCapitalization.none,
                                          style: TextStyle(
                                              fontFamily: "WorkSansRegular",
                                              fontSize: 18,
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            errorStyle: TextStyle(
                                              fontSize: 12,
                                            ),
                                            icon: Icon(
                                              FontAwesomeIcons.lock,
                                              size: 24,
                                            ),
                                            border: InputBorder.none,
                                            hintText: "Confirmar senha",
                                            hintStyle: TextStyle(
                                                fontFamily: "WorkSansSemiBold",
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 15, bottom: 20),
                                          decoration: new BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            gradient: new LinearGradient(
                                                colors: [
                                                  Theme.ColorsTheme
                                                      .secondaryColor,
                                                  Theme.ColorsTheme.primaryColor
                                                ],
                                                begin: const FractionalOffset(
                                                    0.2, 0.2),
                                                end: const FractionalOffset(
                                                    1.0, 1.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: MaterialButton(
                                            highlightColor: Colors.transparent,
                                            splashColor:
                                                Theme.ColorsTheme.primaryColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 32.0),
                                              child: Text(
                                                "CADASTRAR",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontFamily: "WorkSansBold"),
                                              ),
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                Map<String, dynamic> userData =
                                                    {
                                                  "name": _nameController.text,
                                                  "email":
                                                      _emailController.text,
                                                };

                                                model.signUp(
                                                    userData: userData,
                                                    pass: _passwordController
                                                        .text,
                                                    onSucess: _onSucess,
                                                    onFail: _onFail);
                                              } else {
                                                setState(() {
                                                  _alwaysValidate = true;
                                                });
                                              }
                                            },
                                          ))
                                    ],
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  void _onSucess(){
    Flushbar(
      animationDuration: Duration(milliseconds: 600),
      icon: Icon(
        FontAwesomeIcons.exclamation,
        color: Colors.white,
        size: 26,
      ),
      backgroundColor: Theme.ColorsTheme.primaryColor,
      flushbarStyle: FlushbarStyle.GROUNDED,
      messageText: Text(
        "Usuário criado com sucesso",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontFamily: "WorkSansSemiBold"),
      ),
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
    _passwordController.text = "";
    _emailController.text = "";
    _nameController.text = "";
    Future.delayed(Duration(seconds: 2)).then((a){
      Navigator.of(context).pop();
    });
  }

  void _onFail(){
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
        "Falha ao criar usuário",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontFamily: "WorkSansSemiBold"),
      ),
      duration: Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _toggleSingUp() {
    setState(() {
      _togglePassword = !_togglePassword;
    });
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

  String _validateCPF(String value) {
    var validator = CPFValidator.isValid(value);

    if (validator) {
      return null;
    } else {
      return "CPF inválido";
    }
  }

  String _validateEndereco(String value) {
    if (value.isEmpty || value == " ") {
      return "Endereço inválido";
    } else {
      return null;
    }
  }

  String _validateEmail(String value) {
    var validator = EmailValidator.validate(value);

    if (validator) {
      return null;
    } else {
      return "Email inválido";
    }
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    } else if (value.length < 6) {
      return "Senha muito curta";
    } else {
      return null;
    }
  }

  String _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return "Campo obrigatório";
    } else if (value != _passwordController.text) {
      return "Senhas não conferem";
    } else {
      return null;
    }
  }
}
