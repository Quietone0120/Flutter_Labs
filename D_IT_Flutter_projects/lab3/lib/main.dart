import 'package:flutter/material.dart';
import 'weather_models.dart';
import 'weather_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4FC3F7),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  int _selectedIndex = 0;

  final List<WeatherData> _weatherCards = [
    WeatherData(
      city: 'London',
      time: 'Mon 12:00',
      temperature: 30,
      condition: 'Sunny',
      windSpeed: 2,
      weatherType: WeatherType.sunny,
      gradientColors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
    ),
    WeatherData(
      city: 'London',
      time: 'Mon 15:15',
      temperature: 8,
      condition: 'Rainy',
      windSpeed: 4,
      weatherType: WeatherType.rainy,
      gradientColors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
    ),
    WeatherData(
      city: 'London',
      time: 'Mon 23:10',
      temperature: 12,
      condition: 'Cloudy',
      windSpeed: 1,
      weatherType: WeatherType.cloudy,
      gradientColors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
    ),
    WeatherData(
      city: 'London',
      time: 'Mon 18:45',
      temperature: -2,
      condition: 'Snowy',
      windSpeed: 3,
      weatherType: WeatherType.snowy,
      gradientColors: [Color(0xFF80DEEA), Color(0xFF26C6DA)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'WEATHER',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w300,
                letterSpacing: 6,
                color: Color(0xFF5C6BC0),
              ),
            ),
            Text(
              'FORECAST APP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                letterSpacing: 4,
                color: Color(0xFF90A4AE),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF5C6BC0)),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF5C6BC0),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildDrawer(context),
      body: WeatherScreen(
        weatherCards: _weatherCards,
        selectedIndex: _selectedIndex,
        onCardSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF5C6BC0), Color(0xFF3949AB)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Weather App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Your personal weather guide',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.home_rounded, 'Home', true, context),
          _drawerItem(
            Icons.location_on_outlined,
            'My Locations',
            false,
            context,
          ),
          _drawerItem(
            Icons.calendar_today_outlined,
            'Weekly Forecast',
            false,
            context,
          ),
          _drawerItem(Icons.bar_chart_rounded, 'Weather Stats', false, context),
          _drawerItem(Icons.map_outlined, 'Weather Map', false, context),
          const Divider(color: Color(0xFFEEEEEE)),
          _drawerItem(
            Icons.notifications_outlined,
            'Notifications',
            false,
            context,
          ),
          _drawerItem(Icons.settings_outlined, 'Settings', false, context),
          _drawerItem(
            Icons.help_outline_rounded,
            'Help & Support',
            false,
            context,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    IconData icon,
    String title,
    bool isActive,
    BuildContext context,
  ) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF5C6BC0).withOpacity(0.1)
              : Colors.grey.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF5C6BC0) : const Color(0xFF90A4AE),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? const Color(0xFF5C6BC0) : const Color(0xFF546E7A),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
      trailing: isActive
          ? Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF5C6BC0),
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Search City'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter city name...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C6BC0),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
