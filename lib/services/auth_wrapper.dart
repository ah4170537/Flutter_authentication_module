import 'package:firebase_auth/firebase_auth.dart'; // Correct import
import 'package:flutter/material.dart';

import '../pages/dashboard.dart';
import '../pages/login.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

       
        if (snapshot.hasData && snapshot.data != null) {
          final User user = snapshot.data!;
          return Dashboard(userId: user.uid);
        }


        if (snapshot.connectionState == ConnectionState.active) {
          return const Login();
        }

  
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}