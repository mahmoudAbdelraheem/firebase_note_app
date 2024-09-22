import 'package:flutter/material.dart';
import 'package:flutter_fire/presentation/widgets/auth/custom_button.dart';
import 'package:flutter_fire/presentation/widgets/auth/custom_text_form_field.dart';

class AddCategoryBottomSheet extends StatelessWidget {
  final TextEditingController categoryController;
  final VoidCallback onTap;
  const AddCategoryBottomSheet({
    super.key,
    required this.categoryController, required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          isScrollControlled:
              true, // This allows the sheet to adjust to the keyboard
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                // Adjust the bottom padding to avoid being overlapped by the keyboard
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust the sheet to content size
                  children: [
                    const Text(
                      'Add new Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      hintTxt: 'Category',
                      myController: categoryController,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Add',
                        onTap: onTap,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
