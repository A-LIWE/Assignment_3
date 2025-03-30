import 'package:flutter/material.dart';

void main() => runApp(const HomeView());

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.directions_car),
            icon: Icon(Icons.directions_car_outlined),
            label: 'Fordon',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_parking),
            icon: Icon(Icons.local_parking_outlined),
            label: 'Starta parkering',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.timer),
            icon: Icon(Icons.timer_outlined),
            label: 'Aktiva',
          ),
        ],
      ),
      body: <Widget>[
        // Fordonshantering vy
        Center(
          child: Text(
            'Fordonshantering',
            style: theme.textTheme.titleLarge,
          ),
        ),
        // Starta parkering vy
        Center(
          child: Text(
            'Starta parkering',
            style: theme.textTheme.titleLarge,
          ),
        ),
        // Aktiva parkeringar vy
        Center(
          child: Text(
            'Aktiva parkeringar',
            style: theme.textTheme.titleLarge,
          ),
        ),
      ][currentPageIndex],
    );
  }
}