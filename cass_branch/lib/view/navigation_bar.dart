import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class NavigationBar extends StatelessWidget {
  final bool isCollapsed;
  final int currentIndex;
  final Function updateIndex;
  NavigationBar(this.isCollapsed, this.currentIndex, this.updateIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 100 : 250,
      height: MediaQuery.of(context).size.height,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _logoPart(),
            _menuPart(),
            _logoutPart(context),
          ],
        ),
      ),
    );
  }

  Widget _logoPart() {
    return DrawerHeader(
      child: Center(
        child: Icon(
          Icons.flutter_dash,
          color: Colors.white,
          size: 60,
        ),
      ),
    );
  }

  Widget _menuPart() {
    return Expanded(
      child: ListView.builder(
        itemCount: NAV_ICONS.length,
        itemBuilder: (context, index) {
          final bool isSelected = index == currentIndex;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _menu(index, isSelected),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 4,
                  color: isSelected ? Colors.black : Colors.transparent,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _logoutPart(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.white),
      onTap: () {
        Branch.setInstance(null);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => LoginPage(),
            ),
            (Route<dynamic> route) => false);
      },
    );
  }

  Widget _menu(int index, bool isSelected) {
    return ListTile(
      onTap: () => updateIndex(index),
      leading: isCollapsed
          ? null
          : Icon(
              NAV_ICONS[index],
              color: isSelected ? Colors.black : Colors.white,
            ),
      title: isCollapsed
          ? Icon(
              NAV_ICONS[index],
              color: isSelected ? Colors.black : Colors.white,
            )
          : Text(
              NAV_TITLES[index].toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
              ),
            ),
    );
  }
}
