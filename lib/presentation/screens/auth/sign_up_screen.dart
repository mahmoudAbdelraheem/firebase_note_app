import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/core/app_constants.dart';
import 'package:flutter_fire/core/widgets/loader.dart';
import 'package:flutter_fire/logic/auth/auth_bloc.dart';
import 'package:flutter_fire/presentation/widgets/auth/custom_button.dart';
import 'package:flutter_fire/presentation/widgets/auth/custom_text_form_field.dart';

import '../../widgets/auth/app_logo.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
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
              Navigator.of(context)
                  .pushReplacementNamed(AppConstants.loginScreen);
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _signUpKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const AppLogo(),
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 20.0),
                    child: Text(
                      'Sign Up, to continue using the app',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Text('Name'),
                  CustomTextFormField(
                    myController: nameController,
                    hintTxt: 'name',
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
                  const SizedBox(height: 20),
                  state is AuthLoadingState
                      ? const Loader()
                      : CustomButton(
                          onTap: () {
                            if (_signUpKey.currentState!.validate()) {
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthSignUpEvent(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            }
                          },
                          text: 'Sign Up',
                        ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppConstants.loginScreen,
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
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
