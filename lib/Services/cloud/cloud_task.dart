import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:task_management_app/Services/cloud/cloud_storage_constants.dart';

@immutable
class CloudTask {
  final String documentId;
  final String ownerUserid;
  final String taskDesc;
  final String taskTitle;
  final String taskDate;
  final String taskStatus;

  const CloudTask({
    required this.documentId,
    required this.ownerUserid,
    required this.taskDesc,
    required this.taskTitle,
    required this.taskDate,
    required this.taskStatus,
  });

  CloudTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id as String,
        ownerUserid = snapshot.data()[owner] as String,
        taskTitle = snapshot.data()[tasktitle] as String,
        taskDesc = snapshot.data()[taskdesc] as String,
        taskStatus = snapshot.data()[taskstatus] as String,
        taskDate = snapshot.data()[taskdate] as String;
}
