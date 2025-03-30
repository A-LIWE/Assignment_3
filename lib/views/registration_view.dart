import 'package:flutter/material.dart';

class RegistrationView extends StatelessWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrera dig'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Namnfält
            TextField(
              decoration: const InputDecoration(
                labelText: 'Fullständigt namn',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
            // Registreringsknapp
            ElevatedButton(
              onPressed: () {
                // Registreringslogik här
              },
              child: const Text('Registrera'),
            ),
          ],
        ),
      ),
    );
  }
}