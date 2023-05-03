// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:task_management_app/Constants/Routes.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';
import 'package:task_management_app/Services/cloud/tasks/firebase_cloud_storage.dart';
import 'package:task_management_app/Services/cloud/user/cloud_user.dart';
import 'package:task_management_app/Services/cloud/user/cloud_user_constants.dart';
import 'package:task_management_app/Utilities/color_app.dart';
import 'package:task_management_app/Utilities/crearte_task_dialog.dart';
import 'package:task_management_app/Utilities/logout_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

@override
void initState() {}

class _HomeViewState extends State<HomeView> {
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final firebaseStorage = FirebaseCloudStorage();

    DateTime today = DateTime.now();

    return StreamBuilder<Iterable<CloudTask>>(
        stream: firebaseStorage.allTasks(
            ownerUserid: AuthService.firebase().currentUser!.id),
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];

          return Container(
            color: const Color.fromARGB(255, 242, 242, 242),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorApp.prpColor,
                      border: Border.all(
                        color: ColorApp.prpColor, // Set border color here
                        width: 2, // Set border width here
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(70),
                      ),
                    ),
                    padding: const EdgeInsets.all(24),

                    // set a different background color for the container holding the Column
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize:
                          MainAxisSize.min, // set the mainAxisSize to min
                      children: [
                        const SizedBox(
                            height: 50), // add a SizedBox for top margin
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('user')
                                .doc(AuthService.firebase().currentUser!.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data == null) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: ColorApp.prpColor,
                                )); // or any other widget to show a loading state
                              }
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              final user = CloudUser(
                                userId: userData[userName],
                                email: userData[eamil],
                                username: userData[userName],
                              );
                              final username = user.username.toUpperCase();

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Welcome back $username",
                                    maxLines: 1,
                                    style: const TextStyle(
                                      color: ColorApp.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final shouldLogout =
                                          await showLogOutDialog(context);
                                      if (shouldLogout) {
                                        await AuthService.firebase().logOut();
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          loginRoute,
                                          (_) => false,
                                        );
                                      }
                                    },
                                    child: const Icon(
                                      Icons.login_outlined,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      size: 30.0,
                                    ),
                                  )
                                ],
                              );
                            }),
                        const SizedBox(
                            height:
                                10), // add a SizedBox for space between rows
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 24),
                              child: Text(
                                '${today.day}-${today.month}-${today.year}',
                                style: const TextStyle(
                                  color: ColorApp.fthColor,
                                  fontSize: 18,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  tasks.length.toString(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: ColorApp.fthColor,
                                    decoration: TextDecoration.none,
                                  ),
                                ),

                                const SizedBox(height: 5),
                                const Text(
                                  'Tasks \n\ created ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: ColorApp.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                // SizedBox(height: 5),
                                // Text(
                                //   '',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w500,
                                //     color: ColorApp.white,
                                //     decoration: TextDecoration.none,
                                //   ),
                                // ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  tasks
                                      .where((element) =>
                                          element.taskStatus == "in progress")
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: ColorApp.fthColor,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Tasks \n\ In progerss ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: ColorApp.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                // SizedBox(height: 5),
                                // Text(
                                //   'In progress',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontWeight: FontWeight.w500,
                                //     color: ColorApp.white,
                                //     decoration: TextDecoration.none,
                                //   ),
                                // ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  tasks
                                      .where((element) =>
                                          element.taskStatus == "completed")
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                    color: ColorApp.fthColor,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Tasks \n\ Completed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: ColorApp.white,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),

                        // add a SizedBox for bottom margin
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 242, 242, 242),
                    height: 470,
                    // set the background color
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorApp.white,
                            border: Border.all(
                              color: ColorApp.white, // Set border color here
                              width: 2, // Set border width here
                            ),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(70),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 24, bottom: 24),
                          // set a different background color for the container holding the Column
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize:
                                MainAxisSize.min, // set the mainAxisSize to min
                            children: [
                              // add a SizedBox for top margin
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      final String useID =
                                          AuthService.firebase()
                                              .currentUser!
                                              .id;
                                      await showCreateTaskDialog(
                                          context, useID);
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: ColorApp.white,
                                        border: Border.all(
                                          color: ColorApp
                                              .white, // Set border color here
                                          width: 2, // Set border width here
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xffDDDDDD),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0.0, 0.0),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  226, 182, 187, 255),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.edit_square,
                                              color: Color.fromARGB(
                                                  232, 65, 92, 242),
                                              size: 30.0,
                                            ),
                                          ),
                                          const Text('Create task',
                                              style: TextStyle(
                                                  color: ColorApp.scndColor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .popAndPushNamed(mytasksRoute);
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: ColorApp.white,
                                        border: Border.all(
                                          color: ColorApp
                                              .white, // Set border color here
                                          width: 2, // Set border width here
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xffDDDDDD),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0.0, 0.0),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 196, 240, 238),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.task,
                                              color: Color.fromARGB(
                                                  255, 30, 179, 177),
                                              size: 30.0,
                                            ),
                                          ),
                                          const Text('My tasks',
                                              style: TextStyle(
                                                  color: ColorApp.scndColor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .popAndPushNamed(statsRout);
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: ColorApp.white,
                                        border: Border.all(
                                          color: ColorApp
                                              .white, // Set border color here
                                          width: 2, // Set border width here
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xffDDDDDD),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0.0, 0.0),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  252, 207, 233, 248),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.bar_chart,
                                              color: Color.fromARGB(
                                                  255, 44, 155, 219),
                                              size: 30.0,
                                            ),
                                          ),
                                          const Text('Statistics',
                                              style: TextStyle(
                                                  color: ColorApp.scndColor)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(myProfieRoute);
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: ColorApp.white,
                                        border: Border.all(
                                          color: ColorApp
                                              .white, // Set border color here
                                          width: 2, // Set border width here
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0xffDDDDDD),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0.0, 0.0),
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(7),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  226, 182, 187, 255),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: Color.fromARGB(
                                                  232, 65, 92, 242),
                                              size: 30.0,
                                            ),
                                          ),
                                          const Text(
                                            'My profile',
                                            style: TextStyle(
                                                color: ColorApp.scndColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // add a SizedBox for space between rows
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
