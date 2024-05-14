import 'package:flutter/material.dart';
import 'package:flutter_application_7/auth.dart';
import 'package:flutter_application_7/screen/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_7/screen/home_screen.dart';
import 'package:flutter_application_7/screen/login_screen.dart';
import 'package:flutter_application_7/store_model.dart';

void main() async {
  // Ensure that plugins are initialized before runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()), // Provide your Auth provider
        ChangeNotifierProvider(create: (_) => StoreProvider()), 
        // Add more providers if needed
      ],
      child: MaterialApp(
        title: 'Your App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => MainPage(),
          // '/profile': (context) => EditProfileScreen(),
          '/signup': (context) => SignUpPage(),
          '/login': (context) => LoginPage(),
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the signup page
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Sign Up'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
