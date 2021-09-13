import 'package:cass_customer/api/customer_api.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'main_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _onSubmit() async {
    final currentState = _formKey.currentState!;
    if (!currentState.validate()) return;
    currentState.save();
    setState(() => _isLoading = true);
    final response = await CustomerAPI.login(
      Customer(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
    if (response.isSuccess) {
      Customer.instance = response.data;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => MainPage()), (route) => false);
    } else
      DialogUtils.show(context, response.message!);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.car_repair_rounded,
                        color: Colors.indigoAccent,
                        size: 144,
                      ),
                      Text(
                        "CaSS Customer",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign to continue",
                        style: TextStyle(
                          color: Colors.indigo.shade200,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 36),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'EMAIL',
                          suffixIcon: Icon(Icons.email_outlined),
                        ),
                        controller: _emailController,
                        validator: (email) {
                          if (email == null || email.trim().isEmpty)
                            return 'Email cannot be empty';
                          if (!EmailValidator.validate(email))
                            return 'Invalid email format';
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          suffixIcon: Icon(Icons.lock_outline),
                        ),
                        onFieldSubmitted: (_) => _onSubmit(),
                        controller: _passwordController,
                        validator: (password) {
                          if (password == null || password.trim().isEmpty)
                            return 'Password cannot be empty';
                          else if (password.trim().length < 8)
                            return 'Password cannot be less than 8 charaters';
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.indigo,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 48),
                        child: ElevatedButton(
                          onPressed: _onSubmit,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account?",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => RegisterPage()),
                            ),
                            child: Text(
                              "Create a new account",
                              style: TextStyle(
                                color: Colors.indigo,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
