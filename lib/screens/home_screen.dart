import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> tours = [
    {
      'title': 'Відпочинок на Мальдівах',
      'description': '7 днів розкоші та пляжів',
      'image': 'https://example.com/maldives.jpg',
    },
    {
      'title': 'Екскурсія в Париж',
      'description': 'Тури вихідного дня',
      'image': 'https://example.com/paris.jpg',
    },
    {
      'title': 'Подорож в Карпати',
      'description': '3 дні серед гір',
      'image': 'https://example.com/carpati.jpg',
    },
    {
      'title': 'Сафарі в Кенії',
      'description': '10 днів серед дикої природи',
      'image': 'https://example.com/kenya.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Туристична агенція'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: tours.length,
            itemBuilder: (context, index) {
              final tour = tours[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    tour['image']!,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    tour['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(tour['description']!),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // Перехід до деталей туру
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TourDetailsScreen(tour: tour),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Перехід до екрану профілю користувача
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.account_circle),
            ),
          ),
        ],
      ),
    );
  }
}

class TourDetailsScreen extends StatelessWidget {
  final Map<String, String> tour;

  const TourDetailsScreen({Key? key, required this.tour}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tour['title']!),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              tour['image']!,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              tour['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tour['description']!,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Логіка бронювання
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Заброньовано!')),
                );
              },
              child: const Text('Забронювати'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Іван Петров';
  String userEmail = 'ivan.petrov@example.com';
  String userPhoto = 'https://example.com/user.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мій профіль'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userPhoto),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ім\'я: $userName',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $userEmail',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Перехід до редагування профілю
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      userName: userName,
                      userEmail: userEmail,
                      userPhoto: userPhoto,
                      onSave: (newName, newEmail, newPhoto) {
                        setState(() {
                          userName = newName;
                          userEmail = newEmail;
                          userPhoto = newPhoto;
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Редагувати профіль'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhoto;
  final Function(String, String, String) onSave;

  const EditProfileScreen({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userPhoto,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController photoController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    emailController = TextEditingController(text: widget.userEmail);
    photoController = TextEditingController(text: widget.userPhoto);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    photoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редагувати профіль'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ім\'я'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: photoController,
              decoration: const InputDecoration(labelText: 'Фото (URL)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  nameController.text,
                  emailController.text,
                  photoController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
