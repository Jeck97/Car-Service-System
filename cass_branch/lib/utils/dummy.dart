import 'dart:convert';
import 'dart:math';

import 'package:cass_branch/utils/const.dart';
import 'package:http/http.dart' as http;

class Dummy {
  static void generateCustomers(int qty, Function callback) async {
    StringBuffer resultBuffer = StringBuffer();
    Random random = Random();
    DateTime now = DateTime.now();

    for (int i = 0; i < qty; i++) {
      bool isAppUser = random.nextBool();
      int rdmNum = random.nextInt(100);
      Map<String, dynamic> customer = {
        'name': 'customer$i@$rdmNum',
        'phone_no': '01${random.nextInt(99999999).toString().padLeft(8, '0')}',
        'email': isAppUser ? 'mail${i}_$rdmNum@random.com' : null,
        'password': isAppUser ? 'random123' : null,
        'is_app_user': isAppUser,
        'date_created': DateTime(now.year, now.month, now.day + i).toString(),
      };

      await http
          .post(Uri.http(AUTHORITY, 'api/customers'),
              headers: HEADERS, body: jsonEncode(customer))
          .then(
              (response) =>
                  resultBuffer.writeln(jsonDecode(response.body)[MESSAGE]),
              onError: (error) => resultBuffer.writeln(SERVER_ERROR));
    }

    callback(resultBuffer.toString());
  }
}
