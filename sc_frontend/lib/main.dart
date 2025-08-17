import 'package:flutter/material.dart';
import 'package:safe_click/base_screen.dart';
import 'package:safe_click/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter is ready before async code
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email'); // Get stored
  print('booting');
  print(email);

  runApp(SafeClickApp(
      initialScreen: email != null && email.isNotEmpty
          ? const BaseScreen()
          : const WelcomeScreen()));
}

class SafeClickApp extends StatelessWidget {
  final Widget initialScreen;
  const SafeClickApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safe Click',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}
