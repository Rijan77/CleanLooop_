
import 'package:cleanloop/pages/user_auth/OnboardingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../homePage.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        } else if(snapshot.hasError){
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        }else {
          if(snapshot.data == null){
            return const Onboardingpage();
          } else{
            return  const Onboardingpage();
          }
        }

      }),
    );
  }
}
