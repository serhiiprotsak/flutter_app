import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20, // Розмір шрифту
          fontWeight: FontWeight.bold, // Жирний шрифт
        ),
      ),
      centerTitle: true, // Центрування заголовка
      backgroundColor: Colors.teal.shade700, // Колір фону
      elevation: 4, // Тінь
    );
  }
}
