import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/dashboard.dart';
import '../services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Case 1: A real (non-anonymous) or anonymous user already exists.
        // Both go to Dashboard — Dashboard itself decides what to show
        // based on user.isAnonymous.
        if (snapshot.hasData && snapshot.data != null) {
          final User user = snapshot.data!;
          return Dashboard(userId: user.uid);
        }

        // Case 2: No user at all. This can mean either:
        //   a) genuinely the first app open / a completed sign-out, or
        //   b) a fleeting null emitted WHILE a signIn/signUp/signOut is
        //      still finishing internally (Firebase briefly clears the
        //      session before setting the new one).
        // _GuestBootstrapper checks AuthService.isAuthTransitionInProgress
        // before acting, so case (b) doesn't race with the real transition.
        return const _GuestBootstrapper();
      },
    );
  }
}

/// Signs the device in anonymously once no real auth transition is in
/// flight, then lets the StreamBuilder above pick up the new (anonymous)
/// user and route to Dashboard automatically.
class _GuestBootstrapper extends StatefulWidget {
  const _GuestBootstrapper();

  @override
  State<_GuestBootstrapper> createState() => _GuestBootstrapperState();
}

class _GuestBootstrapperState extends State<_GuestBootstrapper> {
  @override
  void initState() {
    super.initState();
    _signInAsGuestWhenSafe();
  }

  Future<void> _signInAsGuestWhenSafe() async {
    // If a real signIn/signUp/signOut is currently underway, wait it out
    // instead of firing an anonymous sign-in that could race with it.
    // This loop is short-lived: isAuthTransitionInProgress flips back to
    // false as soon as the in-flight call finishes.
    int safetyCounter = 0;
    while (AuthService.isAuthTransitionInProgress && safetyCounter < 50) {
      await Future.delayed(const Duration(milliseconds: 100));
      safetyCounter++;
    }

    if (!mounted) return;

    // Re-check: if a real user has since appeared (the transition we were
    // waiting on resolved into a signed-in user), authStateChanges will
    // rebuild AuthWrapper into the Dashboard branch on its own — no need
    // to sign in anonymously here.
    if (FirebaseAuth.instance.currentUser != null) return;

    try {
      await FirebaseAuth.instance.signInAnonymously();
      // No need to navigate manually — authStateChanges() in AuthWrapper
      // will fire with the new anonymous user and rebuild into Dashboard.
    } catch (e) {
      // If anonymous sign-in fails (e.g. disabled in Firebase console,
      // or no network), you could fall back to Login here.
      debugPrint('Anonymous sign-in failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}