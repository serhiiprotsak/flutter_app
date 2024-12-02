import 'dart:convert';
import 'package:flutter/material.dart';
import 'profile_screen.dart'; 
import '../app_colors.dart'; 
import '../services/local_storage_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

// Модель для туру
class Tour {
  final String title;
  final String description;
  final String imageUrl;

  Tour({required this.title, required this.description, required this.imageUrl});

  // Перетворення об'єкта Tour в JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  // Статичний метод для створення об'єкта Tour з JSON
  static Tour fromJson(Map<String, dynamic> json) {
    return Tour(
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  final LocalStorageService _localStorageService = LocalStorageServiceImpl();

  // Завантаження турів із API
  Future<List<Tour>> fetchTours() async {
    try {
      final response = await http.get(Uri.parse('https://run.mocky.io/v3/38a3479b-8f91-4af3-97a0-761658fb737a'));

      if (response.statusCode == 200) {
        // Перетворюємо JSON у список турів
        List<dynamic> data = json.decode(response.body);
        
        // Ensure we parse each tour item properly
        return data.map((tourJson) => Tour.fromJson(tourJson)).toList();
      } else {
        throw Exception('Failed to load tours');
      }
    } catch (e) {
      print('Error fetching tours: $e');
      rethrow; // Re-throw the error so it can be handled in the FutureBuilder
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _localStorageService.saveUserData('', '', '');
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
            child: Text('Log out'),
          ),
        ],
      ),
    );
  }

  void _listenToConnectivity(BuildContext context) {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are offline. Some features may be limited.')),
        );
      }
    });
  }

  // Перехід до екрану з деталями туру
  void _viewTourDetails(BuildContext context, Tour tour) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TourDetailsScreen(tour: tour),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listenToConnectivity(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Agency', style: TextStyle(color: AppColors.whiteColor)), 
        backgroundColor: const Color.fromARGB(255, 44, 63, 57), 
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.whiteColor), 
            onPressed: () => _showLogoutDialog(context), 
          ),
        ],
      ),
      body: FutureBuilder<List<Tour>>(
        future: fetchTours(),  // Завантажуємо тури через API
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tours available.'));
          } else {
            List<Tour> tours = snapshot.data!;
            return ListView.builder(
              itemCount: tours.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tours[index].title),
                  leading: Image.network(tours[index].imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                  subtitle: Text(tours[index].description),
                  onTap: () => _viewTourDetails(context, tours[index]),  // Перехід до екрану детального перегляду туру
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        },
        child: Icon(Icons.person), 
        tooltip: 'Go to Profile',
      ),
    );
  }
}

// Екран деталей туру
class TourDetailsScreen extends StatelessWidget {
  final Tour tour;

  TourDetailsScreen({required this.tour});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour.title, style: TextStyle(color: AppColors.whiteColor)),
        backgroundColor: const Color.fromARGB(255, 50, 71, 66),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(tour.imageUrl),  // Зображення туру
            SizedBox(height: 16),
            Text(
              tour.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              tour.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Тут буде логіка для бронювання
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You have successfully booked the tour!')),
                );
              },
              child: Text('Book this Tour', style: TextStyle(color: AppColors.whiteColor)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(94, 46, 73, 75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
