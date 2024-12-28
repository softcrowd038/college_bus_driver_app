// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracking_user/dashboard/pages/dashboard_page.dart';
import 'package:location_tracking_user/data/api_data.dart';
import 'package:location_tracking_user/login_and_registration/pages/login_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApiService {
  Future<void> loginStudent(
      BuildContext context, String busID, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final url = Uri.parse('$baseUrl/bus-regi/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'bus_id': busID, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        await sharedPreferences.setString('auth_token', responseBody['token']);
        await sharedPreferences.setString(
            'bus_id', responseBody['bus_id'].toString());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You logged in successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LiveLocationTracker()),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseBody['error'] ?? 'An unknown error occurred')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
