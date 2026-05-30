// weather_screen.dart
// АНХААР: WeatherData болон WeatherType энд ТОДОРХОЙЛОГДООГҮЙ.
// Тэдгээр нь weather_models.dart-д байгаа бөгөөд доорх import-оор ашиглана.

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'weather_models.dart';

class WeatherScreen extends StatefulWidget {
  final List<WeatherData> weatherCards;
  final int selectedIndex;
  final Function(int) onCardSelected;

  const WeatherScreen({
    super.key,
    required this.weatherCards,
    required this.selectedIndex,
    required this.onCardSelected,
  });

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _rainController;
  late AnimationController _snowController;
  late AnimationController _cloudController;

  @override
  void initState() {
    super.initState();
    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _rainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _snowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sunController.dispose();
    _rainController.dispose();
    _snowController.dispose();
    _cloudController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.58,
              ),
              itemCount: widget.weatherCards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => widget.onCardSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    transform: widget.selectedIndex == index
                        ? (Matrix4.identity()..scale(1.03))
                        : Matrix4.identity(),
                    child: _WeatherCard(
                      data: widget.weatherCards[index],
                      isSelected: widget.selectedIndex == index,
                      sunController: _sunController,
                      rainController: _rainController,
                      snowController: _snowController,
                      cloudController: _cloudController,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _DetailCard(data: widget.weatherCards[widget.selectedIndex]),
          ],
        ),
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final WeatherData data;
  final bool isSelected;
  final AnimationController sunController;
  final AnimationController rainController;
  final AnimationController snowController;
  final AnimationController cloudController;

  const _WeatherCard({
    required this.data,
    required this.isSelected,
    required this.sunController,
    required this.rainController,
    required this.snowController,
    required this.cloudController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradientColors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: data.gradientColors[1].withOpacity(isSelected ? 0.6 : 0.35),
            blurRadius: isSelected ? 24 : 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  data.city,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.temperature}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                    height: 1,
                  ),
                ),
                const Text(
                  '\u00B0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 90, child: _buildWeatherIcon()),
            Column(
              children: [
                Text(
                  data.condition,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Wind: ${data.windSpeed} km/h',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _CardButton(label: 'Tomorrow'),
                const SizedBox(height: 8),
                _CardButton(label: 'Week'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon() {
    switch (data.weatherType) {
      case WeatherType.sunny:
        return _SunIcon(controller: sunController);
      case WeatherType.rainy:
        return _RainyIcon(controller: rainController);
      case WeatherType.cloudy:
        return _CloudyNightIcon(controller: cloudController);
      case WeatherType.snowy:
        return _SnowyIcon(controller: snowController);
    }
  }
}

class _CardButton extends StatelessWidget {
  final String label;
  const _CardButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}

class _SunIcon extends StatelessWidget {
  final AnimationController controller;
  const _SunIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: controller.value * 2 * math.pi,
              child: CustomPaint(
                size: const Size(72, 72),
                painter: _SunRayPainter(),
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB300).withOpacity(0.6),
                    blurRadius: 16,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SunRayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi) / 8;
      canvas.drawLine(
        Offset(
          center.dx + 24 * math.cos(angle),
          center.dy + 24 * math.sin(angle),
        ),
        Offset(
          center.dx + 36 * math.cos(angle),
          center.dy + 36 * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RainyIcon extends StatelessWidget {
  final AnimationController controller;
  const _RainyIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: _CloudShape(width: 75, height: 45, color: Colors.white),
            ),
            ...List.generate(3, (i) {
              final offset = (controller.value + i * 0.33) % 1.0;
              return Positioned(
                top: 45 + offset * 35,
                left: 18.0 + i * 20,
                child: Opacity(
                  opacity: offset < 0.8 ? 1.0 : (1.0 - offset) / 0.2,
                  child: Container(
                    width: 4,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class _CloudyNightIcon extends StatelessWidget {
  final AnimationController controller;
  const _CloudyNightIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final float = math.sin(controller.value * math.pi) * 4;
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(left: 4, top: 8 + float * 0.3, child: _MoonShape()),
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.translate(
                offset: Offset(0, float),
                child: _CloudShape(width: 65, height: 40, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SnowyIcon extends StatelessWidget {
  final AnimationController controller;
  const _SnowyIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final float = math.sin(controller.value * math.pi * 2) * 3;
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: _CloudShape(
                width: 72,
                height: 42,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD54F),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ...List.generate(2, (i) {
              return Positioned(
                top: 50 + float * (i % 2 == 0 ? 1 : -1),
                left: 14.0 + i * 32,
                child: _Snowflake(size: i == 0 ? 18 : 14),
              );
            }),
          ],
        );
      },
    );
  }
}

class _Snowflake extends StatelessWidget {
  final double size;
  const _Snowflake({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SnowflakePainter()),
    );
  }
}

class _SnowflakePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MoonShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(painter: _MoonPainter()),
    );
  }
}

class _MoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.5),
        radius: size.width * 0.45,
      ),
      Paint()
        ..color = const Color(0xFFFFE082)
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.68, size.height * 0.4),
        radius: size.width * 0.38,
      ),
      Paint()
        ..color = const Color(0xFF3949AB)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CloudShape extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  const _CloudShape({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _CloudPainter(color: color)),
    );
  }
}

class _CloudPainter extends CustomPainter {
  final Color color;
  const _CloudPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, h * 0.45, w, h * 0.55),
          const Radius.circular(10),
        ),
      )
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.25, h * 0.5), radius: h * 0.28),
      )
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.5, h * 0.32), radius: h * 0.36),
      )
      ..addOval(
        Rect.fromCircle(center: Offset(w * 0.72, h * 0.45), radius: h * 0.28),
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DetailCard extends StatelessWidget {
  final WeatherData data;
  const _DetailCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradientColors,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: data.gradientColors[1].withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Currently Selected',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${data.city} \u2014 ${data.condition}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${data.temperature}\u00B0',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DetailStat(
                icon: Icons.air,
                label: 'Wind',
                value: '${data.windSpeed} km/h',
              ),
              _DetailStat(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: '65%',
              ),
              _DetailStat(
                icon: Icons.visibility_outlined,
                label: 'Visibility',
                value: '10 km',
              ),
              _DetailStat(
                icon: Icons.thermostat,
                label: 'Feels Like',
                value: '${data.temperature - 2}\u00B0',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10),
        ),
      ],
    );
  }
}
