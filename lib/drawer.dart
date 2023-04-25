//imports
import 'package:flutter/material.dart';
import 'settingss.dart';
import 'tips.dart';
import 'sos.dart';
import 'home.dart';
import 'newpost.dart';
import 'login.dart';

// Drawer class for the side navigation bar
class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple,
            ),
            child: Text(
              'I am seen...Are you?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,fontFamily: "Pacifico"
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home',style: TextStyle(
                fontSize: 16,fontFamily: "Alkatra"
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()), //Go to home page
              );
            },
          ),

          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.health_and_safety_outlined),
            title: const Text('Health Tips',style: TextStyle(
                fontSize: 16,fontFamily: "Alkatra"
            )),
            onTap: () {
              // navigate to health tips page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Tips()),
              );
            },
          ),

          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings',style: TextStyle(
                fontSize: 16,fontFamily: "Alkatra"
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()), //Go to settings page
              );
            },
          ),

          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.crisis_alert_outlined),
            title: const Text('Register SOS',style: TextStyle(
                fontSize: 16,fontFamily: "Alkatra"
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Sos()), //Go to SOS page
              );
            },
          ),

          const SizedBox(height: 20),
          //Logout icon
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout',style: TextStyle(
                fontSize: 16,fontFamily: "Alkatra"
            )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), //Go to login page
              );
            },
          ),
        ],
      ),
    );
  }
}

// Add new post button - This will appear on every page to allow user add new post
class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // set bottom margin
      child: FloatingActionButton(
        backgroundColor: Colors.purple[600],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
