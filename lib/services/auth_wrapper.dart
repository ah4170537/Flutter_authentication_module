import 'package:firebase_auth/firebase_auth.dart'; // Correct import
import 'package:flutter/material.dart';
// Apni screens ke imports yahan karein
import '../pages/dashboard.dart';
import '../pages/login.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jab tak connection waiting state mein hai, loading dikhayein
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Agar snapshot mein data mojood hai (User logged in hai)
        if (snapshot.hasData && snapshot.data != null) {
          final User user = snapshot.data!;
          return Dashboard(userId: user.uid);
        }

        // Agar connection active/done ho gaya hai lekin data nahi hai, matlab user logged out hai
        if (snapshot.connectionState == ConnectionState.active) {
          return const Login();
        }

        // Fallback loading jab tak stream fully active nahi hoti
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}