// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking_user/GoogleMapIntegration/services/api_services.dart';
import 'package:location_tracking_user/dashboard/Model/bus_model.dart';
import 'package:location_tracking_user/dashboard/Model/bus_scan_model.dart';
import 'package:location_tracking_user/dashboard/Provider/bus_provider.dart';
import 'package:location_tracking_user/dashboard/Provider/get_color_by_busid.dart';
import 'package:location_tracking_user/dashboard/Utils/location_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveLocationTracker extends StatefulWidget {
  const LiveLocationTracker({super.key});

  @override
  LiveLocationTrackerState createState() => LiveLocationTrackerState();
}

class LiveLocationTrackerState extends State<LiveLocationTracker> {
  GoogleMapController? mapController;
  Timer? _locationTimer;
  bool isLoading = false;
  String? todaysColor;
  BusDetails? busDetails;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _getTodaysColor();
      _fetchBusDetails();
      Provider.of<LocationProvider>(context, listen: false)
          .requestLocationPermissionAndGetCurrentLocation();
    });

    _locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!isLoading) {
        isLoading = true;
        await _postCurrentLocation();
        await _deleteAllButRecent();
        isLoading = false;
      }
    });
  }

  Future<void> _getTodaysColor() async {
    try {
      final provider = Provider.of<ScannerProvider>(context, listen: false);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final busID = sharedPreferences.getString('bus_id');

      if (busID == null) {
        throw Exception("Bus ID is null.");
      }

      final BusScanModel busScanModel = await provider.getBusColor(busID);

      if (busScanModel.success) {
        setState(() {
          todaysColor = busScanModel.dailyColor;
        });
      }
    } catch (e) {
      debugPrint("Error fetching today's color: $e");
    }
  }

  Future<void> _fetchBusDetails() async {
    try {
      final provider = Provider.of<BusDetailsProvider>(context, listen: false);
      final details = await provider.fetchBusDetails();
      setState(() {
        busDetails = details;
      });
    } catch (e) {
      debugPrint("Error fetching bus details: $e");
    }
  }

  Future<void> _postCurrentLocation() async {
    try {
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      final apiService = Provider.of<ApiService>(context, listen: false);

      LatLng? currentPosition = locationProvider.currentPosition;
      if (currentPosition != null) {
        await apiService.postLatLong(
          currentPosition.latitude,
          currentPosition.longitude,
        );
      }
    } catch (e) {
      debugPrint("Error posting location: $e");
    }
  }

  Future<void> _deleteAllButRecent() async {
    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      List<int> latLongIds = await apiService.fetchLatLongIds();

      if (latLongIds.isNotEmpty) {
        int recentId = latLongIds.last;

        for (int id in latLongIds) {
          if (id != recentId) {
            await apiService.deleteLatLong(id);
          }
        }
      }
    } catch (e) {
      debugPrint("Error deleting old location entries: $e");
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    _locationTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Live Location Tracker",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.height * 0.022),
            ),
            GestureDetector(
              onTap: () {
                final apiService =
                    Provider.of<ApiService>(context, listen: false);
                apiService.logout(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_back_ios,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height * 0.018),
                  Text(
                    "logout",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.018),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Consumer<LocationProvider>(
            builder: (context, locationProvider, _) {
              LatLng? currentPosition = locationProvider.currentPosition;

              return currentPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: currentPosition,
                        zoom: 13.5,
                      ),
                      myLocationEnabled: true,
                      compassEnabled: true,
                      markers: {
                        Marker(
                          markerId: const MarkerId('current_location'),
                          position: currentPosition,
                          infoWindow: InfoWindow(
                            title: 'Current Location',
                            snippet:
                                'Lat: ${currentPosition.latitude}, Lng: ${currentPosition.longitude}',
                          ),
                        ),
                      },
                    );
            },
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(
                          MediaQuery.of(context).size.width * 0.20))),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.018,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Color:',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.018),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.04,
                        width: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                              todaysColor?.replaceFirst('#', '0xff') ??
                                  '0xffffffff')),
                        ),
                      )
                    ],
                  ),
                  if (busDetails != null)
                    Column(
                      children: [
                        Text(
                          '\n Welcome to ${busDetails?.busName}, ${busDetails?.busDriver}! Glad To see you again. Let me Tell You Some details About Our Bus ${busDetails?.busName}. ${busDetails?.busName} is having  seating capacity of ${busDetails?.totalSeats}, and it travel from ${busDetails?.startingPoint} to ${busDetails?.endingPoint} covering the stops ${busDetails?.stopNames}. The distance is almost ${busDetails?.distance}.',
                        ),
                        Text(
                          ' \n HAPPY JOURNEY!',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.018),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
