import 'package:flutter/material.dart';

class VehiclesView extends StatefulWidget {
  const VehiclesView({super.key});

  @override
  State<VehiclesView> createState() => _VehiclesViewState();
}

class _VehiclesViewState extends State<VehiclesView> {
  // Temporär lista med fordon. Vid senare integration med Supabase hämtar du datan härifrån.
  List<String> vehicles = ['Volvo XC90', 'Audi A4', 'BMW 3 Series'];

  // Metod för att lägga till ett nytt fordon
  void addVehicle(String vehicle) {
    setState(() {
      vehicles.add(vehicle);
    });
  }

  // Metod för att redigera ett fordon
  void editVehicle(int index, String newVehicle) {
    setState(() {
      vehicles[index] = newVehicle;
    });
  }

  // Metod för att radera ett fordon
  void deleteVehicle(int index) {
    setState(() {
      vehicles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fordonshantering'),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(vehicles[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Knapp för att redigera fordonet
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Här kan du öppna en dialog eller navigera till en redigeringssida
                    // För demoändamål redigerar vi fordonets namn direkt
                    editVehicle(index, '${vehicles[index]} (Redigerat)');
                  },
                ),
                // Knapp för att radera fordonet
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteVehicle(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Här kan du öppna en dialog eller navigera till en sida för att lägga till ett nytt fordon
          // För demoändamål lägger vi till ett nytt fordon med ett genererat namn
          addVehicle('Nytt Fordon ${vehicles.length + 1}');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}