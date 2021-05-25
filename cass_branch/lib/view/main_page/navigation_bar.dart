import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:cass_branch/view/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

const List<IconData> _ICONS = [
  Icons.dashboard,
  Icons.today,
  Icons.handyman,
  Icons.people,
  Icons.payments,
  Icons.analytics,
  Icons.settings,
];
const List<String> _TITLES = [
  'Dashboard',
  'Booking',
  'Service',
  'Customer',
  'Payment',
  'Report',
  'Setting',
];

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function onIndexUpdate;

  NavigationBar({
    @required this.currentIndex,
    @required this.onIndexUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      final bool isCollapsed = sizingInformation.screenSize.width < 850;
      return Drawer(
        child: Container(
          color: Colors.blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _NavigationBarHeader(),
                      _NavigationBarMenu(
                        currentIndex: currentIndex,
                        isCollapsed: isCollapsed,
                        onIndexUpdate: onIndexUpdate,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 0.0),
              _NavigationBarFooter(),
            ],
          ),
        ),
      );
    });
  }
}

class _NavigationBarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class _NavigationBarMenu extends StatelessWidget {
  final int currentIndex;
  final bool isCollapsed;
  final Function(int index) onIndexUpdate;
  final Color _indigo_05 = Colors.indigo.withOpacity(0.5);
  final Color _indigo_900 = Colors.indigo[900];
  final Color _transparent = Colors.transparent;

  _NavigationBarMenu({
    @required this.currentIndex,
    @required this.isCollapsed,
    @required this.onIndexUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        _ICONS.length,
        (index) {
          bool isSelected = index == currentIndex;
          Color boxColor = isSelected ? _indigo_05 : _transparent;
          Color borderColor = isSelected ? _indigo_900 : _transparent;
          Color menuItemColor = isSelected ? _indigo_900 : Colors.white;
          Text label = _menuItemLabel(index, menuItemColor);
          IconButton icon = _menuItemIcon(index, menuItemColor);
          return Container(
            decoration: BoxDecoration(
              color: boxColor,
              border: Border(right: BorderSide(width: 5, color: borderColor)),
            ),
            child: ListTile(
              onTap: () => onIndexUpdate(index),
              leading: isCollapsed ? null : icon,
              title: isCollapsed ? icon : label,
            ),
          );
        },
      ),
    );
  }

  Widget _menuItemLabel(int index, Color menuItemColor) {
    return Text(
      _TITLES[index].toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: menuItemColor, fontWeight: FontWeight.bold),
    );
  }

  Widget _menuItemIcon(int index, Color menuItemColor) {
    return IconButton(
      tooltip: isCollapsed ? _TITLES[index] : null,
      icon: Icon(_ICONS[index], color: menuItemColor),
      onPressed: null,
    );
  }
}

class _NavigationBarFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout, color: Colors.white),
      tooltip: 'Logout',
      padding: PADDING16,
      onPressed: () {
        Branch.instance = null;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginPage()),
            (Route<dynamic> route) => false);
      },
    );
  }
}
