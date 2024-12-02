import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON parsing
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/local_storage_service.dart';
import '../app_colors.dart';
import 'registration_screen.dart';
import 'categories_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();


  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    final userData = await _localStorageService.getUserData();

    if (userData != null && await _isConnected()) {
      _showNotificationDialog('Auto-login succeeded.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()),
      );
    } else if (userData != null) {
      _showNotificationDialog('Please connect to the network for auto-login.');
    }
  }

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void _showNotificationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (!await _isConnected()) {
      _showNotificationDialog('No internet connection. Please try again.');
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    final response = await _authenticateUser(email, password);

    if (response != null && response['status'] == 'success') {
      _showNotificationDialog('Login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()),
      );
    } else {
      _showNotificationDialog('Invalid email or password');
    }
  }

  Future<Map<String, dynamic>?> _authenticateUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://run.mocky.io/v3/c5da4b48-7efd-43f5-b185-14febf6bd841'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check if the response contains the user data
        for (var user in data['users']) {
          if (user['email'] == email && user['password'] == password) {
            return {
              'status': 'success',
              'user': user,
            };
          }
        }
        // If no user matched
        return {
          'status': 'failure',
          'message': 'Invalid email or password',
        };
      } else {
        return null; // Server error
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');
              await prefs.remove('name');

              Navigator.of(context).pop();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );

    _checkConnection();
    _autoLogin();
  }

  // Перевірка з'єднання з Інтернетом
  Future<void> _checkConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  // Перевірка автологіну
  Future<void> _autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    final int? lastLoginTime = prefs.getInt('lastLoginTime'); // Час останнього входу

    if (email != null && password != null && _isConnected) {
      // Перевірка часу актуальності даних
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final duration = currentTime - (lastLoginTime ?? 0);
      final isDataFresh = duration < Duration(hours: 1).inMilliseconds; // Пропонуємо актуальність даних протягом 1 години

      if (isDataFresh) {
        // Якщо дані актуальні, перехід до головного екрану
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Якщо дані застарілі
        _showErrorDialog('Час авторизації сплив, будь ласка, увійдіть заново.');
      }
    } else if (email != null && password != null && !_isConnected) {
      // Якщо є збережений користувач, але немає підключення
      _showNetworkDialog();
    }
  }

  // Модальне вікно для відсутності підключення
  void _showNetworkDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Підключення до мережі'),
          content: Text('Будь ласка, підключіться до Інтернету для повноцінної роботи додатку.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Помилка при введенні даних
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Помилка'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('ОК'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Логіка для логіну користувача
  void _loginUser() async {
    if (_validateLogin()) {
      // Логіка для входу
      final email = emailController.text;
      final password = passwordController.text;

      if (_isConnected) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        
        // Перевірка, чи дані збережені
        String? storedEmail = prefs.getString('email');
        String? storedPassword = prefs.getString('password');

        if (storedEmail == email && storedPassword == password) {
          // Збереження часу входу
          await prefs.setInt('lastLoginTime', DateTime.now().millisecondsSinceEpoch);

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorDialog('Невірний логін або пароль');
        }
      } else {
        _showNetworkDialog();
      }
    }
  }

  bool _validateLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty) {
      _showErrorDialog('Введіть електронну пошту');
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showErrorDialog('Неправильний формат електронної пошти');
      return false;
    }
    if (password.isEmpty) {
      _showErrorDialog('Введіть пароль');
      return false;
    }
    if (password.length < 6) {
      _showErrorDialog('Пароль повинен містити принаймні 6 символів');
      return false;
    }
    return true;

  }

  @override
  Widget build(BuildContext context) {


    final connectivityProvider = Provider.of<ConnectivityProvider>(context);

    // Якщо відсутнє з'єднання, показуємо повідомлення
    if (!connectivityProvider.isConnected) {
      _showNotificationDialog('No internet connection. Please check your connection.');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color(0xFF134B4B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              child: Text('Register', style: TextStyle(color: const Color.fromARGB(255, 46, 77, 75))),
            ),
          ],
        ),
      ),
    );
  }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
                obscureText: false,
              ),
              CustomTextField(
                labelText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              CustomButton(
                text: 'Login',
                onPressed: _loginUser,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(
                        onUserRegistered: (userData) {
                          // Збереження даних користувача після реєстрації
                          _saveUserData(userData);
                        },
                      ),
                    ),
                  );
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Функція для збереження даних після реєстрації
  Future<void> _saveUserData(Map<String, String> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', userData['email']!);
    await prefs.setString('password', userData['password']!);
    // Збереження додаткових даних, якщо є
    await prefs.setString('name', userData['name']!);
    await prefs.setString('phone', userData['phone']!);
  }
}
