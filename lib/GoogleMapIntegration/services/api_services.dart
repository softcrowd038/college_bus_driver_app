// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracking_user/login_and_registration/pages/login_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService with ChangeNotifier {
  String baseUrl = "http://192.168.1.21:8090/api";
  bool _isLoading = false;
  String? _message;
  dynamic _data;
  bool get isLoading => _isLoading;
  String? get message => _message;
  dynamic get data => _data;

  Future<void> postLatLong(double latitude, double longitude) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final busid = sharedPreferences.getString('bus_id');

    if (busid == null) {
      print("Error: bus_id is null");
      _message = 'Error: bus_id is null';
      notifyListeners();
      return;
    }

    print('$latitude, $longitude, $busid');
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lat-long'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'lattitude': latitude,
          'longitude': longitude,
          'bus_id': busid,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("Response Data: ${responseData}");
        _message = responseData['message'];
        _data = responseData['data'];
      } else {
        print(
            "Failed to post data, Status Code: ${response.statusCode}, Response: ${response.body}");
        _message = 'Failed to post data: ${response.body}';
      }
    } catch (error) {
      print("Error: $error");
      _message = 'Error occurred: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<int>> fetchLatLongIds() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lat-long'));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody is List<dynamic>) {
          return responseBody.map<int>((item) {
            final id = item['id'];
            return id is String ? int.parse(id) : id as int;
          }).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to load latlong IDs, Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching latlong IDs: $e');
      return [];
    }
  }

  Future<void> deleteLatLong(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/lat-long/$id'),
      );

      if (response.statusCode == 200) {
        _message = 'Data deleted successfully!';
        print(_message);
      } else {
        _message = 'Failed to delete data: ${response.body}';
        print(_message);
      }
    } catch (error) {
      _message = 'Error occurred: $error';
      print(_message);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isRemoved = await sharedPreferences.remove('auth_token');
    if (isRemoved == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }
}
