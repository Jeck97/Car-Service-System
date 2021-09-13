import 'package:flutter/material.dart';

import 'booking_main_page.dart';

class BookingPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: BookingMainPage.ROUTE,
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case BookingMainPage.ROUTE:
            builder = (_) => BookingMainPage();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}
