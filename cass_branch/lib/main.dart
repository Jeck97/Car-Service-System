import 'package:cass_branch/view/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DesktopWindow.setMinWindowSize(Size(1000, 750));
    // Branch.instance = Branch(
    //   id: 1,
    //   email: 'cassb001@mail.com',
    //   name: 'CaSS Jelutong',
    //   location: 'Batu Lanchang, 11600 Jelutong, Penang',
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      title: 'CaSS-Branch Desktop App',
      home: LoginPage(),
      // home: MainPage(),
    );
  }
}
