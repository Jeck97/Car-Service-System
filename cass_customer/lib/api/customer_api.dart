import 'dart:convert';

import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/model/response.dart';
import 'package:cass_customer/utils/constant.dart';
import 'package:http/http.dart' as http;

class CustomerAPI {
  static final String _unencodedPath = 'cass/api/customers';

  static Future<Response<Customer>> login(Customer customer) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, _unencodedPath + "/login"),
        headers: HEADERS,
        body: jsonEncode(customer),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: Customer.fromJson(responseBody[Response.DATA]),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Login Customers: ' + SERVER_ERROR);
    }
  }

  static Future<Response<int>> add(Customer customer) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, _unencodedPath),
        headers: HEADERS,
        body: jsonEncode(customer),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        data: responseBody[Response.DATA],
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Register Customer: ' + SERVER_ERROR);
    }
  }
}
