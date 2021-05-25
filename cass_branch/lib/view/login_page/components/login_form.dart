import 'package:cass_branch/utils/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final Function onSubmit;

  LoginForm({@required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _LoginFormHeading(),
          _LoginFormBody(onSubmit: onSubmit),
          _LoginFormFooter(),
        ],
      ),
    );
  }
}

class _LoginFormHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Car Service System',
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          'BRANCH',
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _LoginFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final Function({
    @required FormState currentState,
    @required String email,
    @required String password,
  }) onSubmit;

  _LoginFormBody({@required this.onSubmit});

  void _onSubmit() => onSubmit(
        currentState: formKey.currentState,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.5,
      padding: PADDING32,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BORDER_RADIUS24,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _textFieldEmail(),
            SizedBox(height: 24.0),
            _textFieldPassword(),
            SizedBox(height: 32.0),
            _buttonLogin(),
          ],
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email Address',
        labelStyle: TextStyle(fontSize: 20.0),
        suffixIcon: Icon(Icons.email),
      ),
      controller: _emailController,
      validator: (email) {
        if (email.trim().isEmpty) return 'Email cannot be empty';
        if (!EmailValidator.validate(email)) return 'Invalid email format';
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
        labelStyle: TextStyle(fontSize: 20.0),
        suffixIcon: Icon(Icons.lock),
      ),
      onFieldSubmitted: (_) => _onSubmit(),
      controller: _passwordController,
      validator: (password) {
        if (password.trim().isEmpty) {
          return 'Password cannot be empty';
        } else if (password.trim().length < 8) {
          return 'Password cannot be less than 8 charaters';
        }
        return null;
      },
    );
  }

  Widget _buttonLogin() {
    return ElevatedButton(
      onPressed: _onSubmit,
      child: Container(
        padding: PADDING16,
        width: double.infinity,
        child: Text(
          'LOGIN',
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LoginFormFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Copyright (C) 2021 com.carservicesystem. All rights reserved.',
      style: Theme.of(context).textTheme.button.copyWith(color: Colors.black87),
    );
  }
}
