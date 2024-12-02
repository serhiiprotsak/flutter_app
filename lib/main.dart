import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'providers/connectivity_provider.dart';  // Імпортуємо провайдер
import 'app_colors.dart'; 


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConnectivityProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tour agency',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 201, 123, 22),
          colorScheme: const ColorScheme.light(
            primary: Color.fromARGB(255, 238, 163, 0),
            secondary: AppColors.secondaryColor,
          ),
          scaffoldBackgroundColor: AppColors.backgroundColor,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: AppColors.textColor),
            bodyMedium: TextStyle(color: AppColors.textColor),
            displayLarge: TextStyle(color: AppColors.textColor),
            displayMedium: TextStyle(color: AppColors.textColor),
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
