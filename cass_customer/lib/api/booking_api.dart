import 'dart:convert';

import 'package:cass_customer/model/booking.dart';
import 'package:cass_customer/model/customer.dart';
import 'package:cass_customer/model/response.dart';
import 'package:cass_customer/model/servicing.dart';
import 'package:cass_customer/utils/constant.dart';
import 'package:http/http.dart' as http;

class BookingAPI {
  static final String _unencodedPath = 'cass/api/reservations';

  static Future<Response<List<Booking>>> fetch(Customer customer) async {
    try {
      final response = await http.get(
        Uri.http(AUTHORITY, _unencodedPath, {"customer": '${customer.id}'}),
        headers: HEADERS,
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        message: responseBody[Response.MESSAGE],
        data: List.from(responseBody[Response.DATA])
            .map((json) => Booking.fromJson(json))
            .toList(),
      );
    } catch (error) {
      print(error);
      return Response(message: 'Fetch Bookings: ' + SERVER_ERROR);
    }
  }

  // static Future<Response<Null>> update(Reservation reservation) async {
  //   try {
  //     final response = await http.patch(
  //       Uri.http(AUTHORITY, _unencodedPath + '/${reservation.id}'),
  //       headers: HEADERS,
  //       body: jsonEncode(reservation),
  //     );
  //     final responseBody = jsonDecode(response.body);
  //     return Response(
  //       isSuccess: response.statusCode == 200,
  //       message: responseBody[Response.MESSAGE],
  //     );
  //   } catch (error) {
  //     print(error);
  //     return Response(message: 'Update Reservations: ' + SERVER_ERROR);
  //   }
  // }

  static Future<Response<int>> add(Booking booking) async {
    try {
      final response = await http.post(
        Uri.http(AUTHORITY, _unencodedPath),
        headers: HEADERS,
        body: jsonEncode(booking),
      );
      final responseBody = jsonDecode(response.body);
      return Response(
        isSuccess: response.statusCode == 200,
        data: responseBody[Response.DATA],
        message: responseBody[Response.MESSAGE],
      );
    } catch (error) {
      print(error);
      return Response(message: 'Add Booking: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Null>> updateServicing({
    required Servicing servicing,
    required Booking booking,
  }) async {
    try {
      final response = await http.patch(
        Uri.http(AUTHORITY, _unencodedPath + '/servicings/${booking.id}'),
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
      return Response(message: 'Update Servicing: ' + SERVER_ERROR);
    }
  }

  static Future<Response<Servicing>> fetchServicing(
      {Customer? customer, Booking? booking}) async {
    try {
      final id = customer != null ? customer.id : booking!.id;
      Map<String, dynamic>? queryParameters =
          customer != null ? {"type": "customer"} : null;
      final response = await http.get(
        Uri.http(
          AUTHORITY,
          _unencodedPath + "/servicings/$id",
          queryParameters,
        ),
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
}
