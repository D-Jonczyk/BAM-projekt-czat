import 'package:bam_projekt/screens/chat_screen.dart';
import 'package:flutter/material.dart';

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

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Hasło',
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          child: const Text('Zaloguj się'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
      ],
    );
  }
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 20.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Email',
          ),
        ),
        const SizedBox(height: 20.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Hasło',
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20.0),
        ElevatedButton(
          child: const Text('Zarejestruj się'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
      ],
    );
  }
}
