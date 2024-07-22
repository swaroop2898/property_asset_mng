import 'package:flutter/material.dart';
import 'package:property_asset_mag/screens/dashBoardScreen.dart';

void main() {
  runApp(const PropertyManagementApp());
}

class PropertyManagementApp extends StatelessWidget {
  const PropertyManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Property Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DashboardScreen(),
    );
  }
}
