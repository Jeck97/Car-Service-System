import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerDetailInformationPanel extends StatelessWidget {
  final Customer _customer;

  CustomerDetailInformationPanel(this._customer);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: PADDING24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'CUSTOMER INFORMATION:',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Wrap(
            children: <Widget>[
              _infoText(
                label: 'Customer ID',
                value: '${_customer.id}',
              ),
              _infoText(
                label: 'Customer Name',
                value: _customer.name,
              ),
              _infoText(
                label: 'Type',
                value: _customer.type,
              ),
              _infoText(
                label: 'Registered On',
                value: _customer.datetimeRegistered,
              ),
              _infoText(
                label: 'Phone Number',
                value: _customer.phoneNo,
              ),
              _infoText(
                label: 'Email Address',
                value: _customer.email != null ? _customer.email : '-',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoText({
    @required String label,
    @required String value,
  }) {
    return Container(
      width: 400.0,
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: <InlineSpan>[
            TextSpan(text: label, style: TextStyle(color: Colors.black)),
            TextSpan(text: ': ', style: TextStyle(color: Colors.black)),
            TextSpan(text: value, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
