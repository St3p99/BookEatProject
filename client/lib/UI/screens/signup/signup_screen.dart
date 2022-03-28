import 'package:auto_size_text/auto_size_text.dart';
import 'package:client/UI/behaviors/app_localizations.dart';
import 'package:client/UI/support/constants.dart';
import 'package:client/UI/support/size_config.dart';
import 'package:client/model/Model.dart';
import 'package:client/model/objects/user.dart';
import 'package:client/model/support/extensions/string_capitalization.dart';
import 'package:client/model/support/login_result.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/login';

  SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  LoginResult _loginResult;
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _phone;
  String _city;
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
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
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                        height: SizeConfig.screenHeight * 0.1,
                        child: Image.asset("assets/images/app.png")),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.2,
                      child: AutoSizeText(APP_NAME,
                          style: TextStyle(
                              color: kTextLightColor,
                              fontSize: 70.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.05,
                  right: SizeConfig.screenWidth * 0.05,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("firstName")
                              .toUpperCase(),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                        validator: (value) => _validateRequired(value),
                        onSaved: (value) => _firstName = value,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("lastName")
                              .toUpperCase(),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                        validator: (value) => _validateRequired(value),
                        onSaved: (value) => _lastName = value,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                        validator: (value) => _validateEmail(value),
                        onSaved: (value) => _email = value,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                        validator: (value) => _validatePassword(value),
                        onSaved: (value) => _password = value,
                        obscureText: true,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("phone")
                              .toUpperCase(),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                        validator: (value) => _validateRequired(value),
                        onSaved: (value) => _phone = value,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)
                              .translate("city")
                              .toUpperCase(),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kTextLightColor),
                        ),
                        validator: (value) => _validateRequired(value),
                        onSaved: (value) => _city = value,
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      GestureDetector(
                        onTap: () => _signup(),
                        child: Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: kPrimaryColor.withOpacity(0.5),
                            color: kPrimaryColor,
                            elevation: 7.0,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate("register")
                                    .toUpperCase(),
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
          ],
        ),
      ),
    )));
  }

  _validateRequired(String value) {
    if (value.isEmpty || value == null)
      return "* " +
          AppLocalizations.of(context).translate("required").capitalize;
    else
      return null;
  }

  _validateEmail(String value) {
    if (value.isEmpty || value == null) {
      return "* " +
          AppLocalizations.of(context).translate("required").capitalize;
    } else if (EmailValidator.validate(value))
      return null;
    else
      return "* " +
          AppLocalizations.of(context)
              .translate("enter_valid_email")
              .capitalize;
  }

  _validatePassword(String value) {
    if (value.isEmpty || value == null)
      return "* " +
          AppLocalizations.of(context).translate("required").capitalize;
    else if (value.length < 6)
      return AppLocalizations.of(context)
          .translate("pwd_min_6_char")
          .capitalize;
    else if (value.length > 15)
      return AppLocalizations.of(context)
          .translate("pwd_max_25_char")
          .capitalize;
    else
      return null;
  }

  Future<void> _signup() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Processing Data'),
        duration: Duration(seconds: 1),
      ));

      User newUser = new User(
          firstName: _firstName,
          lastName: _lastName,
          phone: _phone,
          email: _email,
          city: _city);
      User created = await Model.sharedInstance.newUser(newUser, _password);
      if (created == null)
        _errorDialog("UNKWOWN ERROR");
      else {
        _successDialog(AppLocalizations.of(context).translate("registered"));
      }
    }
  }

  _errorDialog(String title) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        title: "UNKWOWN ERROR",
        backgroundColor: kSecondaryColor,
        confirmBtnColor: kPrimaryColor,
        onConfirmBtnTap: () => Navigator.pop(context));
  }

  _successDialog(String title) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title:
            AppLocalizations.of(context).translate("registered").toUpperCase(),
        backgroundColor: kSecondaryColor,
        confirmBtnColor: kPrimaryColor,
        onConfirmBtnTap: () =>
            {Navigator.pop(context), Navigator.pop(context)});
  }
}
