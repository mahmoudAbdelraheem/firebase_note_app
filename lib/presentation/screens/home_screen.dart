import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/core/app_constants.dart';
import 'package:flutter_fire/core/widgets/loader.dart';
import 'package:flutter_fire/logic/home/home_bloc.dart';
import 'package:flutter_fire/presentation/widgets/home/add_category_bottom_sheet.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:animate_do/animate_do.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController categoryController = TextEditingController();
  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed(
                  AppConstants.loginScreen,
                );
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: AddCategoryBottomSheet(
        categoryController: categoryController,
        onTap: () {
          if (categoryController.text.isNotEmpty) {
            BlocProvider.of<HomeBloc>(context).add(
              HomeAddCategoryEvent(
                category: categoryController.text,
              ),
            );
            categoryController.clear();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Category added successfully'),
              ),
            );
          }
        },
      ),
      body: BlocConsumer<HomeBloc, HomeState>(listener: (_, state) {
        if (state is HomeErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is HomeDeleteCategorySuccessState ||
            state is HomeAddCategorySuccessState) {
          BlocProvider.of<HomeBloc>(context).add(HomeGetDataEvent());
        }
      }, builder: (_, state) {
        if (state is HomeGetDataSuccessState) {
          if (state.categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found yet!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: state.categories.length,
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppConstants.notesScreen,
                      arguments: {
                        "category": state.categories[index]['name'],
                        "id": state.categories[index].id
                      });
                },
                onLongPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Delete Category',
                    desc: 'Are you sure you want to delete this category?',
                    btnOkOnPress: () {
                      BlocProvider.of<HomeBloc>(context).add(
                        HomeDeleteCategoryEvent(
                          categoryId: state.categories[index].id,
                        ),
                      );
                    },
                  ).show();
                },
                child: FadeInUp(
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.orange,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/folder_img.png',
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                        Text(
                          state.categories[index]['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is HomeLoadingState) {
          return const Loader();
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}
