import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_storage_constants.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';
import 'package:task_management_app/Utilities/color_app.dart';

Future<bool> showCreateTaskDialog(BuildContext context, String userID) {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final dateController = TextEditingController();

  final tasks = FirebaseFirestore.instance.collection('tasks');

  Future<CloudTask> createTask({required String ownerUserid}) async {
    final document = await tasks.add({
      owner: ownerUserid,
      tasktitle: titleController.text,
      taskdesc: descriptionController.text,
      taskstatus: statusController.text,
      taskdate: dateController.text,
    });

    final fetchedTask = await document.get();

    return CloudTask(
      documentId: fetchedTask.id,
      ownerUserid: userID,
      taskDesc: titleController.text,
      taskTitle: descriptionController.text,
      taskDate: statusController.text,
      taskStatus: dateController.text,
    );
  }

  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          'Create task',
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
            const SizedBox(height: 9),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                final pickedDate = await DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime.now().add(const Duration(days: 365)),
                  theme: const DatePickerTheme(
                    backgroundColor: Colors.white,
                    headerColor: ColorApp.prpColor,
                    itemStyle: TextStyle(
                      color: ColorApp.prpColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    doneStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );

                if (pickedDate != null) {
                  dateController.text =
                      DateFormat('dd/MM/yyyy HH:mm').format(pickedDate);
                }
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: null,
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
                if (value == null) {
                  statusController.text = 'in progress';
                } else {
                  statusController.text = value;
                }
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
              await createTask(ownerUserid: userID);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(true);
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
