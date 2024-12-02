import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../app_colors.dart'; 

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {

      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String name = _nameController.text;

    
      await _localStorageService.saveUserData(email, password, name);


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyle(color: AppColors.whiteColor)), 
        backgroundColor: const Color.fromARGB(255, 57, 74, 228), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Enter correct email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  if (value.length < 8) {
                    return 'Passwort must be at least 8 letters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: Text('Register', style: TextStyle(color: AppColors.whiteColor)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 60, 87, 78), 
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.backgroundColor, 
    );
  }
}
