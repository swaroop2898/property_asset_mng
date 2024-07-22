import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:property_asset_mag/screens/view_properties_screen.dart';

import 'model/propertyDetails.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<LatLng> polygonPoints = [];
  List<Marker> markers = [];
  final MapController mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // Properties to hold location details
  String _address = '';
  String _district = '';
  String _state = '';
  String _pincode = '';
  String _country = '';

  void onTap(LatLng point) {
    setState(() {
      polygonPoints.add(point);
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 20,
          ),
        ),
      );
    });
    _reverseGeocode(point);
  }

  void _calculateArea() {
    if (polygonPoints.length < 3) {
      _showSnackBar('At least 3 points are required to calculate area.');
      return;
    }
    double area = _calculatePolygonArea(polygonPoints);
    _showSnackBar('Polygon Area: ${area.toStringAsFixed(2)} sq meters');
  }

  // Helper method to calculate the polygon area using spherical excess formula
  double _calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    const double radius = 6378137.0; // Earth's radius in meters
    double area = 0.0;

    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;

      double lat1 = _toRadians(points[i].latitude);
      double lon1 = _toRadians(points[i].longitude);
      double lat2 = _toRadians(points[j].latitude);
      double lon2 = _toRadians(points[j].longitude);

      area += (lon2 - lon1) * (2 + sin(lat1) + sin(lat2));
    }

    area = area * radius * radius / 2.0;
    return area.abs();
  }

  // Helper method to convert degrees to radians
  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  void _clearPolygon() {
    setState(() {
      polygonPoints.clear();
      markers.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng newCenter = LatLng(location.latitude, location.longitude);

        setState(() {
          mapController.move(newCenter, 13.0);
        });
      } else {
        _showSnackBar('No results found for "$query".');
      }
    } catch (e) {
      _showSnackBar('Error searching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _calculateArea,
        child: const Icon(Icons.calculate),
      ),
      appBar: AppBar(
        title: const Text('Add Property'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearPolygon,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialZoom: 13.0,
              maxZoom: 22.0,
              minZoom: 1.0,
              initialCenter: const LatLng(12.9716, 77.5946),
              onTap: (tapPosition, point) {
                onTap(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              if (polygonPoints.isNotEmpty)
                PolygonLayer(
                  polygonCulling: false,
                  polygons: [
                    Polygon(
                      points: polygonPoints,
                      color: Colors.blue.withOpacity(0.5),
                      borderStrokeWidth: 2,
                      borderColor: Colors.blue,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 60,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchLocation(_searchController.text);
                  },
                ),
              ),
              onSubmitted: _searchLocation,
            ),
          ),
          Positioned(
              bottom: 80,
              right: 10,
              child: InkWell(
                onTap: (){
                  _viewPropertyDetails();
                },
                child: Container(
                  color: Colors.blueAccent,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "View Property details",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void _reverseGeocode(LatLng point) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _address = placemark.street ?? '';
          _district = placemark.locality ?? '';
          _state = placemark.administrativeArea ?? '';
          _pincode = placemark.postalCode ?? '';
          _country = placemark.country ?? '';
        });
      }
    } catch (e) {
      print('Error performing reverse geocoding: $e');
    }
  }

  void _viewPropertyDetails() {
    Property property = Property(
      polygonPoints: polygonPoints,
      address: _address,
      district: _district,
      state: _state,
      pincode: _pincode,
      country: _country,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PropertyDetailsScreen(property: property, polygonPoints, markers),
      ),
    );
  }
}
