import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadbiro/data/services/firebase_auth_service.dart';
import 'package:tadbiro/ui/screens/events_screen.dart';
import 'package:tadbiro/ui/screens/home_screen.dart';
import 'package:tadbiro/ui/screens/notification_screen.dart';

class CustomDrawerWidget extends StatefulWidget {
  const CustomDrawerWidget({
    super.key,
  });

  @override
  State<CustomDrawerWidget> createState() => _CustomDrawerWidgetState();
}

class _CustomDrawerWidgetState extends State<CustomDrawerWidget> {
  String fullName = 'John Done';
  String email = 'john.doe@example.com';
  String imagePath = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? 'john Doe';
      email = prefs.getString('email') ?? 'john.doe@example.com';
      imagePath = prefs.getString('imagePath') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.amber),
            accountName: Text(fullName),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: imagePath.isNotEmpty
                  ? FileImage(File(imagePath))
                  : const NetworkImage(
                      "https://avatars.mds.yandex.net/i?id=1680de67074417bac228642b7af6165d5c7c43ff-10332895-images-thumbs&ref=rim&n=33&w=271&h=250"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const HomeScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const EventsScreen();
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_on),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const NotificationScreen();
              }));
            },
          ),
          // ignore: prefer_const_constructors
          Spacer(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuthServices().logout();
            },
          ),
        ],
      ),
    );
  }
}
