import 'dart:convert';

import 'package:cass_branch/model/action.dart';
import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/model/service.dart';
import 'package:cass_branch/model/task.dart';
import 'package:cass_branch/utils/constants.dart';
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

  static Future<Response<List<Action>>> fetchActions(Service service,
      {String actions}) async {
    try {
      final queryParameters = {'service': '${service.id}'};
      if (actions != null) queryParameters["actions"] = actions;
      final path = _unencodedPath + "/tasks/actions";
      final response = await http.get(
        Uri.http(AUTHORITY, path, queryParameters),
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

  static Future<Response<List<Service>>> fetchReserved(Branch branch) async {
    try {
      final response = await http.get(
        Uri.http(
          AUTHORITY,
          _unencodedPath + "/reserved",
          {'branch': '${branch.id}'},
        ),
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
