import 'package:task_management_app/Services/auth/auth_user.dart';

/// Une classe abstraite AuthProvider définit un ensemble de méthodes qui doivent être implémentées par les fournisseurs d'authentification.
abstract class AuthProvider {
  ///La méthode initialize est utilisée pour initialiser l'authentification de Firebase.
  Future<void> initialize();

  ///La méthode currentUser est utilisée pour récupérer l'utilisateur connecté actuellement.
  AuthUser? get currentUser;

  ///La méthode logIn est utilisée pour connecter un utilisateur avec une adresse e-mail et un mot de passe donnés.
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });

  /// La méthode createUser est utilisée pour créer un nouvel utilisateur avec une adresse e-mail et un mot de passe donnés.
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  ///La méthode logOut est utilisée pour déconnecter l'utilisateur actuel.
  Future<void> logOut();

  /// La méthode sendEmailVerification est utilisée pour envoyer une vérification de courrier électronique à l'utilisateur connecté actuellement.
  Future<void> sendEmailVerification();
}
