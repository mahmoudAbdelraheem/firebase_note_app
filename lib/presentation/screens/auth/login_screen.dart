import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/core/app_constants.dart';
import 'package:flutter_fire/core/widgets/loader.dart';
import 'package:flutter_fire/logic/auth/auth_bloc.dart';
import 'package:flutter_fire/presentation/widgets/auth/custom_button.dart';
import 'package:flutter_fire/presentation/widgets/auth/custom_text_form_field.dart';

import '../../widgets/auth/app_logo.dart';
import '../../widgets/auth/forget_password_text.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              if (FirebaseAuth.instance.currentUser!.emailVerified) {
                Navigator.of(context).pushReplacementNamed(AppConstants.homeScreen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please verify your email')),
                );
              }
            } else if (state is AuthLoginWithGoogleSuccessState) {
              Navigator.of(context).pushReplacementNamed(AppConstants.homeScreen);
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _loginKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const AppLogo(),
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 20.0),
                    child: Text(
                      'Login to continue using the app',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Text('Email'),
                  CustomTextFormField(
                    myController: emailController,
                    hintTxt: 'email',
                  ),
                  const Text('Password'),
                  CustomTextFormField(
                    myController: passwordController,
                    hintTxt: 'password',
                  ),
                  ForgetPasswordText(
                    onPressed: () async {
                      if (emailController.text.isNotEmpty) {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please check your email to reset password',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter your email to reset password',
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  state is AuthLoadingState
                      ? const Loader()
                      : CustomButton(
                          onTap: () {
                            print('cliked');
                            if (_loginKey.currentState!.validate()) {

                              BlocProvider.of<AuthBloc>(context).add(
                                AuthLoginEvent(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                          text: 'Login',
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('don\'t have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context,  AppConstants.signUpScreen);
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        padding: const EdgeInsets.all(10),
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(
                            AuthLoginWithGoogleEvent(),
                          );
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage('assets/images/google.png'),
                        ),
                      ),
                      MaterialButton(
                        padding: const EdgeInsets.all(10),
                        onPressed: () {},
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              AssetImage('assets/images/facebook.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
