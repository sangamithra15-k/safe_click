import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:safe_click/constant.dart';
import 'package:safe_click/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notification = true;
  bool updates = true;
  bool warningBuzz = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [c2, c1],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sett.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadows: [
                    Shadow(
                      offset: Offset(
                          1.5, 1.5), // horizontal & vertical shadow offset
                      blurRadius: 50.0, // blur effect on shadow
                      color: Colors.black.withOpacity(1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Frosted container
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: size.width * 0.9,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Account
                        Row(
                          children: const [
                            Icon(Icons.account_circle,
                                color: buttoncolor, size: 28),
                            SizedBox(width: 8),
                            Text(
                              "Account",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: buttoncolor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        settingOption("Threat Analysis"),
                        settingOption("Change Password"),
                        settingOption("Privacy"),
                        dividerLine(),

                        // Notification
                        Row(
                          children: const [
                            Icon(Icons.notifications,
                                color: buttoncolor, size: 28),
                            SizedBox(width: 8),
                            Text(
                              "Notification",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: buttoncolor,
                              ),
                            ),
                          ],
                        ),
                        switchOption("Notification", notification, (val) {
                          setState(() => notification = val);
                        }),
                        switchOption("Updates", updates, (val) {
                          setState(() => updates = val);
                        }),
                        switchOption("Warning Buzz", warningBuzz, (val) {
                          setState(() => warningBuzz = val);
                        }),
                        dividerLine(),

                        // Others
                        Row(
                          children: const [
                            Icon(Icons.settings, color: buttoncolor, size: 28),
                            SizedBox(width: 8),
                            Text(
                              "Others",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: buttoncolor,
                              ),
                            ),
                          ],
                        ),
                        languageOption("Language", "ENGLISH"),
                        settingOption("Support Center"),
                        dividerLine(),

                        // Logout & Help
                        GestureDetector(
                          onTap: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Confirm Logout",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: const Text(
                                  "Are you sure you want to log out?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false), // Cancel
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true), // Confirm
                                    child: const Text(
                                      "Log Out",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldLogout ?? false) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs
                                  .clear(); // Clear all stored data (including Gmail)

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            }
                          },
                          child: const Text(
                            "Log out",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 0, 0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Help",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 0, 0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingOption(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  Widget switchOption(String text, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: c1,
            inactiveTrackColor: Colors.white38,
          ),
        ],
      ),
    );
  }

  Widget languageOption(String text, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: c1,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget dividerLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(
        color: Colors.white.withOpacity(0.6),
        thickness: 1,
      ),
    );
  }
}
