import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable

/// Class qui représente un utilisateur authentifié.
class AuthUser {
  //  identifiant d'utilisateur.
  final String id;

  ///  Adresse e-mail de l'utilisateur.
  final String email;

  /// Indique si l'adresse e-mail de l'utilisateur a été vérifiée.
  final bool isEmailVerified;

  /// Constructeur du class.
  const AuthUser({
    required this.isEmailVerified,
    required this.email,
    required this.id,
  });

  /// Crée une instance d'AuthUser à partir d'un utilisateur Firebase.
  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email!,
        id: user.uid,
      );
}
