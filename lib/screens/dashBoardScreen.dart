import 'package:flutter/material.dart';
import 'map_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Property Dashboard',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blueAccent,
          elevation: 4.0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 300.0, // Adjust height as needed
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://media.licdn.com/dms/image/C4D03AQEcE6RdMAfM8g/profile-displayphoto-shrink_200_200/0/1638772363266?e=2147483647&v=beta&t=wAynhrkBkNCVnHEzoVbJP_pBSBsQY8gkyPFc8kRjgBs'),
                      // Replace with your image URL
                      fit: BoxFit.contain,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.3),
                        blurRadius: 6.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                'Welcome to Your Property Dashboard',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),

              // Add Property Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                icon: const Icon(
                  Icons.add_location_alt,
                  color: Colors.white,
                ),
                label: const Text(
                  'Add Property',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              const SizedBox(height: 20.0),

              // Information Card (Placeholder for Property Stats)
              Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Property Statistics',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.house, color: Colors.blueAccent),
                          const SizedBox(width: 10.0),
                          Text(
                            'Total Properties: 10',
                            // Placeholder for actual count
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          Icon(Icons.monetization_on, color: Colors.green),
                          const SizedBox(width: 10.0),
                          Text(
                            'Total Value: \$1,000,000',
                            // Placeholder for actual value
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
