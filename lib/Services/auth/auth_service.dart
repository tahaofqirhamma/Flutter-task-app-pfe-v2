import 'package:task_management_app/Services/auth/auth_user.dart';
import 'package:task_management_app/Services/auth/firebse_auth_provider.dart';
import 'package:task_management_app/services/auth/auth_provider.dart';

/// Représente un service d'authentification qui délègue l'authentification à un fournisseur

class AuthService implements AuthProvider {
  /// Le fournisseur qui gère l'authentification.
  final AuthProvider provider;

  ///Crée une nouvelle instance de [AuthService] qui délègue l'authentification au fournisseur spécifié.

  const AuthService(this.provider);

  /// Crée une nouvelle instance de [AuthService] qui délègue l'authentification à un fournisseur d'authentification Firebase.

  factory AuthService.firebase() =>
      AuthService(FirebaseAuthProvider() as AuthProvider);

  ///La méthode createUser crée un nouvel utilisateur avec l'adresse e-mail et le mot de passe spécifiés. Cette méthode délègue la création de l'utilisateur au fournisseur d'authentification spécifié lors de la création de cette instance de AuthService
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async =>
      provider.createUser(
        email: email,
        password: password,
      );

  ///Récupère l'utilisateur actuellement connecté, s'il y en a un.
  @override
  AuthUser? get currentUser => provider.currentUser;

  ///La méthode logIn connecte un utilisateur avec l'adresse e-mail et le mot de passe spécifiés. Cette méthode délègue la connexion de l'utilisateur au fournisseur d'authentification spécifié lors de la création de cette instance de AuthService.
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  /// La méthode logOut déconnecte l'utilisateur actuellement connecté. Cette méthode délègue la déconnexion de l'utilisateur au fournisseur d'authentification spécifié lors de la création de cette instance de AuthService.
  @override
  Future<void> logOut() => provider.logOut();

  /// La méthode sendEmailVerification envoie un e-mail de vérification à l'utilisateur actuellement connecté. Cette méthode délègue l'envoi de l'e-mail de vérification à la méthode sendEmailVerification du fournisseur d'authentification spécifié lors de la création de cette instance de AuthService.
  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  /// La méthode initialize initialise le fournisseur d'authentification spécifié lors de la création de cette instance de AuthService. Cette méthode délègue l'initialisation du fournisseur d'authentification à la méthode initialize du fournisseur d'authentification sous-jacent.
  @override
  Future<void> initialize() => provider.initialize();
}
