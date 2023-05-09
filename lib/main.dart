import 'package:flutter/material.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Services/notiffications/notifications_service.dart';
import 'package:task_management_app/Utilities/color_app.dart';
import 'package:task_management_app/Views/Login_view.dart';
import 'package:task_management_app/Views/My_profile_view.dart';
import 'package:task_management_app/Views/Signup_view.dart';
import 'package:task_management_app/Views/Tasks/myTasks_view.dart';
import 'package:task_management_app/Views/Tasks/statistics_task_view.dart';
import 'package:task_management_app/Views/home_view.dart';
import 'package:task_management_app/Views/landing_view.dart';
import 'Constants/Routes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      signupRoute: (context) => const SigupView(),
      homeRoute: (context) => const HomeView(),
      myProfieRoute: (context) => const MyProfile(),
      mytasksRoute: (context) => MyTasksView(),
      statsRout: (context) => const StatisticsView()
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
          return const Center(
              child: CircularProgressIndicator(
            color: ColorApp.white,
          ));
        });
  }
}
