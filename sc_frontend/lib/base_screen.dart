import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:safe_click/constant.dart';
import 'package:safe_click/email.dart';
import 'package:safe_click/home_link.dart';
import 'package:safe_click/settings.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    VerifyUrlPage(),
    VerifyEmailPage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // allows nav bar to float over content
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0), // margin around navbar
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              backgroundColor: Colors.white.withOpacity(0.15),
              elevation: 0,
              items: [
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.home,
                      color: buttoncolor, size: activeiconsize),
                  icon: Icon(Icons.home, size: iconsize),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.email,
                      color: buttoncolor, size: activeiconsize),
                  icon: Icon(Icons.email, size: iconsize),
                  label: "Email",
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.settings,
                      color: buttoncolor, size: activeiconsize),
                  icon: Icon(Icons.settings, size: iconsize),
                  label: "Settings",
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
