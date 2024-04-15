import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication/authentication_bloc.dart';
class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue, // Set app bar background color
      ),
      body: BlocBuilder<AuthenticationBloc, AuthState>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // App Logo
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.account_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 32.0),

                    // Email text field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Password text field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      obscureText: true,
                    ),

                    SizedBox(height: 24.0),

                    // Register button
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthenticationBloc>(context).add(
                          RegisterEvent(
                            _emailController.text,
                            _passwordController.text,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('Register', style: TextStyle(fontSize: 16)),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue, // Set button background color
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Cancel button
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the registration screen
                      },
                      child: Text('Cancel', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

