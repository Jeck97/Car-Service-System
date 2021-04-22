import 'package:cass_branch/utils/const.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class NavigationBar extends StatefulWidget {
  final bool isCollapsed;
  NavigationBar(this.isCollapsed);
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isCollapsed ? 100 : 250,
      height: MediaQuery.of(context).size.height,
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _logoPart(),
            _menuPart(),
            _logoutPart(),
          ],
        ),
      ),
    );
  }

  Widget _logoPart() {
    return Icon(
      Icons.flutter_dash,
      color: Colors.white,
      size: 80,
    );
  }

  Widget _menuPart() {
    return Expanded(
      child: ListView.builder(
        itemCount: NAV_ICONS.length,
        itemBuilder: (context, index) {
          final int _index = index;
          final bool _isSelected = _index == currentIndex;
          return Container(
              child: TextButton(
                  onPressed: () => setState(() => currentIndex = _index),
                  child: _menu(_index, _isSelected)),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 3,
                    color: _isSelected ? Colors.black : Colors.transparent,
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _logoutPart() {
    return TextButton(
      child: Icon(Icons.logout, color: Colors.white),
      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginPage(),
          ),
          (Route<dynamic> route) => false),
    );
  }

  Widget _menu(int index, bool isSelected) {
    return widget.isCollapsed
        ? Icon(
            NAV_ICONS[index],
            color: isSelected ? Colors.black : Colors.white,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                NAV_ICONS[index],
                color: isSelected ? Colors.black : Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                NAV_TITLES[index].toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                ),
              )
            ],
          );
  }
}
