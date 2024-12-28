// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracking_user/dashboard/Model/bus_scan_model.dart';
import 'package:location_tracking_user/data/api_data.dart';

class ScannerProvider extends ChangeNotifier {
  Future<BusScanModel> getBusColor(String busID) async {
    final url = Uri.parse('$baseUrl/buses/daily-color/$busID');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('success');
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final busScanModel = BusScanModel.fromJson(jsonResponse);
        notifyListeners();
        return busScanModel;
      } else {
        print(response.body);
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }
}
