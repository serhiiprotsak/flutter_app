import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userName;
  final String email;

  const ProfileScreen({
    Key? key,
    required this.userName,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ім\'я:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(userName, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              'Email:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(email, style: TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Логіка для видалення акаунта
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Видалити акаунт?'),
                      content: const Text('Ця дія не може бути скасована.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), // Скасувати
                          child: const Text('Скасувати'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Тут може бути логіка видалення акаунта
                            Navigator.pop(context); // Закриваємо діалог
                            Navigator.pop(context); // Повертаємо на попередній екран
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Акаунт видалено!')),
                            );
                          },
                          child: const Text('Видалити'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Видалити акаунт'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
