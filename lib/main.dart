import 'package:flutter/material.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Views/Login_view.dart';
import 'package:task_management_app/Views/Signup_view.dart';
import 'package:task_management_app/Views/home_view.dart';
import 'package:task_management_app/Views/landing_view.dart';

import 'Constants/Routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      signupRoute: (context) => const SigupView(),
      homeRoute: (context) => const HomeView(),
      // notesRoute: (context) => const NotesView(),
      // verifyEmailRoute: (context) => const VerifyEmailView(),
      // newNoteRoute: (context) => const NewNoteView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomeView();
              } else {
                // return const VerifyEmailView();
              }
            } else {
              return const LandingView();
            }
          }
          return const CircularProgressIndicator();
        });
  }
}
