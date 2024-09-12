import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  factory AuthService.firebase() {
    return AuthService(FirebaseAuthProvider());
  }

  const AuthService(this.provider);

  @override
  Future<void> logOut() => provider.logOut();


  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) => provider.createUser(email: email, password: password);

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) => provider.logIn(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() {
    return provider.initialize();
  }
}
