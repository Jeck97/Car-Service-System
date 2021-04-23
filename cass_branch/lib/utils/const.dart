import 'package:flutter/material.dart';

const String AUTHORITY = 'user:pass@localhost:8080';
const String MESSAGE = 'message';
const String DATA = 'data';

const Map<String, String> HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8',
};

const List<IconData> NAV_ICONS = [
  Icons.dashboard,
  Icons.today,
  Icons.handyman,
  Icons.people,
  Icons.payments,
  Icons.analytics,
  Icons.settings,
];

const List<String> NAV_TITLES = [
  'Dashboard',
  'Booking',
  'Service',
  'Customer',
  'Payment',
  'Report',
  'Setting',
];

const int DASHBOARD = 0;
const int BOOKING = 1;
const int SERVICE = 2;
const int CUSTOMER = 3;
const int PAYMENT = 4;
const int REPORT = 5;
const int SETTING = 6;
