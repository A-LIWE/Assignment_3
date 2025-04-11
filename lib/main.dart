import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/login_view.dart';

final GlobalKey<MyAppState> myAppKey = GlobalKey<MyAppState>();
final supabase = Supabase.instance.client;

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ywvoteqcrohgusjawaqg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dm90ZXFjcm9oZ3VzamF3YXFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAxNDM3NjUsImV4cCI6MjA1NTcxOTc2NX0.3mnwht5XOgYNM6Zn5qK-qft_5FJZvTtP-13AggbUycw',
  );
  runApp(MyApp(key: myAppKey));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Startar med systemets tema (kan vara ljus eller mörkt beroende på enhetens inställningar)
  ThemeMode _themeMode = ThemeMode.system;
  
  /// Toggle för att växla mellan dark och light mode.
  void toggleTheme() {
    setState(() {
      _themeMode =
          (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking User',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: const LoginView(),
    );
  }
}