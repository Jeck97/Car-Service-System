import 'package:cass_branch/api/customer_api.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/utils/dialog_utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddCustomerDialog extends StatefulWidget {
  @override
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _nameController = TextEditingController();
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();

  void _onAdd() async {
    final currentState = _formKey.currentState;
    if (!currentState.validate()) return;
    currentState.save();
    setState(() => _isLoading = true);
    final response = await CustomerAPI.add(
      customer: Customer(
        name: _nameController.text.trim(),
        phoneNo: _phoneNoController.text.trim(),
        email: _emailController.text.isNotEmpty
            ? _emailController.text.trim()
            : null,
        type: 'normal user',
        datetimeRegistered: DateTime.now().toString(),
      ),
    );
    if (response.isSuccess) _onDismiss();
    DialogUtils.show(context, response.message);
    setState(() => _isLoading = false);
  }

  void _onDismiss() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: AlertDialog(
        contentPadding: PADDING32,
        actionsPadding: PADDING24,
        title: DialogTitle('Add New Customer'),
        content: _AddCustomerDialogContent(
          formKey: _formKey,
          nameController: _nameController,
          phoneNoController: _phoneNoController,
          emailController: _emailController,
        ),
        actions: [
          DialogAction(label: 'CANCEL', onPressed: _onDismiss),
          DialogAction(label: 'ADD', onPressed: _onAdd),
        ],
      ),
    );
  }
}

class _AddCustomerDialogContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneNoController;
  final TextEditingController emailController;
  _AddCustomerDialogContent({
    @required this.formKey,
    @required this.nameController,
    @required this.phoneNoController,
    @required this.emailController,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 300,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _nameFormField(),
            _phoneNoFormField(),
            _emailFormField(),
          ],
        ),
      ),
    );
  }

  Widget _nameFormField() {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.person),
        labelText: 'Customer name *',
        labelStyle: TextStyle(fontSize: 20),
        helperText: 'Full name same as name on IC',
      ),
      controller: nameController,
      validator: (name) => name.trim().isEmpty ? 'Name is required' : null,
    );
  }

  Widget _phoneNoFormField() {
    return TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.phone),
          labelText: 'Phone number *',
          labelStyle: TextStyle(fontSize: 20),
          helperText: 'Example: 0123456789',
        ),
        controller: phoneNoController,
        validator: (phoneNo) {
          if (phoneNo.isEmpty) return 'Phone number is required';
          if ((phoneNo.length < 10 || phoneNo.length > 11) ||
              (phoneNo[0] != '0' || phoneNo[1] != '1'))
            return 'Invalid phone number format';
          return null;
        });
  }

  Widget _emailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.email),
        labelText: 'Email address',
        labelStyle: TextStyle(fontSize: 20),
        helperText: 'Example: example@mail.com',
      ),
      controller: emailController,
      validator: (email) =>
          email.trim().isNotEmpty && !EmailValidator.validate(email)
              ? 'Invalid email format'
              : null,
    );
  }
}
