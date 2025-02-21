import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'signup_page.dart'; // Import the Sign-Up page

final Logger logger = Logger(); // Initialize Logger

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with specific project details
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA6Ldfzp8OUVXvnz-SDKnOa1B8o7m_MYGo",
      authDomain: "hospitalplaylist-eb7e2.firebaseapp.com",
      projectId: "hospitalplaylist-eb7e2",
      storageBucket: "hospitalplaylist-eb7e2.firebasestorage.app",
      messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
      appId: "1:598967583492:android:de6c2cc455ed9690cb4651",
      measurementId: "YOUR_MEASUREMENT_ID",
    ),
  );

  logger.i("✅ Firebase Initialized!"); // Log initialization success

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const AuthWrapper(), // Home decides login/signup
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(), // Add sign-up route
      },
    );
  }
}

// Wrapper to check login state
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          logger.i("User: $user"); // Log user info
          return user == null ? const LoginPage() : HomePage(user: user);
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
