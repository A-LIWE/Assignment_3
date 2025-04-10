import 'package:flutter/material.dart';
import 'package:parking_user/repositories/repositories.dart';
import 'package:logger/logger.dart';
import 'package:parking_user/models/models.dart';

final logger = Logger();

class VehiclesView extends StatefulWidget {
  const VehiclesView({
    super.key,
    required this.userPersonalNumber,
    required this.userName,
  });

  final String userPersonalNumber;
  final String userName;

  @override
  State<VehiclesView> createState() => _VehiclesViewState();
}

class _VehiclesViewState extends State<VehiclesView> {
  List<Vehicle> vehicles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Skapa en instans av VehicleRepository
      final vehicleRepo = VehicleRepository();
      final data = await vehicleRepo.getAll(); // data är en lista med fordon
      // Filtrera fordon baserat på personnummer
      final filteredVehicles =
          data
              .where(
                (v) => v.owner?.personalNumber == widget.userPersonalNumber,
              )
              .toList();

      if (!mounted) return;

      if (data.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Inga fordon hittades")));
      } else {
        setState(() {
          vehicles = filteredVehicles;
        });
      }
    } catch (error, stackTrace) {
      logger.e(
        "Fel vid hämtning av fordon",
        error: error,
        stackTrace: stackTrace,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fel vid hämtning av fordon: $error")),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  // Raderar fordon baserat på fordonets registreringsnummer
  Future<void> _deleteVehicle(String registrationNumber) async {
    try {
      final vehicleRepo = VehicleRepository();
      final message = await vehicleRepo.delete(registrationNumber);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (error) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fel vid radering: $error")));
    }
  }

  Future<void> _addVehicle() async {
    String registrationNumber = "";
    String vehicleType = "";

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Lägg till nytt fordon"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Registreringsnummer",
                ),
                onChanged: (value) {
                  registrationNumber = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Fordonstyp"),
                onChanged: (value) {
                  vehicleType = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Avbryt dialogen
              },
              child: const Text("Avbryt"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                // Skapa ett nytt Vehicle-objekt.
                // Om du har data om den inloggade personen, sätt den som ägare, annars kan du sätta owner till null.
                final owner = Person(
                  widget.userName,
                  widget.userPersonalNumber,
                );
                final newVehicle = Vehicle(
                  registrationNumber,
                  vehicleType,
                  owner,
                );

                // Skapa en instans av VehicleRepository och lägg till fordonet
                final vehicleRepo = VehicleRepository();
                await vehicleRepo.add(newVehicle);

                // Uppdatera listan med fordon (du kan anropa din _fetchVehicles-metod)
                _fetchVehicles();
              },
              child: const Text("Lägg till"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mina fordon")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return Dismissible(
                    key: Key(vehicle.uuid),
                    direction: DismissDirection.endToStart,
                    // Bekräfta radering med en alertdialog innan fordonet tas bort
                    confirmDismiss: (direction) async {
                      return await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Radera fordon"),
                              content: Text(
                                "Är du säker på att du vill radera fordonet ${vehicle.registrationNumber}?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: const Text("Avbryt"),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(true),
                                  child: const Text("Radera"),
                                ),
                              ],
                            ),
                      );
                    },
                    onDismissed: (direction) async {
                      // Anropa din raderingslogik
                      await _deleteVehicle(vehicle.registrationNumber);
                      // Ta bort fordonet lokalt från listan
                      setState(() {
                        vehicles.removeAt(index);
                      });
                    },
                    // Ange en "tom" bakgrund för att inte visa någon färg i vänstra delen
                    background: Container(),
                    // secondaryBackground används för att visa bakgrund vid svepning från höger till vänster.
                    secondaryBackground: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: double.infinity,
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: ListTile(
                      title: Text(vehicle.registrationNumber),
                      subtitle: Text(vehicle.vehicleType),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton.extended(
  onPressed: _addVehicle,
  label: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Text(
        'Lägg till fordon',
        style: TextStyle(fontSize: 15), // justera textstorlek här
      ),
      SizedBox(width: 8),
      Icon(Icons.add),
    ],
  ),
),
    );
  }
}
