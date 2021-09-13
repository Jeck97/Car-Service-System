import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'view/login_page.dart';
// import 'view/main_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Customer.instance = Customer(
    //   id: 1,
    //   name: "Tiang King Jeck",
    //   phoneNo: "0138042421",
    //   email: "jeck9797@gmail.com",
    //   type: "App User",
    //   datetimeRegistered: d.DateUtils.toDateTime("2021-06-14 10:43:35"),
    // );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CaSS-Branch Mobile App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: LoginPage(),
      // home: MainPage(),
    );
  }
}
