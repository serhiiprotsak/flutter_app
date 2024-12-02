import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_colors.dart'; 

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _avatarUrl = '';  // Для збереження шляху до аватарки

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Завантаження даних з SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _emailController.text = prefs.getString('email') ?? '';
    _nameController.text = prefs.getString('name') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
    _avatarUrl = prefs.getString('avatarUrl') ?? ''; // Завантаження аватарки

    setState(() {});
  }

  // Збереження даних користувача в SharedPreferences
  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('name', _nameController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('avatarUrl', _avatarUrl); // Збереження аватарки

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );
  }

  // Вибір аватарки за замовчуванням
  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 50,  // Розмір аватарки
      backgroundImage: _avatarUrl.isNotEmpty
          ? NetworkImage(_avatarUrl) // Якщо є URL аватарки, то показуємо зображення
          : null,
      child: _avatarUrl.isEmpty
          ? Icon(Icons.person, size: 50, color: AppColors.whiteColor) // Якщо аватарки немає, показуємо іконку
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 40, 54, 53), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Відображення аватарки
            _buildAvatar(),
            SizedBox(height: 20),
            // Форма для зміни даних користувача
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
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
              onPressed: _saveUserData,
              child: Text('Save Changes', style: TextStyle(color: AppColors.whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 42, 66, 63),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}
