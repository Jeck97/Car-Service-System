import 'dart:convert';

import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/model/service.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:http/http.dart' as http;

class ServiceAPI {
  static final String _unencodedPath = 'cass/api/services';

  static Future<Response<List<Service>>> fetchByBranch(Branch branch) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath, {'branch': '${branch.id}'}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Service.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Services: ' + SERVER_ERROR);
    }
  }
}
