import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthUser {
  final String email;
  final bool isEmailVerified;
  final String id;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
