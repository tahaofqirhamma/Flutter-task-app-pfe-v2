import 'package:flutter/material.dart';
import 'package:task_management_app/Views/Login_view.dart';
import 'package:task_management_app/Views/Signup_view.dart';
import 'package:task_management_app/Views/landing_view.dart';

import 'Constants/Routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const LandingView(),
    routes: {
      loginRoute: (context) => const LoginView(),
      signupRoute: (context) => const SigupView(),
      // notesRoute: (context) => const NotesView(),
      // verifyEmailRoute: (context) => const VerifyEmailView(),
      // newNoteRoute: (context) => const NewNoteView()
    },
  ));
}
