import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable

/// Class qui représente un utilisateur authentifié.
class AuthUser {
  ///  Adresse e-mail de l'utilisateur, ou null s'il n'en a pas fourni.
  final String? email;

  /// Indique si l'adresse e-mail de l'utilisateur a été vérifiée.
  final bool isEmailVerified;

  /// Constructeur du class.
  const AuthUser({required this.isEmailVerified, required this.email});

  /// Crée une instance d'AuthUser à partir d'un utilisateur Firebase.
  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email,
      );
}
