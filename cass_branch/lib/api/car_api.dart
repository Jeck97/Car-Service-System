import 'dart:convert';

import 'package:cass_branch/model/car.dart';
import 'package:cass_branch/model/car_brand.dart';
import 'package:cass_branch/model/car_model.dart';
import 'package:cass_branch/model/customer.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:http/http.dart' as http;

class CarAPI {
  static final String _unencodedPath = 'cass/api/cars';

  static Future<Response<List<Car>>> fetchByCustomer(Customer customer) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath, {'customer': '${customer.id}'}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Car.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Cars: ' + SERVER_ERROR);
    }
  }

  static Future<Response<List<CarModel>>> fetchModels() async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, '$_unencodedPath/models'),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => CarModel.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Car Models: ' + SERVER_ERROR);
    }
  }

  static Future<Response<List<CarBrand>>> fetchBrands() async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, '$_unencodedPath/brands'),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => CarBrand.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Car Brands: ' + SERVER_ERROR);
    }
  }

  static Future<Response<int>> add(Car car) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, _unencodedPath),
        headers: HEADERS,
        body: jsonEncode(car),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        data: responseBody[Response.DATA],
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Add Car: ' + SERVER_ERROR);
    }
  }
}
