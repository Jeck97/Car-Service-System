import 'dart:convert';

import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomerAPI {
  static final String _unencodedPath = 'cass/api/customers';

  static Future<Response<List<Customer>>> fetchAll({String search}) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath, {'search': search}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Customer.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Customers: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Null>> add({@required Customer customer}) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, _unencodedPath),
        headers: HEADERS,
        body: jsonEncode(customer),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Add Customer: ' + SERVER_ERROR);
    }
  }
}
