import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class RegistrationScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final Function(Map<String, String>) onUserRegistered;

  RegistrationScreen({required this.onUserRegistered});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            CustomTextField(
              labelText: 'Confirm Password',
              obscureText: true,
              controller: confirmPasswordController,
            ),
            CustomButton(
              text: 'Register',
              onPressed: () async {
                if (_validateRegistration(context)) {
                  // Зберігаємо нового користувача
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('email', emailController.text);
                  await prefs.setString('password', passwordController.text);
                  
                  // Викликаємо callback для реєстрації
                  onUserRegistered({
                    'email': emailController.text,
                    'password': passwordController.text,
                  });
                  Navigator.pop(context); // Повертаємося до екрану логіну
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _validateRegistration(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (email.isEmpty) {
      _showErrorDialog(context, 'Введіть електронну пошту');
      return false;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showErrorDialog(context, 'Неправильний формат електронної пошти');
      return false;
    }
    if (password.isEmpty) {
      _showErrorDialog(context, 'Введіть пароль');
      return false;
    }
    if (password.length < 6) {
      _showErrorDialog(context, 'Пароль повинен містити принаймні 6 символів');
      return false;
    }
    if (confirmPassword.isEmpty) {
      _showErrorDialog(context, 'Підтвердіть пароль');
      return false;
    }
    if (confirmPassword != password) {
      _showErrorDialog(context, 'Паролі не співпадають');
      return false;
    }
    return true;
  }

  void _showErrorDialog(BuildContext context, String message) {
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
}
