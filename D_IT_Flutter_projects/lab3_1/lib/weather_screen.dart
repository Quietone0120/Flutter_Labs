import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar + Drawer-тай Scaffold
      appBar: AppBar(
        title: const Text('Weather'),
        backgroundColor: const Color.fromARGB(255, 66, 62, 62),
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Color.fromARGB(255, 18, 29, 59)),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(title: Text('Home')),
            ListTile(title: Text('Settings')),
            ListTile(title: Text('About')),
          ],
        ),
      ),

      // Гол body хэсэг
      body: Container(
        // Нартай үед тохиромжтой шар-улбар шар gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 128, 126, 121), // шар
              Color.fromARGB(255, 24, 30, 103), // улбар шар
              Color.fromARGB(255, 53, 10, 119), // бага зэрэг ягаан улбар
            ],
          ),
        ),

        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Үндсэн weather card
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        71,
                        87,
                        9,
                      ).withOpacity(0.3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // хотын нэр + цаг
                      const Text(
                        'Эрдэнэт хот',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Мяг 12:00',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),

                      const SizedBox(height: 20),

                      // Том температур
                      const Text(
                        '30°',
                        style: TextStyle(
                          fontSize: 88,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 0.9,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ClipOval(
                        child: Image.asset(
                          'assets/12_tenor.webp',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Sunny гэсэн текст
                      const Text(
                        'Бороотой',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Салхи
                      const Text(
                        'Салхитай: 10 км/ц',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Доод товчлуурууд (Tomorrow & Week)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBottomButton('Маргааш →'),
                    const SizedBox(width: 24),
                    _buildBottomButton('Долоо хоногт →'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
