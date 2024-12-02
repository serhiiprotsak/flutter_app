import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<String> items = [
    'Елемент 1',
    'Елемент 2',
    'Елемент 3',
    'Елемент 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Головна сторінка'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            leading: Icon(Icons.star),
            onTap: () {
            },
          );
        },
      ),
    );
  }
}
