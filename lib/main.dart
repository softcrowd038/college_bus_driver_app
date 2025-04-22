import 'package:location_tracking_user/GoogleMapIntegration/services/api_services.dart';
import 'package:location_tracking_user/app/my_app.dart';
import 'package:location_tracking_user/dashboard/Provider/bus_provider.dart';
import 'package:location_tracking_user/dashboard/Provider/get_color_by_busid.dart';
import 'package:location_tracking_user/dashboard/Utils/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:location_tracking_user/login_and_registration/Model/user_.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAppProviders());
}

class MyAppProviders extends StatelessWidget {
  const MyAppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider()),
        ChangeNotifierProvider<UserCredentials>(
            create: (_) => UserCredentials()),
        ChangeNotifierProvider<ApiService>(create: (_) => ApiService()),
        ChangeNotifierProvider<ScannerProvider>(
            create: (_) => ScannerProvider()),
        ChangeNotifierProvider<BusDetailsProvider>(
            create: (_) => BusDetailsProvider()),
      ],
      child: MaterialApp(
        title: 'Your App Title',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const MyApp(),
      ),
    );
  }
}
