import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  _onSubmit() {
    final currentState = _formKey.currentState!;
    if (currentState.validate()) {
      currentState.save();
      setState(() {
        _isLoading = true;
      });
      _login();
    }
  }

  _login() async {
    var uri = Uri.http('user:pass@localhost:8080', 'api/customer');
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          )
        ],
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
        errorText: null,
        suffixIcon: Icon(Icons.email),
      ),
      onSaved: (email) => _email = email!,
      validator: (email) {
        if (email!.isEmpty) {
          return 'Email cannot be empty';
        }
        return null;
      },
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
      onSaved: (password) => _password = password!,
      onFieldSubmitted: (_) => _onSubmit(),
      validator: (password) {
        if (password!.isEmpty) {
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
