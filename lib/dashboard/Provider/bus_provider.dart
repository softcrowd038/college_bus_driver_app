import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracking_user/dashboard/Model/bus_model.dart';
import 'package:location_tracking_user/data/api_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusDetailsProvider extends ChangeNotifier {
  Future<BusDetails?> fetchBusDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final busId = sharedPreferences.getString('bus_id');
    final url = Uri.parse('$baseUrl/buses/bus/$busId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          return BusDetails.fromJson(jsonResponse);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
