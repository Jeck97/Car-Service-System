import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/utils/dialog_utils.dart';
import 'package:cass_customer/view/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final customer = Customer.instance!;
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _upperProfile(customer.name!),
            SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 8),
                    color: Colors.grey,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _lowerProfileInfo(
                    title: customer.email!,
                    icon: Icons.email_rounded,
                  ),
                  Divider(height: 0, thickness: 1),
                  _lowerProfileInfo(
                      title: customer.phoneNo!,
                      icon: Icons.phone_android_rounded),
                  Divider(height: 0, thickness: 1),
                  _lowerProfileInfo(
                    title: customer.datetimeRegisteredString!,
                    icon: Icons.app_registration_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "fab_profile_page",
        onPressed: () async {
          bool? isYes = await DialogUtils.confirm(
            context,
            "Are you confirm to logout?",
          );
          if (isYes == true) {
            Customer.instance = null;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false);
          }
        },
        child: Icon(Icons.logout),
        tooltip: "Logout",
      ),
    );
  }

  ListTile _lowerProfileInfo({required String title, required IconData icon}) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: IconButton(
        icon: Icon(Icons.chevron_right_rounded),
        onPressed: () {},
      ),
      horizontalTitleGap: 0,
    );
  }

  Container _upperProfile(String name) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 8),
            color: Colors.grey,
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.indigo.shade300,
            Colors.indigo.shade500,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(
              Icons.account_circle,
              size: 120,
              color: Colors.white.withOpacity(0.9),
            ),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
