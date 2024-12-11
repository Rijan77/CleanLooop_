import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CustomDialog.dart';
import '../user_auth/LoginPage.dart';
import 'ThemeManager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true; // For notifications toggle
  String _selectedLanguage = 'English'; // Default language
  final List<String> _languages = ['English', 'Nepali', 'Hindi', 'Chinese'];

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }

  void _changeLanguage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: _languages.map((language) {
            return RadioListTile<String>(
              title: Text(language),
              value: language,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                  Navigator.pop(context); // Close the modal
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 33,),
          onPressed: () {
            // Navigate back to login page
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xff34D399),
        title: const Text(
          "Settings",
          style: TextStyle(fontFamily: "Calistoga", fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Theme Mode Toggle
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: themeManager.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeManager.toggleTheme(value);
              },
              activeColor: Colors.green,
            ),
          ),
          const Divider(),

          // Notification Preferences
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: Colors.green,
            ),
          ),
          const Divider(),

          // Language Selection
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: Text("Current: $_selectedLanguage"),
            onTap: () => _changeLanguage(context),
          ),
          const Divider(),

          // Logout Option
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Logout"),
            onTap: ()async{
              // Handle logout logic here
              CustomDialog.showSuccessDialog(
                context: context,
                title: "Logout!",
                message: "We hate to see you go! Sure you want to log out?",
                onConfirm: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Loginpage()),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 14),
          const Divider(thickness: 1),
          const SizedBox(height: 394),
          const Center(
            child: Text(
              "© 2024 CleanLoop. All rights reserved.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
