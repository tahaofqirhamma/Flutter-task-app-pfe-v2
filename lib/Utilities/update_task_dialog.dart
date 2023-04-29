import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/Services/cloud/cloud_storage_constants.dart';
import 'package:task_management_app/Services/cloud/cloud_storage_exceptions.dart';
import 'package:task_management_app/Services/cloud/cloud_task.dart';
import 'package:task_management_app/Utilities/color_app.dart';

Future<bool> showUpdateTaskDialog(
    BuildContext context, CloudTask task, String owner) {
  final TextEditingController titleController =
      TextEditingController(text: task.taskTitle);
  final TextEditingController descriptionController =
      TextEditingController(text: task.taskDesc);
  final TextEditingController dateController =
      TextEditingController(text: task.taskDate);
  final TextEditingController statusController =
      TextEditingController(text: task.taskStatus.trim());

  Future<void> updateTask(CloudTask updatedTask) async {
    try {
      final tasks = FirebaseFirestore.instance.collection('tasks');

      await tasks.doc(updatedTask.documentId).update({
        tasktitle: updatedTask.taskTitle,
        taskdesc: updatedTask.taskDesc,
        taskdate: updatedTask.taskDate,
        taskstatus: updatedTask.taskStatus,
      });
    } catch (e) {
      throw CouldNotUpdateTaskException();
    }
  }

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Update task',
          style: TextStyle(color: ColorApp.fthColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: statusController.text,
              items: const [
                DropdownMenuItem(
                  value: 'in progress',
                  child: Text('In progress'),
                ),
                DropdownMenuItem(
                  value: 'canceled',
                  child: Text('Cancelled'),
                ),
                DropdownMenuItem(
                  value: 'completed',
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {
                statusController.text = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final updatedTask = CloudTask(
                documentId: task.documentId,
                taskTitle: titleController.text,
                taskDesc: descriptionController.text,
                taskDate: dateController.text,
                taskStatus: statusController.text,
                ownerUserid: owner,
              );
              await updateTask(updatedTask);

              Navigator.of(context).pop(true);
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
