import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'theme.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lab 2',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          background: const Color.fromARGB(255, 186, 185, 185),
          onPrimary: AppColors.whiteColor,
          onSecondary: AppColors.textColor,
        ),
        scaffoldBackgroundColor: AppColors.backgroundColor,
        textTheme: TextTheme(
          displayLarge: TextStyle(color: AppColors.textColor, fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: AppColors.textColor, fontSize: 16),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.primaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.primaryColor,
          titleTextStyle: TextStyle(color: AppColors.whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
