import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:task_management_app/Services/auth/auth_service.dart';
import 'package:task_management_app/Services/cloud/user/cloud_user_constants.dart';
import 'package:task_management_app/Services/cloud/user/cloud_user_exceptions.dart';

@immutable
class CloudUser {
  final String userId;
  final String email;
  final String username;

  const CloudUser({
    required this.userId,
    required this.email,
    required this.username,
  });

  CloudUser.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : userId = AuthService.firebase().currentUser!.id,
        email = AuthService.firebase().currentUser!.email,
        username = snapshot.data()[userName] as String;
}

Future<void> updateUser(CloudUser updatedUser, String password) async {
  try {
    final tasks = FirebaseFirestore.instance.collection('user');

    await tasks.doc(updatedUser.userId).update({
      eamil: updatedUser.email,
      userName: updatedUser.username,
    });
    final updateduser = AuthService.firebase().currentUser;
    if (updateduser != null) {
      await AuthService.firebase().updateEmail(email: updatedUser.email);
      await AuthService.firebase().updatePassword(password: password);
      await AuthService.firebase().sendEmailVerification();
    }
  } catch (e) {
    throw CouldNotUpdateUserException();
  }
}
