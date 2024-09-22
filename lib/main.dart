import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/app_routes.dart';
import 'package:flutter_fire/core/app_constants.dart';
import 'package:flutter_fire/core/theme/app_theme.dart';
import 'package:flutter_fire/init_dependancies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependancies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('====================User is currently signed out!');
      } else {
        print('====================User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter firebase course',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
      initialRoute: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? AppConstants.homeScreen
          : AppConstants.loginScreen,
    );
  }
}
