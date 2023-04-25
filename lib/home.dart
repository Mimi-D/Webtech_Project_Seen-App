//Imports
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finalproj/profile.dart';
import 'package:finalproj/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'newpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    // Get the user information from the UserState using Provider
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
                      Scaffold.of(context).openDrawer(); //Show the side nav bar
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector( //when profile picture is clicked
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
                    }, //onTap
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/${user!.spiritAnimal.toLowerCase()}.jpg'),
                      radius: 20.0,
                    ),
                  ),
                ),
              ],//children
            )
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () { // if logout icon is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  // Handle logout tap
                }, //onPressed
              ),
              const Text('Logout'),
            ],
          ),
        ], //actions
      ),
      drawer: const MyDrawer(), //Side nav bar
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/calm2.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 250.0, right: 250.0),
              child: SizedBox.expand(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('post')
                      .orderBy('posted_at', descending: true)
                      .snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong, snapshot error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot doc = documents[index];
                        Post post = Post.fromSnapshot(doc);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.text,
                                    style: const TextStyle(
                                        fontFamily: 'Alkatra', fontSize: 16)),
                                const SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Posted by ${post.fullName} on ${post.postedAt}',
                                        style: const TextStyle(
                                            fontFamily: 'Alkatra', fontSize: 12)),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.thumb_up),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('post')
                                                .doc(doc.id)
                                                .update({'likes': FieldValue.increment(1)});
                                          },
                                        ),
                                        Text('${post.likes}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 80,
            right: 40,
            child: AddButton(),
          ),
        ],
      ),
    );
  }
}
