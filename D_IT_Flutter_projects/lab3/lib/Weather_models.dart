// weather_models.dart
// WeatherData болон WeatherType-г тусдаа файлд гаргаж,
// main.dart болон weather_screen.dart хоёулаа import хийнэ.

import 'package:flutter/material.dart';

enum WeatherType { sunny, rainy, cloudy, snowy }

class WeatherData {
  final String city;
  final String time;
  final int temperature;
  final String condition;
  final int windSpeed;
  final WeatherType weatherType;
  final List<Color> gradientColors;

  WeatherData({
    required this.city,
    required this.time,
    required this.temperature,
    required this.condition,
    required this.windSpeed,
    required this.weatherType,
    required this.gradientColors,
  });
}
