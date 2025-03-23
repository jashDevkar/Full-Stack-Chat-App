import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/auth/pages/login_page.dart';
import 'package:frontend/auth/widgets/image_section.dart';
import 'package:frontend/auth/widgets/input_field.dart';
import 'package:frontend/auth/widgets/password_field.dart';
import 'package:frontend/auth/widgets/pick_image.dart';
import 'package:frontend/auth/widgets/show_bottom_modal.dart';
import 'package:frontend/core/widgets/loader.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  @override
  void dispose() {
    print('register disposed');
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    imagePicked.dispose();
    super.dispose();
  }

  final ValueNotifier<File?> imagePicked = ValueNotifier<File?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade600.withAlpha(100),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print(state.runtimeType);

          //check state
          if (state is AuthLogedIn) {
            if (state.loginMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.loginMessage!)));
            }
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));

            BlocProvider.of<AuthBloc>(context).add(OnResetState());
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 25.0,
            bottom: 16.0,
          ),

          child: Form(
            key: _formKey,
            child: Column(
              spacing: 15.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ///image section and crop image section
                ValueListenableBuilder(
                  valueListenable: imagePicked,
                  builder: (context, image, child) {
                    return ImageSection(
                      image: image,
                      onPressed: () {
                        showBottomModal(
                          context: context,
                          onTap: (ImageSource source) async {
                            Navigator.pop(context);
                            XFile? pickedImage = await PickImage()
                                .pickImageFromSource(source);
                            if (pickedImage == null) return;
                            CroppedFile? croppedImage = await ImageCropper()
                                .cropImage(
                                  sourcePath: pickedImage.path,
                                  aspectRatio: const CropAspectRatio(
                                    ratioX: 1,
                                    ratioY: 1,
                                  ),
                                  uiSettings: [
                                    AndroidUiSettings(
                                      toolbarTitle: 'Crop Image',
                                      toolbarColor: Colors.deepPurple.shade600,
                                      toolbarWidgetColor: Colors.white,
                                      statusBarColor:
                                          Colors.deepPurple.shade600,
                                      backgroundColor: Colors.black,
                                    ),
                                  ],
                                );
                            if (croppedImage == null) return;
                            imagePicked.value = File(croppedImage.path);
                          },
                        );
                      },
                    );
                  },
                ),

                // Name Field
                InputField(
                  type: TextInputType.text,
                  controller: _nameController,
                  labelText: "Name",
                  hintText: "Enter your name",
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Name is required"
                              : null,
                ),

                // Email Field
                InputField(
                  controller: _emailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    } else if (!emailRegex.hasMatch(value)) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  type: TextInputType.emailAddress,
                ),

                // Password Field
                PasswordField(
                  hintText: "Enter a password",
                  labelText: "Password",
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 5) {
                      return "Password must be at least 5 characters";
                    }
                    return null;
                  },
                ),

                // Confirm Password Field
                PasswordField(
                  hintText: "Re-enter your password",
                  labelText: "Confirm password",
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Confirm Password is required";
                    } else if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                // Register Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 4.0,
                        backgroundColor: Colors.deepPurple.shade600.withAlpha(
                          200,
                        ),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        if (imagePicked.value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select an image"),
                            ),
                          );
                          return;
                        }
                        if (state is AuthLoading) {
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          BlocProvider.of<AuthBloc>(context).add(
                            OnRegisterButtonPressed(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              image: imagePicked.value!,
                            ),
                          );
                        }
                      },
                      child:
                          (state is AuthLoading)
                              ? const Loader()
                              : const Text("Register"),
                    );
                  },
                ),

                // Navigate to Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: LoginPage(),
                            ),
                          ),
                      child: const Text(
                        'Login instead',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
