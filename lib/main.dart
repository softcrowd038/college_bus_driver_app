import 'package:workmanager/workmanager.dart';
import 'package:location_tracking_user/GoogleMapIntegration/services/api_services.dart';
import 'package:location_tracking_user/app/my_app.dart';
import 'package:location_tracking_user/dashboard/Provider/bus_provider.dart';
import 'package:location_tracking_user/dashboard/Provider/get_color_by_busid.dart';
import 'package:location_tracking_user/dashboard/Utils/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:location_tracking_user/login_and_registration/Model/user_.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Background Task Callback
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      if (taskName == 'locationUpdateTask') {
        final locationProvider = LocationProvider();
        final apiService = ApiService();

        LatLng? currentPosition = locationProvider.currentPosition;
        if (currentPosition != null) {
          await apiService.postLatLong(
            currentPosition.latitude,
            currentPosition.longitude,
          );
        }

        List<int> latLongIds = await apiService.fetchLatLongIds();
        if (latLongIds.isNotEmpty) {
          int recentId = latLongIds.last;
          for (int id in latLongIds) {
            if (id != recentId) {
              await apiService.deleteLatLong(id);
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error in WorkManager task: $e");
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  Workmanager().registerPeriodicTask(
    '1',
    'locationUpdateTask',
    frequency: const Duration(minutes: 15),
  );

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
