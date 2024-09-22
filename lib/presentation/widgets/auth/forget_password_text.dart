import 'package:flutter/material.dart';

class ForgetPasswordText extends StatelessWidget {
  final VoidCallback onPressed;
  const ForgetPasswordText({
    super.key, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
