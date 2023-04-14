/// Une exception qui est levée si un utilisateur avec l'adresse e-mail spécifiée n'est pas trouvé lors de la tentative de connexion.
class UserNotFoundAuthException implements Exception {}

/// Une exception qui est levée si un mot de passe incorrect est fourni lors de la tentative de connexion.
class WrongPasswordAuthException implements Exception {}

// Les classes suivantes sont des exceptions pour les erreurs qui peuvent se produire lors de la création d'un nouveau compte utilisateur/

///  Une exception qui est levée si l'adresse e-mail fournie lors de la création d'un nouveau compte est déjà utilisée par un autre compte utilisateur.
class WeakPasswordAuthException implements Exception {}

/// eUune exception qui est levée si l'adresse e-mail fournie lors de la création d'un nouveau compte est invalide.
class EmailAlreadyInUseAuthException implements Exception {}

/// Une exception qui est levée si l'adresse e-mail fournie lors de la création d'un nouveau compte est invalide.
class InvalidEmailAuthException implements Exception {}

/// une exception qui est levée si l'utilisateur n'est pas connecté au moment où une action qui nécessite une connexion utilisateur est tentée.
class UserNotLoggedInAuthException implements Exception {}

/// Une exception qui est levée pour toute autre erreur qui ne correspond pas aux exceptions spécifiques mentionnées ci-dessus.
class GenericAuthException implements Exception {}
