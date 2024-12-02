import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/local_storage_service.dart';
import '../app_colors.dart';
import 'registration_screen.dart';
import 'categories_screen.dart';
import '../providers/connectivity_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
    
    // Перевірка підключення
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
    // Перевірка на наявність діалогів, щоб не відображати кілька одночасно
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
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
    final userData = await _localStorageService.getUserData();

    if (userData != null &&
        userData['email'] == email &&
        userData['password'] == password) {
      _showNotificationDialog('Login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoriesScreen()),
      );
    } else {
      _showNotificationDialog('Invalid email or password');
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('email');
              await prefs.remove('password');
              await prefs.remove('name');

              Navigator.of(context).pop();
              // Додатково можете зробити повернення до екрану входу
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text('Logout'),
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
        title: const Text('Login', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 233, 148, 20),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
            child: const Text('Register', style: TextStyle(color: AppColors.whiteColor)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
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
