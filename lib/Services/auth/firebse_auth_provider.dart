import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_management_app/Services/auth/auth_exceptions.dart';
import 'package:task_management_app/Services/auth/auth_provider.dart';
import 'package:task_management_app/Services/auth/auth_user.dart';
import 'package:task_management_app/firebase_options.dart';

class FirebaseAuthProvider implements AuthProvider {
  /// La méthode initialize initialise l'API Firebase avec les options par défaut pour la plateforme actuelle.
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  /// La méthode createUser crée un nouvel utilisateur avec l'adresse email et le mot de passe spécifiés en utilisant l'API Firebase. Si l'utilisateur est créé avec succès, cette méthode renvoie une instance de [AuthUser] représentant le nouvel utilisateur créé.
  ///Si une erreur se produit pendant la création de l'utilisateur, cette méthode lance une exception correspondante. Les exceptions possibles sont [WeakPasswordAuthException] si le mot de passe fourni est trop faible,[ EmailAlreadyInUseAuthException] si l'adresse email est déjà utilisée par un autre utilisateur, [InvalidEmailAuthException] si l'adresse email fournie est invalide, ou [GenericAuthException] pour toutes les autres erreurs.

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  /// ==========================================================================

  /// la méthode currentUser, elle retourne un objet de type AuthUser qui représente l'utilisateur actuellement authentifié. Elle utilise la méthode [FirebaseAuth.instance.currentUser] pour récupérer l'utilisateur actuel, puis elle appelle la méthode statique AuthUser.fromFirebase pour convertir l'utilisateur Firebase en utilisateur personnalisé AuthUser.
  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

//// ===========================================================================
  ///
  /// la méthode logIn, elle prend en paramètres l'e-mail et le mot de passe de l'utilisateur et renvoie l'utilisateur authentifié sous forme d'objet AuthUser. Elle utilise la méthode [FirebaseAuth.instance.signInWithEmailAndPassword] pour effectuer la connexion avec les identifiants fournis, puis elle utilise la méthode currentUser pour récupérer l'utilisateur connecté et le convertir en objet [AuthUser]. Si une erreur se produit pendant le processus de connexion, elle la gère en levant une exception personnalisée correspondante en fonction du type d'erreur Firebase renvoyé. Si une erreur imprévue se produit, elle lève une exception générique <(GenericAuthException)>.
  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  /// ============================================================================
  ///
  /// La méthode déconnecte l'utilisateur actuellement connecté en utilisant l'API de Firebase Auth. Elle lance une exception [UserNotLoggedInAuthException] si aucun utilisateur n'est connecté. La méthode ne renvoie rien, mais utilise une future pour indiquer quand la déconnexion est terminée.
  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  /// ===========================================================================

  /// La méthode sendEmailVerification envoie un e-mail de vérification à l'utilisateur connecté. Si l'utilisateur n'est pas connecté, la méthode lance une exception de type [UserNotLoggedInAuthException].
  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
