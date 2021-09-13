import 'dart:convert';

import 'package:cass_customer/model/action.dart';
import 'package:cass_customer/model/branch.dart';
import 'package:cass_customer/model/response.dart';
import 'package:cass_customer/model/service.dart';
import 'package:cass_customer/model/task.dart';
import 'package:cass_customer/utils/constant.dart';
import 'package:http/http.dart' as http;

class ServiceAPI {
  static final String _unencodedPath = 'cass/api/services';

  static Future<Response<List<Service>>> fetch(Branch branch) async {
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

  static Future<Response<List<Task>>> fetchTasks(Service service) async {
    try {
      final path = _unencodedPath + "/tasks";
      final response = await http.get(
        Uri.http(AUTHORITY, path, {'service': '${service.id}'}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Task.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Tasks: ' + SERVER_ERROR);
    }
  }

  static Future<Response<List<Action>>> fetchActions({
    required Service service,
    required String actions,
  }) async {
    try {
      final response = await http.get(
        Uri.http(
          AUTHORITY,
          _unencodedPath + "/tasks/actions",
          {"service": "${service.id}", "actions": actions},
        ),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Action.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Actions: ' + SERVER_ERROR);
    }
  }
}
