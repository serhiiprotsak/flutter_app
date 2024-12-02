import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal, // Основний колір кнопки
        foregroundColor: Colors.white, // Колір тексту
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Внутрішні відступи
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Заокруглені кути
        ),
        elevation: 5, // Тінь
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16, // Розмір шрифту
          fontWeight: FontWeight.bold, // Жирний текст
        ),
      ),
    );
  }
}
