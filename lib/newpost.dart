import 'package:finalproj/profile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'login.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// Post entity
class Post {
  final String text;
  final String fullName;
  int likes;
  final String postedAt;

  Post({required this.text, required this.fullName, this.likes = 0,required this.postedAt});

  //create post entity from firebase snapshot
  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String postedAtString = data['posted_at'];
    DateTime postedAt = DateTime.parse(postedAtString);
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(postedAt);
    return Post(
      text: data['comment'],
      fullName: data['full_name'],
      likes: data['likes'] ?? 0,
      postedAt: formattedTime,
    );
  }

  // create map object
  Map<String, dynamic> toMap() {
    return {
      'comment': text,
      'full_name': fullName,
      'likes': likes,
      'posted_at': postedAt,
    };
  }
}

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  NewPostPageState createState() => NewPostPageState();
}

class NewPostPageState extends State<NewPostPage> {
  final TextEditingController _postTextController = TextEditingController();
  // submit a new post
  void _submitPost() async {
    User? user = Provider.of<UserState>(context, listen: false).getUser();
    const String url = 'https://abiding-truth-382722.wl.r.appspot.com/post';
    final String studentId = user!.studentId;
    final String fullName = user!.fullName;
    final String email = user!.email;
    final String comment = _postTextController.text;

    //data to be sent in POST request
    final body = jsonEncode({
      'student_id': studentId,
      'full_name': fullName,
      'email': email,
      'comment': comment,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"},
      body: body,
    );

    //post submitted successfully
    if (response.statusCode == 201) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New Post Made',textAlign: TextAlign.center,),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to make a new post',textAlign: TextAlign.center,),
        ),
      );
    }
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
                onPressed: () { //logout
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
      drawer: const MyDrawer(), //side nav bar
      body: Stack(
        children: [
          Image.asset(
            'assets/calm3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 250.0, right: 250.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.purple[600]?.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: TextFormField(
                  controller: _postTextController,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontFamily: 'Alkatra'),
                  decoration: const InputDecoration(
                    hintText: 'Enter your post here...',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitPost,
        backgroundColor: Colors.purple[600],
        child: const Icon(Icons.send), //when clicked it calls _submitPost function
      ),
    );
  }
}
