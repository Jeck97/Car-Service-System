import 'package:cass_branch/api/branch_api.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:cass_branch/view/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'components/login_backgroud.dart';
import 'components/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  void _onSubmit({
    @required FormState currentState,
    @required String email,
    @required String password,
  }) async {
    if (currentState.validate()) {
      currentState.save();
      setState(() => _isLoading = true);
      final response = await BranchAPI.login(email: email, password: password);
      response.isSuccess
          ? _navigate(response.data)
          : DialogUtils.show(context, response.message);
      setState(() => _isLoading = false);
    }
  }

  void _navigate(Branch branch) {
    Branch.instance = branch;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainPage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            LoginBackground(),
            LoginForm(onSubmit: _onSubmit),
          ],
        ),
      ),
    );
  }
}
