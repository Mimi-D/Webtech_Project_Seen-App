import 'dart:convert';
import 'package:finalproj/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'login.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

// SOS page
class Sos extends StatelessWidget {
  const Sos({super.key});

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
                      final response = await http.get(Uri.parse('https://abiding-truth-382722.wl.r.appspot.com/user/${user.studentId}'),headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"});
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
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () { // log out
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
        children: [Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'CLICK ME TO CALL FOR HELP',
              style: TextStyle(fontSize: 18, fontFamily: 'Alkatra'),
            ),
            const SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {
                  _showConfirmationDialog(context);
                },
                child: Image.asset(
                  'assets/sos.png', // replace with the path to your sos button image
                  height: 300.0,
                  width: 300.0,
                ),
              ),
            ),
          ],
        ),
          const Positioned(
            bottom: 80,
            right: 40,
            child: AddButton(), // Button to add new post
          )
        ],
      )
    );
  }
  //This function shows the confirmation pop up box where the user confirms he/she meant to press the sos button
  // if confirmed the student's sos is registered in the database
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Do you need help?',
            style: TextStyle(fontSize: 22, fontFamily: 'Alkatra'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(fontSize: 20, fontFamily: 'Alkatra'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(fontSize: 20, fontFamily: 'Alkatra'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _registerSos(context); //sos is registered
                _showSosMessage(context);
              },
            ),
          ],
        );
      },
    );
  }

  // function to register sos
  Future<void> _registerSos(BuildContext context) async {
    try {
      final user = Provider.of<UserState>(context, listen: false).getUser()!; //get user info
      final response = await http.post( //send POST request to api endpoint
        Uri.parse('https://abiding-truth-382722.wl.r.appspot.com/sos'),
        headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"},
        body: '{"student_id": "${user.studentId}"}',
      );

      if (response.statusCode == 201) {
        print('SOS registered');
      } else {
        throw Exception('Failed to register SOS');
      }
    } catch (e) {
      print('Error registering SOS: $e');
    }
  }

  void _showSosMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Hang in there, you matter, your life matters',
            style: TextStyle(fontSize: 22, fontFamily: 'Alkatra'),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'This is a message to let you know that you are not alone. Help is on the way. Stay where you are and keep yourself safe.',
            style: TextStyle(fontSize: 18, fontFamily: 'Alkatra'),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child:
              const Text('OK',style: TextStyle(fontSize: 18, fontFamily: 'Alkatra'),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );//showDialog
  }
}
