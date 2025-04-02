import 'package:flutter/material.dart';
import 'package:parking_user/views/home_view.dart';
import 'package:parking_user/views/registration_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'registration_view.dart';

/* class LoginView extends StatelessWidget {
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
} */


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController personalNumberController = TextEditingController();

  Future<void> _login() async {
    final personalNumber = personalNumberController.text.trim();
    if (personalNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Var god ange personnummer")),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('persons')
          .select()
          .eq('personal_number', personalNumber)
          .maybeSingle();

          if (!mounted) return;

      // Kontrollera om response är null eller tom (det vill säga, användaren finns inte)
      if (response == null || (response.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Användare hittades inte")),
        );
      } else {
        // Användaren hittades, navigera vidare
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fel vid inloggning: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(('Välkommen till Sveriges\nbästa parkeringsapp...typ')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: personalNumberController,
              decoration: const InputDecoration(
                labelText: 'Personnummer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
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