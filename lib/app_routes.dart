import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/core/app_constants.dart';
import 'package:flutter_fire/init_dependancies.dart';
import 'package:flutter_fire/logic/auth/auth_bloc.dart';
import 'package:flutter_fire/logic/home/home_bloc.dart';
import 'package:flutter_fire/presentation/screens/auth/login_screen.dart';
import 'package:flutter_fire/presentation/screens/auth/sign_up_screen.dart';
import 'package:flutter_fire/presentation/screens/home_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstants.homeScreen:
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => sl<HomeBloc>()..add(HomeGetDataEvent()),
              child: const HomeScreen(),
            );
          },
        );

      case AppConstants.loginScreen:
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: const LoginScreen(),
            );
          },
        );

      case AppConstants.signUpScreen:
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => sl<AuthBloc>(),
              child: const SignUpScreen(),
            );
          },
        );
      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          },
        );
    }
  }
}
