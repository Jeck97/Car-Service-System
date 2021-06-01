import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String AUTHORITY = 'user:pass@127.0.0.1:8080';
const Map<String, String> HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8',
};
const String SERVER_ERROR = 'Server connection error';

final DateFormat formatDefault = DateFormat('yyyy-MM-dd hh:mm:ss');

const BorderRadius BORDER_RADIUS08 = BorderRadius.all(Radius.circular(8.0));
const BorderRadius BORDER_RADIUS24 = BorderRadius.all(Radius.circular(24.0));
const EdgeInsets PADDING08 = EdgeInsets.all(8.0);
const EdgeInsets PADDING16 = EdgeInsets.all(16.0);
const EdgeInsets PADDING24 = EdgeInsets.all(24.0);
const EdgeInsets PADDING32 = EdgeInsets.all(32.0);

const TextStyle BOLD = TextStyle(fontWeight: FontWeight.bold);
