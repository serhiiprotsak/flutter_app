import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'app_colors.dart'; // Import your custom colors

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Store',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.textColor),
          bodyMedium: TextStyle(color: AppColors.textColor),
          displayLarge: TextStyle(color: AppColors.textColor),
          displayMedium: TextStyle(color: AppColors.textColor),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
