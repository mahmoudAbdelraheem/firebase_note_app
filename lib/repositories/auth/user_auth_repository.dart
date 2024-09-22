import 'package:flutter_fire/data/datasources/auth/firebase_user_auth.dart';

abstract class UserAuthRepository {
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<bool> login({
    required String email,
    required String password,
  });
  Future<bool> loginWithGoogle();
  
}

class UserAuthRepositoryImpl implements UserAuthRepository {
  final FirebaseUserAuth firebaseUserAuth;

  UserAuthRepositoryImpl({required this.firebaseUserAuth});
  @override
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await firebaseUserAuth.signUp(
      name,
      email,
      password,
    );
  }
  
  @override
  Future<bool> login({required String email, required String password})async {
    return await firebaseUserAuth.login(email, password);
  }
  
  @override
  Future<bool> loginWithGoogle()async {
    return await firebaseUserAuth.loginWithGoogle();
  }
}
