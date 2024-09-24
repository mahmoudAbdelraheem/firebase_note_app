import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_fire/data/datasources/auth/firebase_user_auth.dart';
import 'package:flutter_fire/firebase_options.dart';
import 'package:flutter_fire/logic/auth/auth_bloc.dart';
import 'package:flutter_fire/logic/home/home_bloc.dart';
import 'package:flutter_fire/logic/note/note_bloc.dart';
import 'package:flutter_fire/repositories/auth/user_auth_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initDependancies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  _initAuth();
  _initHome();
  _initNote();
}

void _initAuth() {
  sl.registerFactory<FirebaseUserAuth>(
    () => FirebaseUserAuthImpl(),
  );

  sl.registerFactory<UserAuthRepository>(
    () => UserAuthRepositoryImpl(
      firebaseUserAuth: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => AuthBloc(
      userAuthRepository: sl(),
    ),
  );
}

void _initHome(){
  sl.registerLazySingleton(()=>HomeBloc());
}
void _initNote(){
  sl.registerFactory(()=>NoteBloc());
}