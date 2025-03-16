import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/auth/widgets/input_field.dart';
import 'package:frontend/auth/widgets/password_field.dart';
import 'package:frontend/core/widgets/loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );

  @override
  void dispose() {
    print('login disposed');
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple.shade600.withAlpha(100),
        elevation: 2.0,
        centerTitle: true,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          /*
          
          display fields and screen only if state is auth initial or a Failure else show a loader 
          save resources while changing state
          This will help reducing re render of widgets when state is changing
          
          */

          if (state is AuthInitial || state is AuthFailure) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 26.0,
                bottom: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20.0,
                  children: [
                    Image.asset("assets/images/register.png", height: 80),

                    // Email Field
                    InputField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
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
                      controller: _passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        } else if (value.length < 5) {
                          return "Password must be at least 5 characters";
                        }
                        return null;
                      },
                      labelText: 'Password',
                      hintText: 'Enter your password',
                    ),

                    // Submit Button
                    ElevatedButton(
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
                        BlocProvider.of<AuthBloc>(context).add(
                          OnLoginButtonPressed(
                            context: context,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ),
            );
          }
          /*
          
          show loader for loading 
          
           */
          else {
            return const Loader();
          }
        },
      ),
    );
  }
}
