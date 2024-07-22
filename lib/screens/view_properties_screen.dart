import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import 'model/propertyDetails.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Property property;
  final List<LatLng> polygon;
  final List<Marker> markers;

  const PropertyDetailsScreen(this.polygon, this.markers,
      {Key? key, required this.property})
      : super(key: key);

  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late LatLng _center;
  late List<LatLng> _polygonPoints;
  late String _address;
  late String _district;
  late String _state;
  late String _pincode;
  late String _country;

  @override
  void initState() {
    super.initState();
    _polygonPoints = widget.property.polygonPoints;
    _address = widget.property.address;
    _district = widget.property.district;
    _state = widget.property.state;
    _pincode = widget.property.pincode;
    _country = widget.property.country;

    if (_polygonPoints.isNotEmpty) {
      _center = _polygonPoints.first;
    } else {
      _center = LatLng(0.0, 0.0);
    }
  }

  double _calculatePolygonArea(List<LatLng> points) {
    if (points.length < 3) return 0.0;

    double area = 0.0;
    for (int i = 0; i < points.length; i++) {
      int j = (i + 1) % points.length;
      area += points[i].longitude * points[j].latitude;
      area -= points[j].longitude * points[i].latitude;
    }

    area = area / 2.0;
    return area.abs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialZoom: 13.0,
                maxZoom: 22.0,
                minZoom: 1.0,
                initialCenter: LatLng(12.9716, 77.5946),

              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                if (widget.polygon.isNotEmpty)
                  PolygonLayer(
                    polygonCulling: false,
                    polygons: [
                      Polygon(
                        points: widget.polygon,
                        color: Colors.blue.withOpacity(0.5),
                        borderStrokeWidth: 2,
                        borderColor: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: widget.markers,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: $_address'),
                Text('District: $_district'),
                Text('State: $_state'),
                Text('Pincode: $_pincode'),
                Text('Country: $_country'),
                Text(
                    'Area: ${_calculatePolygonArea(_polygonPoints).toStringAsFixed(2)} sq units'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
