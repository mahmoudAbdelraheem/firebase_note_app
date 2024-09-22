import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController myController;
  final String hintTxt;
  const CustomTextFormField({
    super.key,
    required this.hintTxt,
    required this.myController,
  });

  @override

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: myController,
        validator: (val) {
          if (val!.isEmpty) {
            return '$hintTxt cannot be empty';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 25),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintTxt,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
