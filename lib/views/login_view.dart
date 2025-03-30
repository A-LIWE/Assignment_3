import 'package:flutter/material.dart';
import 'package:parking_user/views/home_view.dart';
import 'registration_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Välkommen till Sveriges\nbästa parkeringsapp...typ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emailfält
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Lösenordsfält
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Lösenord',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            // Logga in-knapp
           ElevatedButton(
  onPressed: () {
    // Placera din inloggningslogik här.
    // Vid lyckad inloggning, navigera till HomeScreen:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  },
  child: const Text('Logga in'),
),
            const SizedBox(height: 16),
            // Navigering till registreringsvyn
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationView()),
                );
              },
              child: const Text('Registrera dig'),
            ),
          ],
        ),
      ),
    );
  }
}