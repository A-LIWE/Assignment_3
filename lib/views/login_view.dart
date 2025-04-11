import 'package:flutter/material.dart';
import 'package:parking_user/main.dart';
import 'package:parking_user/views/home_view.dart';
import 'package:parking_user/views/registration_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController personalNumberController =
      TextEditingController();

  Future<void> _login() async {
    final personalNumber = personalNumberController.text.trim();
    if (personalNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Var god ange personnummer")),
      );
      return;
    }

    try {
      final response =
          await Supabase.instance.client
              .from('persons')
              .select()
              .eq('personal_number', personalNumber)
              .maybeSingle();

      if (!mounted) return;

      // Kontrollera om användaren finns
      if (response == null || (response.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Användare hittades inte")),
        );
      } else {
        // Användaren hittades, ta med användarens id och navigera vidare
        final userData = response;
        final String userPersonalNumber = userData['personal_number'];
        final String userName = userData['name'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeView(
                  userPersonalNumber:
                      userPersonalNumber,
                  userName: userName,
                  toggleTheme: myAppKey.currentState!.toggleTheme,
                ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fel vid inloggning: $error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ('Välkommen till Sveriges\nbästa parkeringsapp...typ'),
        ),
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
            ElevatedButton(onPressed: _login, child: const Text('Logga in')),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationView(),
                  ),
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
