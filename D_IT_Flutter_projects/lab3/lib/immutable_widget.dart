import 'package:flutter/material.dart';
import 'dart:math' as Math;

class ImmutableWidget extends StatelessWidget {
  const ImmutableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // хүү widget-н арын дэвсгэрийн чимэглэл
      decoration: const BoxDecoration(color: Colors.green),
      // хүү widget-н урд талын чимэглэл
      foregroundDecoration: const BoxDecoration(
        backgroundBlendMode: BlendMode.colorBurn,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xAA0d6123), Color(0x00000000), Color(0xAA0d6123)],
        ),
      ),
      child: Center(
        child: Transform.rotate(
          // Хүү widget-г төвийг тойруулан эргүүлэх өнцгийн хэмжээ radian утгаар
          angle: Math.pi / 4,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.purple,
              boxShadow: [
                BoxShadow(
                  // Alpha channel: Өнгөний тунгалагшилийн (transparency or opacity) хэмжээ /0-255/
                  color: Colors.deepPurple.withAlpha(120),
                  // Тархалтын radius
                  spreadRadius: 4,
                  // Бүдгэрүүлэх radius
                  blurRadius: 15,
                  // direction: х тэнхлэгийн эерэг чиглэлтэй үүсгэж буй өнцгийн radian хэмжээ
                  // distance: тухайн чиглэлд сүүдэр үүсгэх зайн хэмжээ
                  offset: Offset.fromDirection(1.0, 30),
                ),
              ],
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: _buildShinyCircle(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShinyCircle() {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.lightBlueAccent, Colors.blueAccent],
          // Градиент үүсгэх тойргийн радиусын утгыг бутархайгаар илэрхийлсэн утга.
          // 0.5 градиент үүсгэх дүрсийн богино талын хагастай тэнцүү радиуст үүсгэнэ.
          radius: 0.5,
          // x: төвөөс зүүн, баруун тийш зэрэгцүүлнэ. Авах утга [-1, 1] -1->зүүн ирмэгт, 0->төвд, 1->баруун ирмэгт
          // y: төвөөс дээш, доош зэрэгцүүлнэ. Авах утга [-1, 1] -1->дээд ирмэгт, 0->төвд, 1->доод ирмэгт
          center: Alignment(-0.3, -0.5),
        ),
        boxShadow: [
          // Бүдгэрүүлэх radius
          BoxShadow(blurRadius: 20),
        ],
      ),
    );
  }
}
