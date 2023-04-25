import 'dart:convert';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _idNumber = "";
  String _name = "";
  String _email = "";
  String _dob = "";
  String _yearGroup = "";
  String _major = "";
  String _hasCampusResidence = "Yes";
  String _spiritAnimal = "Cat";
  String _bestFood = "";
  String _bestMovie = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[600],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Go to previous page
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Register',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 25,
            ),
          ),
        ),
        body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding:  const EdgeInsets.only(top: 30.0, left: 250.0, right: 250.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 13.0),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "ID Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your ID number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _idNumber = value;
                      });
                    },
                  ),
                  const SizedBox(height: 13.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  const SizedBox(height: 13.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                            const SizedBox(height: 13.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:const InputDecoration(
                              labelText: "Birthday",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _dob = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 13.0),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Year Group",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your year group';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _yearGroup = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 13.0),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Major",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your major';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _major = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 13.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Campus residence",
                        border: OutlineInputBorder(),
                        ),
                        value: _hasCampusResidence,
                        onChanged: (value) {
                          setState(() {
                            _hasCampusResidence = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: "Yes",
                            child: Text("Yes"),
                          ),
                          DropdownMenuItem(
                            value: "No",
                            child: Text("No"),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an option';
                          }
                          return null;
                        },
                      ),),
                    Expanded(child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Spirit Animal",
                        border: OutlineInputBorder(),
                      ),
                      value: _spiritAnimal,
                      onChanged: (value) {
                        setState(() {
                          _spiritAnimal = value!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "Bear",
                          child: Text("Bear"),
                        ),
                        DropdownMenuItem(
                          value: "Wolf",
                          child: Text("Wolf"),
                        ),
                        DropdownMenuItem(
                          value: "Butterfly",
                          child: Text("Butterfly"),
                        ),
                        DropdownMenuItem(
                          value: "Turtle",
                          child: Text("Turtle"),
                        ),
                        DropdownMenuItem(
                          value: "Cat",
                          child: Text("Cat"),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a spirit animal';
                        }
                        return null;
                      },
                    ),)]),

                  const SizedBox(height: 13.0),
                  TextFormField(
                  decoration: const InputDecoration(
                  labelText: "Best Food",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your best food';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _bestFood = value;
                  });
                },
              ),

                const SizedBox(height: 13.0),

                TextFormField(
                decoration: const InputDecoration(
                  labelText: "Best Movie",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your best movie';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _bestMovie = value;
                  });
                },
              ),
                    const SizedBox(height: 13.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true, // Added to make it a password field
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

                    const SizedBox(height: 13.0),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple[600]),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createAccount(context);
                      }
                    },
                    child: const Text("Create account"),
                  ),
            ],
          ),
        ),
      ),
    )
        )
    );
  }

  // Function to register user via POST request to API endpoint
  Future<void> _createAccount(BuildContext context) async {
    const String apiUrl = 'https://abiding-truth-382722.wl.r.appspot.com/user';
    final url = Uri.parse(apiUrl);
    final body = jsonEncode({
      'student_id': _idNumber,
      'full_name': _name,
      'email': _email,
      'dob': _dob,
      'year_group': _yearGroup,
      'major': _major,
      'residence_status': _hasCampusResidence,
      'spirit_animal': _spiritAnimal,
      'password': _password,
      'best_food': _bestFood,
      'best_movie': _bestMovie,
    });
    // Send a POST request to the API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json',"Access-Control-Allow-Origin": "*"},
      body: body,
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account Created',textAlign: TextAlign.center,),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), //redirect to login page
      );
    } else {
      throw Exception('Failed to send data to API');
    }
  }

}

