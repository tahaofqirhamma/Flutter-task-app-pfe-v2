import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_storage_exceptions.dart';
import 'package:task_management_app/Services/cloud/tasks/cloud_task.dart';

import 'cloud_storage_constants.dart';

class FirebaseCloudStorage {
  final tasks = FirebaseFirestore.instance.collection('tasks');

  Future<CloudTask> createTask({required String ownerUserid}) async {
    final document = await tasks.add({
      owner: ownerUserid,
      tasktitle: '',
      taskdesc: '',
      taskstatus: '',
      taskdate: '',
    });

    final fetchedTask = await document.get();

    return CloudTask(
      documentId: fetchedTask.id,
      ownerUserid: ownerUserid,
      taskDesc: '',
      taskTitle: '',
      taskDate: '',
      taskStatus: '',
    );
  }

  Future<void> updateTask(CloudTask updatedTask) async {
    try {
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

  Future<void> deleteTask({required String documentId}) async {
    try {
      await tasks.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTaskException();
    }
  }

  Future<Iterable<CloudTask>> getTasks({required String ownerUserid}) async {
    try {
      return await tasks
          .where(
            ownerUserid,
            isEqualTo: owner,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudTask.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllTasksException();
    }
  }

  Future<Iterable<CloudTask>> getSpecificTasks({required String status}) async {
    try {
      return tasks
          .where(
            taskstatus,
            isEqualTo: status,
          )
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudTask.fromSnapshot(doc)));
    } catch (e) {
      throw CouldNotGetSpecificTaskException();
    }
  }

  Stream<Iterable<CloudTask>> allTasks({required String ownerUserid}) =>
      tasks.snapshots().map((event) => event.docs
          .map(
            (doc) => CloudTask.fromSnapshot(doc),
          )
          .where((task) => task.ownerUserid == ownerUserid));

  factory FirebaseCloudStorage() => _shared;
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
}
