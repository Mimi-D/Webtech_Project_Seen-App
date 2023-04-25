import 'package:finalproj/profile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'login.dart';
import 'user.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  // Initialize the TextEditingController for each editable field
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _yearGroupController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _hasCampusResidenceController = TextEditingController();
  final TextEditingController _bestFoodController = TextEditingController();
  final TextEditingController _bestMovieController = TextEditingController();

  // Initialize the current profile information
  String _fullName="";
  String _studentID="";

  @override
  void initState() {
    super.initState();
    // Get the current user data
    UserState userState = Provider.of<UserState>(context, listen: false);
    User? user = userState.getUser();

    // Set the initial text for each editable field
    _fullName = user!.fullName;
    _studentID = user!.studentId;
    _dateOfBirthController.text = user!.dob;
    _yearGroupController.text = user!.yearGroup;
    _majorController.text = user!.major;
    _hasCampusResidenceController.text = user!.residenceStatus;
    _bestFoodController.text = user!.bestFood;
    _bestMovieController.text = user!.bestMovie;
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserState>(context).getUser();
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
                    icon: Icon(Icons.menu),
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
                              profilePicUrl: 'assets/${user?.spiritAnimal?.toLowerCase() ?? 'cat'}.jpg',
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
                          const SnackBar(
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
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
              const Text('Logout'),
            ],
          ),

        ],
      ),
      drawer: const MyDrawer(),
      body: Stack(
        children: [ListView(
          padding: const EdgeInsets.only(top: 30.0, left: 250.0, right: 250.0),
          children: [
            const Text('Edit Profile',style: TextStyle(fontSize: 20, fontFamily: 'Alkatra'), textAlign: TextAlign.center),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Full Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                ),
                Text(_fullName, style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13)), const Text(
                  'Student ID',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                ),
                Text(_studentID, style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13)),
              ],
            ),

            const SizedBox(height: 10.0),
            TextFormField(
              controller: _dateOfBirthController,
              style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                hintStyle: TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              ),
            ),

            const SizedBox(height: 10.0),
            TextFormField(
              controller: _yearGroupController,
              style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Year Group',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                hintStyle: TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              ),
            ),

            const SizedBox(height: 10.0),
            TextFormField(
              controller: _majorController,
              style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Major',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                hintStyle: TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              ),
            ),

            const SizedBox(height: 10.0),
            TextFormField(
              controller: _hasCampusResidenceController,
              style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Has Campus Residence',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                hintStyle: TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              ),
            ),

            const SizedBox(height: 10.0),
            TextFormField(
              controller: _bestFoodController,
              style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Best Food',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                hintStyle: TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: _bestMovieController,
              style: const TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              decoration: const InputDecoration(
                labelText: 'Best Movie',
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Alkatra',fontSize: 13),
                hintStyle: TextStyle(fontFamily: 'Alkatra',fontSize: 13),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                // Save the edited profile information
                setState(() {
                  _fullName = _fullName;
                  _dateOfBirthController.text;
                  _yearGroupController.text;
                  _majorController.text;
                  _hasCampusResidenceController.text;
                  _bestFoodController.text;
                  _bestMovieController.text;
                });
                updateProfileInformation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                textStyle: TextStyle(fontFamily: 'Alkatra', fontSize: 16),
              ),
              child: const Text('Save Changes'),
            ),

          ],
        ),
          const Positioned(
            bottom: 80,
            right: 40,
            child: AddButton(), //Button to add new post
          ),
        ],
      )
    );
  }

  // function to update user profile
  Future<void> updateProfileInformation() async {
    User? user = Provider.of<UserState>(context, listen: false).getUser();
    final url = 'https://abiding-truth-382722.wl.r.appspot.com/user/${user!.studentId}';
    final headers = {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"};
    final body = json.encode({
      'dob': _dateOfBirthController.text,
      'year_group': _yearGroupController.text,
      'major': _majorController.text,
      'residence_status': _hasCampusResidenceController.text,
      'best_food': _bestFoodController.text,
      'best_movie': _bestMovieController.text,
    });

    try {
      final response = await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 204) {
        // Handle successful response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile information saved', textAlign: TextAlign.center,),
          ),
        );
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile information', textAlign: TextAlign.center,),
          ),
        );
      }
    } catch (e) {
      // Handle network or server errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while saving profile information', textAlign: TextAlign.center,),
        ),
      );
    }
  }

}
