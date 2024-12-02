import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller; // Додано контролер для управління текстом

  CustomTextField({required this.labelText, this.obscureText = false, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller, // Призначення контролера
        obscureText: obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Заокруглені кути
            borderSide: BorderSide(
              color: Colors.teal, // Колір країв
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.teal, // Колір тексту підпису
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal.shade700), // Колір при фокусі
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal), // Колір при активному стані
          ),
        ),
      ),
    );
  }
}
