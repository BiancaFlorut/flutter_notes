
//login exceptions
class InvalidCredentialsException implements Exception {}
class LoginFailedException implements Exception {}

//register exceptions

class WeakPasswordException implements Exception {}
class EmailAlreadyInUseException implements Exception {}
class InvalidEmailException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}
class UserNotLoggedInException implements Exception {}
class UserNotFoundException implements Exception {}