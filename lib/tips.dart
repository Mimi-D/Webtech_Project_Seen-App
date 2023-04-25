import 'dart:convert';
import 'package:finalproj/profile.dart';
import 'package:finalproj/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'login.dart';

class Tips extends StatefulWidget {
  const Tips({super.key});

  @override
  TipsState createState() => TipsState();
}

class TipsState extends State<Tips> {
  List<String> tips = []; //to store tips retrieved from the database
  int _currentIndex = 0;

  // set up the initial state of the widget
  @override
  void initState() {
    super.initState();
    _fetchTips(); //executes _fetchTips method to retrieve tips.
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight / 3;
    User? user = Provider.of<UserState>(context).getUser(); //retrieve user info
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seen',
            style: TextStyle(fontFamily: 'Pacifico', fontSize: 30)),
        centerTitle: true,
        backgroundColor: Colors.purple[600],
        leading: SizedBox(
            height: kToolbarHeight,
            child: Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      // Make a GET request to retrieve the user's information
                      final response = await http.get(Uri.parse('https://abiding-truth-382722.wl.r.appspot.com/user/${user!.studentId}'),headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"});
                      if (response.statusCode == 200) {
                        final userData = jsonDecode(response.body);

                        // Construct the Profile widget with the retrieved information
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(
                              profilePicUrl: 'assets/${user.spiritAnimal.toLowerCase()}.jpg',
                              studentId: userData['student_id'],
                              name: userData['full_name'],
                              email: userData['email'],
                              spiritAnimal: userData['spirit_animal'],
                              dateOfBirth: userData['dob'],
                              yearGroup: userData['year_group'],
                              major: userData['major'],
                              hasCampusResidence: userData['residence_status'],
                              bestFood: userData['best_food'],
                              bestMovie: userData['best_movie'],
                            ),
                          ),
                        );
                      }
                      else {
                        // Handle the case where the GET request failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to retrieve user information'),
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/${user!.spiritAnimal.toLowerCase()}.jpg'),
                      radius: 20.0,
                    ),
                  ),
                ),
              ],
            )
        ),

        actions: [
          Row(
            children: [
              IconButton( //to logout
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
              const Text('Logout'),
            ],
          ),
        ],
      ),
      drawer: const MyDrawer(), //side nav bar
      body: Stack(
        children: [Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/calm.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: cardHeight,
                  child: Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 100.0, 40.0, 40.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tips.isNotEmpty ? tips[_currentIndex % tips.length] : 'Loading tips...',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'Alkatra', fontSize: 14),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex++; //change to the next tip
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Next'),
                ),
              ],
            ),
          ),
        ),
          const Positioned(
            bottom: 80,
            right: 40,
            child: AddButton(), // Button to add a new post
          ),
        ],
      )
    );
  }

  // Function to retrieve health tips from the database
  Future<void> _fetchTips() async {
    final response = await http.get(Uri.parse('https://abiding-truth-382722.wl.r.appspot.com/tip'));
    if (response.statusCode == 200) {
      final List<dynamic> tipsData = json.decode(response.body);
      final List tips = tipsData.map((tipData) => tipData['tip']).toList();
      setState(() {
        this.tips = tips.cast<String>();
      });
    } else {
      throw Exception('Failed to fetch health tips from API');
    }
  }
}
