// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_import, prefer_const_literals_to_create_immutables

import 'package:coding_task/state_management/cubit/login_cubit.dart';
import 'package:coding_task/state_management/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        builder: (context, state) {
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final screenHeight = mediaQuery.size.height;

          return Padding(
            padding: EdgeInsets.all(0.0),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 500, // Adjust max width as needed
                    ),
                    child: ScaffoldMessenger(
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Log in!',
                                    style: TextStyle(
                                      color: Color.fromARGB(
                                          255, 222, 99, 173), // Pink color
                                      fontWeight: FontWeight.bold, // Bold text
                                      fontSize:
                                          28, // Adjust font size if needed
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              TextField(
                                controller: _emailController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.alternate_email_sharp,
                                      color: Colors.white),
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              TextField(
                                controller: _passwordController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock_open_rounded,
                                      color: Colors.white),
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                obscureText: true,
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              if (state is LoginLoading)
                                CircularProgressIndicator()
                              else
                                ElevatedButton(
                                  style: TextButton.styleFrom(
                                    minimumSize: const Size(180, 45),
                                  ),
                                  onPressed: () {
                                    final cubit = context.read<LoginCubit>();
                                    cubit.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  },
                                  child: Text('Login'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
