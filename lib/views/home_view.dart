import 'package:flutter/material.dart';
import 'vehicles_view.dart';
import 'start_parking_view.dart';
import 'manage_parkings_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key, 
    required this.userPersonalNumber, 
    required this.userName, 
    required this.toggleTheme,
  });

  final String userPersonalNumber;
  final String userName;
  final VoidCallback toggleTheme;

  @override
  Widget build(BuildContext context) {

    return NavigationMenu(
      userPersonalNumber: userPersonalNumber,
      userName: userName,
      toggleTheme: toggleTheme,
    );
  }
}

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key, required this.userPersonalNumber, required this.userName, required this.toggleTheme});

  final String userPersonalNumber;
  final String userName;
  final VoidCallback toggleTheme;

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
        VehiclesView(userPersonalNumber: widget.userPersonalNumber, userName: widget.userName,),
        StartParkingView(userPersonalNumber: widget.userPersonalNumber, userName: widget.userName,),
        ManageParkingsView(toggleTheme: widget.toggleTheme),
      ][currentPageIndex],
    );
  }
}