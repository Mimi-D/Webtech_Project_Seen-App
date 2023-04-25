import 'package:flutter/material.dart';
import 'drawer.dart';
import 'login.dart';

//Profile entity
class Profile extends StatelessWidget {
  final String profilePicUrl;
  final String studentId;
  final String name;
  final String email;
  final String dateOfBirth;
  final String yearGroup;
  final String major;
  final String hasCampusResidence;
  final String bestFood;
  final String bestMovie;
  final String spiritAnimal;

  const Profile({
    Key? key,
    required this.profilePicUrl,
    required this.studentId,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.yearGroup,
    required this.major,
    required this.hasCampusResidence,
    required this.bestFood,
    required this.bestMovie,
    required this.spiritAnimal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seen',
          style: TextStyle(fontFamily: 'Pacifico', fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go to previous page
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              //logout
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(profilePicUrl),
                radius: 90,
              ),
              const SizedBox(height: 20),
              Text(
                'Student ID: $studentId',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Name: $name',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Email: $email',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Date of Birth: $dateOfBirth',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Year Group: $yearGroup',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Major: $major',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Campus Residence: $hasCampusResidence',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Best Food: $bestFood',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Best Movie: $bestMovie',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Spirit Animal: $spiritAnimal',
                style: const TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
            ],
          ),
        ),
          const Positioned(
            bottom: 80,
            right: 40,
            child: AddButton(),
          ),],
      )
    );
  }
}
