import 'dart:convert';

import 'package:cass_customer/model/branch.dart';
import 'package:cass_customer/model/response.dart';
import 'package:cass_customer/utils/constant.dart';
import 'package:http/http.dart' as http;

class BranchAPI {
  static final String _unencodedPath = 'cass/api/branches';

  static Future<Response<List<Branch>>> fetch() async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Branch.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Branches: ' + SERVER_ERROR);
    }
  }
}
