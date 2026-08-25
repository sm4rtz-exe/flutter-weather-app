import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print("refresh");
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //main card
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Temp",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Icon(Icons.cloud, size: 64),
                      Text("weather", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            //weather forecast card
            Placeholder(fallbackHeight: 150.00),
            SizedBox(height: 20),
            //additional information
            Placeholder(fallbackHeight: 150.00),
          ],
        ),
      ),
    );
  }
}
