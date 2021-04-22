import 'dart:convert';
import 'dart:math';

import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/utils/const.dart';
import 'package:cass_branch/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _isLoading = false;

  void _onSubmit() {
    final currentState = _formKey.currentState;
    if (currentState.validate()) {
      currentState.save();
      setState(() {
        _isLoading = true;
      });
      _login();
    }
  }

  Future<void> _login() async {
    await http
        .post(Uri.http(AUTHORITY, 'api/branch/login'),
            headers: HEADERS,
            body: Branch.createJson(email: _email, password: _password))
        .then((response) {
      var resBody = jsonDecode(response.body);
      String message = resBody[MESSAGE];
      if (response.statusCode == 200) {
        Branch branch = Branch.fromJson(resBody[DATA]);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => MainPage(branch),
            ),
            (Route<dynamic> route) => false);
      } else {
        _showDialog(message);
      }
    }, onError: (error) => _showDialog('Server connection error'));
  }

  Future<void> _showDialog(String message) async {
    setState(() {
      _isLoading = false;
    });
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Stack(
          children: <Widget>[
            _backgroud(),
            Center(
              child: Material(
                elevation: 25,
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _header(),
                          _textFieldEmail(),
                          _textFieldPassword(),
                          _buttonLogin(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backgroud() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Colors.lightBlue.shade200,
                  Colors.indigoAccent,
                  Colors.purpleAccent.shade200,
                ]),
          ),
        ),
        Positioned(
          top: -100,
          left: -150,
          child: _rectangle(width: 400, height: 600, angle: pi / 4),
        ),
        Positioned(
          right: -250,
          bottom: -150,
          child: _rectangle(width: 500, height: 800, angle: -pi / 6),
        ),
      ],
    );
  }

  Widget _rectangle(
      {double angle = pi / 4, double width = 600.0, double height = 600.0}) {
    return Transform.rotate(
      angle: angle,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.grey.shade100.withOpacity(0.1),
        child: Container(width: width, height: height),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: <Widget>[
        Text(
          'Car Service System',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          'for',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'BRANCH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 48,
          ),
        ),
      ],
    );
  }

  Widget _textFieldEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email',
        suffixIcon: Icon(Icons.email),
      ),
      onSaved: (email) => _email = email,
      validator: (email) => email.isEmpty ? 'Email cannot be empty' : null,
    );
  }

  Widget _textFieldPassword() {
    return TextFormField(
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: Icon(Icons.lock),
      ),
      onSaved: (password) => _password = password,
      onFieldSubmitted: (_) => _onSubmit(),
      validator: (password) {
        if (password.isEmpty) {
          return 'Password cannot be empty';
        } else if (password.length < 8) {
          return 'Password cannot be less than 8 charaters';
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return ElevatedButton(
      onPressed: _onSubmit,
      child: Text('LOGIN'),
    );
  }
}
