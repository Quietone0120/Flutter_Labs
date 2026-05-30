import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class AppData extends InheritedWidget {
  final GameController controller;

  const AppData({Key? key, required this.controller, required Widget child})
    : super(key: key, child: child);

  static AppData of(BuildContext context) {
    final AppData? result = context
        .dependOnInheritedWidgetOfExactType<AppData>();
    assert(result != null, 'No AppData found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant AppData oldWidget) {
    return controller != oldWidget.controller;
  }
}
