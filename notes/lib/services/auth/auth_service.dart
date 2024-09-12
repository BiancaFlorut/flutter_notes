import 'auth_provider.dart';
import 'auth_user.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> logOut() => provider.logOut();

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
}
