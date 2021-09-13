import 'dart:convert';

import 'package:cass_branch/model/branch.dart';
import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/model/servicing.dart';
import 'package:cass_branch/model/statistic.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationAPI {
  static final String _unencodedPath = 'cass/api/reservations';
  static const String TYPE_CUSTOMER = 'customer';
  static const String TYPE_BRANCH = 'branch';

  static Future<Response<List<Reservation>>> fetch(
      {@required int id, @required String type, bool isToday = false}) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath, {type: '$id', "today": '$isToday'}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Reservation.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Reservations: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Null>> update(Reservation reservation) async {
    try {
      final response = await http.patch(
        Uri.http(AUTHORITY, _unencodedPath + '/${reservation.id}'),
        headers: HEADERS,
        body: jsonEncode(reservation),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Update Reservations: ' + SERVER_ERROR);
    }
  }

  static Future<Response<int>> add(Reservation reservation) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, _unencodedPath),
        headers: HEADERS,
        body: jsonEncode(reservation),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        data: responseBody[Response.DATA],
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Add Reservations: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Null>> updateServicing(
      Servicing servicing, Reservation reservation) async {
    try {
      final response = await http.patch(
        Uri.http(AUTHORITY, _unencodedPath + '/servicings/${reservation.id}'),
        headers: HEADERS,
        body: jsonEncode(servicing),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(
          message: 'Update Servicing Reservations: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Servicing>> fetchServicing(
      Reservation reservation) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath + "/servicings/${reservation.id}"),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: Servicing.fromJson(responseBody[Response.DATA]),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Servicing: ' + SERVER_ERROR);
    }
  }

  static Future<Response<List<Statistic>>> fetchStatistics(
      Branch branch) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, "$_unencodedPath/statistics",
            {"branch": "${branch.id}"}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Statistic.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Servicing: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Null>> deleteServicing(Servicing servicing) async {
    try {
      final response = await http.delete(
        Uri.http(AUTHORITY, _unencodedPath + '/servicings/${servicing.id}'),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Delete Servicing: ' + SERVER_ERROR);
    }
  }
}
