import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';

import 'view/main_page.dart';
import 'model/branch.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DesktopWindow.setMinWindowSize(Size(1000, 750));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: 'CaSS-Branch Desktop App',
      // home: LoginPage(),
      home: MainPage(
        Branch(
          id: 2,
          email: 'haha',
          name: 'CaSS Bayan Lepas',
          location: '11900 Bayan Lepas, Penang',
        ),
      ),
    );
  }
}
