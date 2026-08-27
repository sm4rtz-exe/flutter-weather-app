import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    String cityName = "Bangkok";
    try {
      final apikey = dotenv.env['WEATHER_API'] ?? '';
      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apikey",
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != "200") {
        throw data['message'];
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

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
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final location = data['city']['name'];
          final currentWeather = data['list'][0]['weather'][0]['main'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main card
                  Text(
                    location,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$currentTemp K",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  currentWeather == 'Clouds' ||
                                          currentWeather == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                Text(
                                  currentWeather,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForecastItem(
                          time: DateTime.parse("2026-08-26 14:00:00"),
                          icon: Icons.sunny,
                          temp: "30°C",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Additional Information",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: "Humidity",
                        value: 67,
                      ),
                      AdditionalInfoItem(
                        icon: Icons.wind_power,
                        label: "Wind Speed",
                        value: 41,
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: "Pressure",
                        value: 10000,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
