import 'dart:convert';

import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BranchAPI {
  static final String _unencodedPath = 'cass/api/branches';

  static Future<Response<Branch>> login({
    @required String email,
    @required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, '$_unencodedPath/login'),
        headers: HEADERS,
        body: jsonEncode({'email': email, 'password': password}),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: Branch.fromJson(responseBody[Response.DATA]),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Login Branch: ' + SERVER_ERROR);
    }
  }
}
