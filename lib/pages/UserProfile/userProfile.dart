import 'package:cleanloop/pages/UserProfile/ImagePick.dart';
import 'package:cleanloop/pages/user_auth/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../CustomDialog.dart';
import '../eco_features/historyPage.dart';
import 'EditProfilePage.dart';
import 'HelpSupportPage.dart';
import '../user_auth/auth_service.dart';
import 'SettingsPage.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {

  Uint8List? _image;

  void selectImage()async{
    Uint8List img = await pickImage(ImageSource.gallery);

    setState(() {
      _image = img;
    });

  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    final auth = AuthService();

    return Scaffold(
      body:
      Column(
        children: [
          Stack(
            children: [
              Container(
                height: screenHeight *0.2,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff34D399),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 80 ),
                  child: CircleAvatar(
                    radius: 62,
                    backgroundColor: Colors.blue.shade50,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : const AssetImage("lib/assets/images/default_profile.png") as ImageProvider,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 170, left: 220),
                child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo)),
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active &&
                  snapshot.hasData &&
                  snapshot.data!.docs.isNotEmpty) {
                return Text(
                  snapshot.data!.docs[0]["name"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(
            height: 8,
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildProfileOption(
                  context,
                  icon: Icons.person,
                  title: "Edit Profile",
                  subtitle: "Edit your own profile.",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const EditProfilePage()));
                  },
                ),
                const SizedBox(height: 5,),

                _buildProfileOption(context, icon: Icons.history, title: "My History", subtitle: "Track your past activities",
                    onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const HistoryPage(userId: ' ',)));

                }),
                const SizedBox(height: 5,),

                _buildProfileOption(
                  context,
                  icon: Icons.settings,
                  title: "Settings",
                  subtitle: "Adjust your preferences.",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const SettingsPage())

                    );
                  },
                ),
                const SizedBox(height: 5,),

                _buildProfileOption(
                  context,
                  icon: Icons.help,
                  title: "Help & Support",
                  subtitle: "Get assistance for any issues.",
                  onTap: () {
                    // Navigate to Help & Support Page (Placeholder)
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const HelpSupportPage())
                    );
                  },
                ),

                const SizedBox(height: 5,),
                _buildProfileOption(
                  context,
                  icon: Icons.logout,
                  title: "Logout!",
                  subtitle: "Sign out of your account.",
                  onTap: ()async{
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
              ],

            ),
          ),



          //
        ],
      ),
    );
  }
  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.black54),
        ),
        onTap: onTap,
      ),
    );
  }
}


