//import 'package:logger/logger.dar';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:parking_user/repositories/repositories.dart';
import 'package:parking_user/models/models.dart';
import 'package:parking_user/views/vehicles_view.dart';


class StartParkingView extends StatefulWidget {
  const StartParkingView({super.key, required this.userPersonalNumber, required this.userName});

  // Vi antar här att du skickar med den inloggade användarens personalnummer samt namn.
  final String userPersonalNumber;
  final String userName;

  @override
  State<StartParkingView> createState() => _StartParkingViewState();
}

class _StartParkingViewState extends State<StartParkingView> {
  bool isLoading = false;
  List<ParkingSpace> parkingSpaces = [];
  List <Vehicle> vehicles = [];

  ParkingSpace? selectedSpace;
  Vehicle? selectedVehicle;

  @override
  void initState() {
    super.initState();
    _fetchParkingSpaces();
    _fetchVehicles();
  }

  Future<void> _fetchParkingSpaces() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Här hämtar vi parkeringsplatser via din repository-metod
      final parkingSpaceRepo = ParkingSpaceRepository();
      final data =
          await parkingSpaceRepo
              .getAll(); // data är en lista med ParkingSpace-objekt
      setState(() {
        parkingSpaces = data;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fel vid hämtning av parkeringsplatser: $error"),
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
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

  Future<void> _startParking() async {
    if (selectedSpace == null || selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vänligen välj både parkeringsplats och fordon.")),
      );
      return;
    }
    final startTime = DateTime.now();

    // Skapa en ny ParkingSession med vald parkeringsplats, valt fordon och aktuell tid
    final newSession = ParkingSession(selectedVehicle!, selectedSpace!, startTime);

    try {
      await ParkingSessionRepository().add(newSession);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Parkering startad kl ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}")),
      );
      // Optionellt: återställ val eller navigera vidare
      setState(() {
        selectedSpace = null;
        selectedVehicle = null;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fel vid start av parkering: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Starta parkering"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Välj en ledig parkeringsplats:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: parkingSpaces.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final space = parkingSpaces[index];
                      return ListTile(
                        title: Text(
                          space.address,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text("Pris per timme: ${space.formattedPrice}"),
                        selected: selectedSpace == space,
                        onTap: () {
                          setState(() {
                            selectedSpace = space;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Välj vilket fordon du vill parkera med:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vehicles.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return ListTile(
                        title: Text(
                          vehicle.registrationNumber,
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Text(vehicle.vehicleType),
                        selected: selectedVehicle == vehicle,
                        onTap: () {
                          setState(() {
                            selectedVehicle = vehicle;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _startParking,
                      child: const Text(
                        "Starta parkering",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
