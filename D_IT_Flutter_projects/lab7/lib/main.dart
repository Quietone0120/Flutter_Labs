import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _selectedCity = 'Ulaanbaatar';
  late final AudioPlayer _audioPlayer; // rebuild-д дахин үүсэхгүй

  final Map<String, Map<String, double>> _cityCoords = {
    'Ulaanbaatar': {'lat': 47.92, 'lon': 106.92},
    'Erdenet': {'lat': 49.03, 'lon': 104.09},
    'Darkhan': {'lat': 49.50, 'lon': 105.92},
    'Dalanzadgad': {'lat': 43.57, 'lon': 104.43},
    'Choibalsan': {'lat': 48.08, 'lon': 114.52},
    'Khovd': {'lat': 48.02, 'lon': 91.64},
  };

  final Map<String, String> _cityBackgrounds = {
    'Ulaanbaatar': 'assets/ulaanbaatar.png',
    'Erdenet': 'assets/erdenet.png',
    'Darkhan': 'assets/darkhan.jpg',
    'Dalanzadgad': 'assets/dalanzadgad.jpg',
    'Choibalsan': 'assets/choibalsan.png',
    'Khovd': 'assets/khovd.jpg',
  };

  @override
  void initState() {
    super.initState();
    
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.setVolume(1.0);
    _audioPlayer.play(AssetSource('s1.mp3')); // фон дуу
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final coords = _cityCoords[city]!;
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${coords['lat']}&longitude=${coords['lon']}&current_weather=true',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['current_weather'];
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }

  IconData _getWeatherIcon(double temp, double wind) {
    if (temp > 25) return WeatherIcons.day_sunny;
    if (temp > 15) return WeatherIcons.day_cloudy;
    if (temp > 0) return WeatherIcons.cloud;
    return WeatherIcons.snow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedCity = value;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Ulaanbaatar', child: Text('Улаанбаатар')),
              PopupMenuItem(value: 'Erdenet', child: Text('Эрдэнэт')),
              PopupMenuItem(value: 'Darkhan', child: Text('Дархан')),
              PopupMenuItem(value: 'Dalanzadgad', child: Text('Даланзадгад')),
              PopupMenuItem(value: 'Choibalsan', child: Text('Чойбалсан')),
              PopupMenuItem(value: 'Khovd', child: Text('Ховд')),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              _cityBackgrounds[_selectedCity]!,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchWeatherData(_selectedCity),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                if (snapshot.hasError) {
                  return Card(
                    color: Colors.blue.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Алдаа: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final temp = data['temperature'];
                  final wind = data['windspeed'];
                  final obsTime = DateTime.parse(data['time']);
                  final formattedTime = DateFormat.E().add_Hm().format(obsTime);
                  final icon = _getWeatherIcon(temp, wind);

                  return Card(
                    color: Colors.blue.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 40.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCity,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Шинэчлэгдсэн: $formattedTime',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Icon(icon, size: 80, color: Colors.white),
                          const SizedBox(height: 20),
                          Text(
                            'Температур: $temp °C',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Салхи: $wind км/цаг',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
