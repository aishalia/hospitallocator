import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'about_page.dart'; // Import the About Page

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const CameraPosition _initialLocation = CameraPosition(
    target: LatLng(3.1390, 101.6869), // Kuala Lumpur
    zoom: 10.0,
  );

  LatLng? _selectedLocation;

  final List<Map<String, dynamic>> hospitals = [
    {"name": "Hospital Kuala Lumpur (HKL)", "lat": 3.1738, "lng": 101.7005},
    {"name": "Hospital Selayang", "lat": 3.2705, "lng": 101.6507},
    {"name": "Hospital Serdang", "lat": 2.9728, "lng": 101.7176},
    {"name": "Hospital Ampang", "lat": 3.1155, "lng": 101.7673},
    {
      "name": "Hospital Sultanah Aminah (Johor Bahru)",
      "lat": 1.4671,
      "lng": 103.7464,
    },
    {
      "name": "Hospital Sultanah Bahiyah (Alor Setar)",
      "lat": 6.1529,
      "lng": 100.4033,
    },
    {
      "name": "Hospital Tengku Ampuan Rahimah (Klang)",
      "lat": 3.0370,
      "lng": 101.4407,
    },
    {"name": "Hospital Putrajaya", "lat": 2.9295, "lng": 101.6826},
    {
      "name": "Hospital Sultanah Nur Zahirah (Kuala Terengganu)",
      "lat": 5.3121,
      "lng": 103.1325,
    },
    {"name": "Hospital Melaka", "lat": 2.2251, "lng": 102.4506},
    {
      "name": "Hospital Sultan Haji Ahmad Shah (Temerloh)",
      "lat": 3.4564,
      "lng": 102.4083,
    },
    {
      "name": "Hospital Tuanku Ja’afar (Seremban)",
      "lat": 2.7184,
      "lng": 101.9400,
    },
    {
      "name": "Hospital Raja Permaisuri Bainun (Ipoh)",
      "lat": 4.5973,
      "lng": 101.0901,
    },
    {
      "name": "Hospital Sultan Ismail (Johor Bahru)",
      "lat": 1.5639,
      "lng": 103.7853,
    },
    {
      "name": "Hospital Universiti Sains Malaysia (Kubang Kerian)",
      "lat": 6.0892,
      "lng": 102.2736,
    },
  ];

  Set<Marker> _createHospitalMarkers() {
    return hospitals.map((hospital) {
      return Marker(
        markerId: MarkerId(hospital["name"]),
        position: LatLng(hospital["lat"], hospital["lng"]),
        infoWindow: InfoWindow(title: hospital["name"]),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    }).toSet();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      debugPrint("User Location: $_selectedLocation");
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  LatLng _findNearestHospital(LatLng userLatLng) {
    double minDistance = double.infinity;
    LatLng nearestHospital = LatLng(hospitals[0]["lat"], hospitals[0]["lng"]);
    String nearestHospitalName = hospitals[0]["name"];

    for (var hospital in hospitals) {
      double distance = _calculateDistance(
        userLatLng.latitude,
        userLatLng.longitude,
        hospital["lat"],
        hospital["lng"],
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestHospital = LatLng(hospital["lat"], hospital["lng"]);
        nearestHospitalName = hospital["name"];
      }
    }

    _showNearestHospitalDialog(
      nearestHospitalName,
      minDistance,
      nearestHospital,
    );
    return nearestHospital;
  }

  void _showNearestHospitalDialog(
    String hospitalName,
    double distance,
    LatLng coordinates,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nearest Hospital"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("🏥 $hospitalName"),
            Text("📍 Latitude: ${coordinates.latitude}"),
            Text("📍 Longitude: ${coordinates.longitude}"),
            Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double R = 6371;
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  void _onMapTapped(LatLng tappedLocation) {
    setState(() {
      _selectedLocation = tappedLocation;
    });

    _findNearestHospital(tappedLocation);
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WELCOME! ${widget.user.displayName?.toUpperCase() ?? "USER"}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline), // Info icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: _initialLocation,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _createHospitalMarkers(),
        onTap: _onMapTapped,
      ),
    );
  }
}
