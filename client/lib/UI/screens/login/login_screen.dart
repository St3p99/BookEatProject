import 'package:client/model/Model.dart';
import 'package:client/model/objects/user.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/support/login_result.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../home.dart';

class LoginScreen extends StatefulWidget{
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  LoginResult _loginResult;
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: new Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: SizeConfig.screenWidth,
                      child: Column(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [SizedBox(
                                height: SizeConfig.screenHeight*0.1,
                                child: Image.asset("assets/images/app.png")
                            ),
                            ]
                          ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[ SizedBox(
                                height: SizeConfig.screenHeight*0.2,
                                child: AutoSizeText(APP_NAME,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 70.0, fontWeight: FontWeight.bold)
                                ),
                              ),
                              ]
                            ),
                        ],
                      ),
                    ),
                  Container(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenWidth*0.05,
                        right: SizeConfig.screenWidth*0.05,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                  labelText: 'EMAIL',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                              ),
                              validator: (value) => _validateEmail(value),
                              onSaved: (value) => _email = value,
                              onFieldSubmitted: (value) => _login(),
                            ),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                  labelText: 'PASSWORD',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                              ),
                              validator: (value) => _validatePassword(value),
                              onSaved: (value) => _password = value,
                              onFieldSubmitted: (value) => _login(),
                              obscureText: true,
                            ),
                            SizedBox(height: getProportionateScreenHeight(20)),
                            GestureDetector(
                              onTap: () => _login(),
                              child: Container(
                                height: 40.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: kPrimaryColor.withOpacity(0.5),
                                  color: kPrimaryColor,
                                  elevation: 7.0,
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context).translate("login").toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                  SizedBox(height: getProportionateScreenHeight(15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context).translate("unregistred").capitalize
                        +" "+APP_NAME+"?",
                        style: TextStyle(),
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      InkWell(
                        onTap: () {
                          //TODO: navigator.push -> signupScreen
                        },
                        child: Text(
                          AppLocalizations.of(context).translate("register").capitalize,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  _showErrorDialog(String title, String message){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }

  _validateEmail(String value){
    if(value.isEmpty || value == null){
      return "* "+AppLocalizations.of(context).translate("required").capitalize;
    }
    else if(EmailValidator.validate(value))
      return null;
    else return "* "+AppLocalizations.of(context).translate("enter_valid_email").capitalize;
  }

  _validatePassword(String value){
    if(value.isEmpty || value == null)
      return "* "+AppLocalizations.of(context).translate("required").capitalize;
    else if (value.length < 6)
      return AppLocalizations.of(context).translate("pwd_min_6_char").capitalize;
    else if (value.length > 15)
      return AppLocalizations.of(context).translate("pwd_max_25_char").capitalize;
    else
      return null;
  }

  Future<void> _login() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Processing Data'),
            duration: Duration(seconds: 1),
          )
      );
      // // TEMPORANEO
      User user = await Model.sharedInstance.searchUserByEmail(_email);
      print(user);
      if(user != null){
        user.setUserPrefs();
        Navigator.push(context, PageTransition(
            type: PageTransitionType.leftToRight,
            child: Home()));
      }

      // _getToken(); //TODO:
      // switch( _loginResult){
      //   case LoginResult.logged:
      //     User user = await Model.sharedInstance.searchUserByEmail(_email);
      //     user.setUserPrefs();
      //     Navigator.push(context, PageTransition(
      //         type: PageTransitionType.leftToRight,
      //         child: Home()
      //     )); break;
      //   case LoginResult.error_wrong_credentials:
      //     _showErrorDialog("WRONG CREDENTIALS", "message..");
      //     break;
      //   default:_showErrorDialog("KEYCLOAK ERROR", "messagge..");
      // }
    }
  }

  Future<void> _getToken() async {
    LoginResult loginResult = await Model.sharedInstance.logIn(_email, _password);
    setState(() {
      _loginResult = loginResult;
    });
  }
}
