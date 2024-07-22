import 'package:latlong2/latlong.dart';

class Property {
  final List<LatLng> polygonPoints;
  final String address;
  final String district;
  final String state;
  final String pincode;
  final String country;

  Property({
    required this.polygonPoints,
    required this.address,
    required this.district,
    required this.state,
    required this.pincode,
    required this.country,
  });
}
