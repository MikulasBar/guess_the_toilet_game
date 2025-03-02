import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guess_the_toilet/app/router/router.gr.dart';
import 'package:guess_the_toilet/auth/auth_service.dart';
import 'package:guess_the_toilet/l10n/s.dart';
import 'package:guess_the_toilet/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Get auth service
  final authService = AuthService();

  // Log out from your account
  void logout() async {
    await authService.signOut();

    // Check if the widget is still mounted before accessing context

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(S.of(context).profile__successfully_logged_out),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // get user email
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: IconButton(
          onPressed: () {
            AutoRouter.of(context).navigate(
              RoadmapRoute(),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          // Log out button and confirmation popup
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      "Confirm Logout",
                    ),
                    content: Text("Do you really want to log out?"),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              logout();
                              Navigator.of(context).pop(); // Close the dialog
                              AutoRouter.of(context).navigate(AuthGate());
                            },
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // Display the user email
              Text(
                currentEmail == null
                    ? "Anonymous login"
                    : currentEmail.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),

              // Display the user id
            ],
          ),
        ),
      ),
    );
  }
}
