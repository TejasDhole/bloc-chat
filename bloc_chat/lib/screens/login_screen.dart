import 'package:bloc_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/authentication/authentication_bloc.dart';
import 'ChatListScreen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocBuilder<AuthenticationBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return _buildLoadingState();
          } else if (state is AuthFailure) {
            return _buildFailureState(context, state.errorMessage);
          } else if (state is AuthSuccess) {
            // Navigate to ChatListScreen if authentication succeeds
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatUserList()));
            });
            return _buildLoadingState();
          } else {
            // Show login UI if the authentication state is not handled
            return _buildLoginUI(context);
          }
        },
      ),
    );
  }

  // Widget to show loading state
  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  // Widget to show failure state with error message
// Widget to show failure state with error message
  Widget _buildFailureState(BuildContext context, String errorMessage) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())); // Navigate back to the login screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
    return Container(); // Return an empty container instead of the loading state
  }


  // Widget to build the login UI
  Widget _buildLoginUI(BuildContext context) {
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

              // Login button
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LoginEvent(
                      _emailController.text,
                      _passwordController.text,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Login', style: TextStyle(fontSize: 16)),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),

              SizedBox(height: 16.0),

              // Register button
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
                },
                child: Text('Create an Account', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
