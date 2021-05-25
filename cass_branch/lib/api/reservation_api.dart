import 'dart:convert';

import 'package:cass_branch/model/reservation.dart';
import 'package:cass_branch/model/response.dart';
import 'package:cass_branch/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservationAPI {
  static final String _unencodedPath = 'cass/api/reservations';

  static Future<Response<List<Reservation>>> fetchByCustomerId(
      {@required int customerId}) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, '$_unencodedPath/$customerId'),
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
}
