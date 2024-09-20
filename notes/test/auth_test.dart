import 'package:flutter/foundation.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<IsNotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)));

    test('Create user should delegate to login function', () async {
      await provider.initialize();
     // expect(badCredentialsUser,throwsA(isA<InvalidCredentialsException>()));
      expect(() async =>  await provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      ), throwsA(isA<InvalidCredentialsException>()));
    });

    test('Create user should delegate to login function', () async {
      await provider.initialize();
      expect(() async => await provider.createUser(
        email: 'a@b.com',
        password: 'foobar',
      ),
          throwsA(const TypeMatcher<InvalidCredentialsException>()));
    });

      test('Create user should delegate to login function', () async {
      final user = await provider.createUser(
        email: 'a@b.com',
        password: 'foobarbaz',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'a@b.com', password: 'foobarbaz');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class IsNotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  AuthUser? _user;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw IsNotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw IsNotInitializedException();
    if (email == 'foo@bar.com') throw InvalidCredentialsException();
    if (password == 'foobar') throw InvalidCredentialsException();
    const user = AuthUser(email: 'foo@bar.com', isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw IsNotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw IsNotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInException();
    const newUser = AuthUser(email: 'foo@bar.com', isEmailVerified: true);
    _user = newUser;
    return Future.value();
  }
}
