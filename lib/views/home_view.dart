import 'package:flutter/material.dart';
import 'vehicles_view.dart';
import 'start_parking_view.dart';
import 'manage_parkings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationMenu(),
    );
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
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
        const VehiclesView(),
        const StartParkingView(),
        const ManageParkingsView(),
      ][currentPageIndex],
    );
  }
}