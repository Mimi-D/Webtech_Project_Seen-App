import 'package:finalproj/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'register.dart';
import 'user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _studentId = "";
  String _password = "";
  bool _isLoading = false;
  String _errorMessage = "";

  // Login verification logic
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try { //try and retrieve student info with given ID
      final uri = Uri.parse('https://abiding-truth-382722.wl.r.appspot.com/user/$_studentId');
      final response = await http.get(uri,headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"});
      final responseData = json.decode(response.body);

      //If status code is 404 resource doesn't exist
      if (response.statusCode == 404) {
        setState(() {
          _isLoading = false;
          _errorMessage = "Invalid Student ID";
        });
        return;
      }
      // check if given password matched the password in database
      if (responseData['password'] == _password) {
        //create user to keep track of logged in user
        User user = User.createUser(responseData);
        Provider.of<UserState>(context, listen: false).setUser(user);

        // Successful login, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = "Invalid Password";
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = "An error occurred, please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(450.0, 0.0, 450.0, 0.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 150.0),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[900],
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                SizedBox(
                  width: 50.0, // adjust this width as needed
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Student ID",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Student ID';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _studentId = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 25.0),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 30, // set the desired width here
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple[900]),
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading ? const CircularProgressIndicator() : const Text("Login"),
                  ),
                ),

                if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'Alkatra',
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 18.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: const Center(
                    child: Text(
                      "Don't have an account? sign up",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
