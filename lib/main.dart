import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';  // Додайте цей імпорт

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Agency App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Встановлюємо стартовий маршрут
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(), // Додаємо маршрут для HomeScreen
        // Додавайте інші маршрути тут
      },
    );
  }
}
