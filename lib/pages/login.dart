import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/question.dart';
import '../models/user.dart';
import './main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final usersBox = Hive.box<User>('users');

    final user = usersBox.values.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => User(username: '', password: ''),
    );

    if (user.username.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(currentUser: username),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  void _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final usersBox = Hive.box<User>('users');

    if (usersBox.values.any((u) => u.username == username)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username already exists')));
      return;
    }

    usersBox.add(User(username: username, password: password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User registered successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _login, child: const Text('Login')),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                            'Are you sure you want to delete all data?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                  );

                  if (confirm == true) {
                    await Hive.box<User>('users').clear();
                    await Hive.box<Question>('questions').clear();
                    await Hive.box('quiz_scores').clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All data deleted')),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete All Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
