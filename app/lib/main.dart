import 'package:bam_projekt/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bam_projekt/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showLogin ? 'Logowanie' : 'Rejestracja'),
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.swap_horiz),
            label: Text(showLogin ? 'Rejestracja' : 'Logowanie'),
            onPressed: toggleView,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: showLogin ? const Login() : const Register(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      // Send login request
      final response = await http.post(
        Uri.parse('${Config.serverAddress}/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {  // For login
        final responseData = jsonDecode(response.body);
        final int userId = responseData['user_id'];
        final String username = responseData['username']; // Assuming the username is returned by your backend

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(userId: userId, username: username)),
        );
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Username'),
            validator: (val) => val!.isEmpty ? 'Enter a username' : null,
            onChanged: (val) {
              setState(() => username = val);
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
            onChanged: (val) {
              setState(() => password = val);
            },
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: _loginUser,
          ),
        ],
      ),
    );
  }
}


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Send registration request
      final response = await http.post(
        Uri.parse('${Config.serverAddress}/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {  // For registration
        final responseData = jsonDecode(response.body);
        final int userId = responseData['user_id'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(userId: userId, username: username)),
        );
      } else {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Username'),
            validator: (val) => val!.isEmpty ? 'Enter a username' : null,
            onChanged: (val) {
              setState(() => username = val);
            },
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: const InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
            onChanged: (val) {
              setState(() => password = val);
            },
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            child: const Text('Register'),
            onPressed: _registerUser,
          ),
        ],
      ),
    );
  }
}

