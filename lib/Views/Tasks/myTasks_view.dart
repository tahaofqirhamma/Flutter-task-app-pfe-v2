// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:task_management_app/Constants/Routes.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';
import 'package:task_management_app/Services/cloud/tasks/firebase_cloud_storage.dart';
import 'dart:developer' as devtools;

import 'package:task_management_app/Utilities/color_app.dart';
import 'package:task_management_app/Utilities/update_task_dialog.dart';

class MyTasksView extends StatefulWidget {
  final userId = AuthService.firebase().currentUser!.id;
  final usernma = AuthService.firebase().currentUser?.isEmailVerified;

  @override
  _MyTasksViewState createState() => _MyTasksViewState();
}

class _MyTasksViewState extends State<MyTasksView> {
  String _filterStatus = ''; // initial filter status
  late Stream<Iterable<CloudTask>> _tasksStream;

  @override
  void initState() {
    super.initState();

    _tasksStream = FirebaseCloudStorage().allTasks(ownerUserid: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    devtools.log(widget.userId);

    return StreamBuilder<Iterable<CloudTask>>(
        stream: _tasksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              color: ColorApp.white,
              padding: const EdgeInsets.all(30),
              child: Material(
                color: ColorApp.white,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  homeRoute, (route) => false);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 34,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 400, // Set the desired width of the image
                        height: 400, // Set the desired height of the image
                        // Center the image horizontally and vertically

                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "lib/assets/backgrounds/notasks.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        child: const Text(
                          "No task created yet !!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorApp.grey,
                            decoration: TextDecoration.none,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              homeRoute, (route) => false);
                        },
                        child: const Text('+ Create new task'),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          final tasks = snapshot.data!;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(.0),
                child: Container(
                  color: const Color.fromARGB(255, 242, 242, 242),
                  child: Column(
                    children: [
                      Container(
                          height: 220,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: ColorApp.scndColor,
                              border: Border.all(
                                color: ColorApp.scndColor,
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                homeRoute, (route) => false);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: ColorApp.white,
                                      )),
                                  const Text(
                                    "My Tasks",
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: ColorApp.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 0.4,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _filterStatus = '';
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _filterStatus == ''
                                            ? const Color.fromARGB(
                                                94, 255, 255, 255)
                                            : const Color.fromARGB(
                                                0, 0, 71, 71),
                                        padding: const EdgeInsets.all(7),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
                                        'All',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _filterStatus = 'completed';
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _filterStatus == 'completed'
                                                ? const Color.fromARGB(
                                                    94, 255, 255, 255)
                                                : const Color.fromARGB(
                                                    0, 0, 71, 71),
                                        padding: const EdgeInsets.all(7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Completed',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _filterStatus = 'in progress';
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _filterStatus == 'in progress'
                                                ? const Color.fromARGB(
                                                    94, 255, 255, 255)
                                                : const Color.fromARGB(
                                                    0, 0, 71, 71),
                                        padding: const EdgeInsets.all(7),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                      ),
                                      child: const Text(
                                        'In Progress',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _filterStatus = 'canceled';
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _filterStatus == 'canceled'
                                                ? const Color.fromARGB(
                                                    94, 255, 255, 255)
                                                : const Color.fromARGB(
                                                    0, 0, 71, 71),
                                        padding: const EdgeInsets.all(7),
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30)),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancelled',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                          child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 0,
                        ),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks.elementAt(index);

                          if (_filterStatus.isNotEmpty &&
                              task.taskStatus != _filterStatus) {
                            // if filter status is set, skip tasks that don't match it
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              height: 190,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomRight: Radius.circular(22)),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      left: BorderSide(
                                          color:
                                              getBorderColor(task.taskStatus),
                                          width: 10)),
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        task.taskTitle.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              getBorderColor(task.taskStatus),
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () async {
                                              await showUpdateTaskDialog(
                                                context,
                                                task,
                                                AuthService.firebase()
                                                    .currentUser!
                                                    .id
                                                    .toString(),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              // show confirmation dialog and delete task if confirmed
                                              FirebaseCloudStorage().deleteTask(
                                                  documentId: task.documentId);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        task.taskDesc,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Date: ${task.taskDate}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                              bottom: 3,
                                              top: 3,
                                              left: 7,
                                              right: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: getBorderColor(
                                                      task.taskStatus)),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: getBorderColor(
                                                      task.taskStatus)
                                                  .withOpacity(0.2),
                                            ),
                                            child: Text(
                                              ' ${task.taskStatus}',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: getBorderColor(
                                                      task.taskStatus),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    // navigate to task details screen
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

Color getBorderColor(String taskStatus) {
  switch (taskStatus) {
    case 'completed':
      return ColorApp.fthColor;
    case 'in progress':
      return Colors.orange;
    case 'canceled':
      return Colors.red;
    default:
      return Colors.transparent;
  }
}
