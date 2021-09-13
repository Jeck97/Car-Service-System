import 'package:cass_customer/api/customer_api.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _onSubmit() async {
    final currentState = _formKey.currentState!;
    if (!currentState.validate()) return;
    currentState.save();
    setState(() => _isLoading = true);
    final response = await CustomerAPI.add(
      Customer(
        name: _nameController.text.trim(),
        phoneNo: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        type: Customer.TYPE_APP_USER,
        datetimeRegistered: DateTime.now(),
      ),
    );
    setState(() => _isLoading = false);
    if (response.isSuccess) Navigator.of(context).pop();
    DialogUtils.show(context, response.message!);
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
                      Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Create a new account",
                        style: TextStyle(
                          color: Colors.indigo.shade200,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'NAME',
                          suffixIcon: Icon(Icons.person_outline),
                        ),
                        controller: _nameController,
                        validator: (name) {
                          if (name == null || name.trim().isEmpty)
                            return 'Name cannot be empty';
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'PHONE',
                          suffixIcon: Icon(Icons.phone_android_outlined),
                        ),
                        controller: _phoneController,
                        validator: (phoneNo) {
                          if (phoneNo == null || phoneNo.isEmpty)
                            return 'Phone number is required';
                          if ((phoneNo.length < 10 || phoneNo.length > 11) ||
                              (phoneNo[0] != '0' || phoneNo[1] != '1'))
                            return 'Invalid phone number format';
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
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
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          suffixIcon: Icon(Icons.lock_outline),
                        ),
                        controller: _passwordController,
                        validator: (password) {
                          if (password == null || password.trim().isEmpty)
                            return 'Password cannot be empty';
                          else if (password.trim().length < 8)
                            return 'Password cannot be less than 8 charaters';
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'CONFIRM PASSWORD',
                          suffixIcon: Icon(Icons.lock_outline),
                        ),
                        onFieldSubmitted: (_) => _onSubmit(),
                        validator: (password) {
                          if (password == null || password.trim().isEmpty)
                            return 'Confirmed password cannot be empty';
                          else if (password.trim() !=
                              _passwordController.text.trim())
                            return 'Confirmed password not match with password';
                          return null;
                        },
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 48),
                        child: ElevatedButton(
                          onPressed: _onSubmit,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              "CREATE ACCOUNT",
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
                            "Already have a account?",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "Login",
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
