import 'package:flutter/material.dart';
import 'package:parking_user/repositories/repositories.dart';
import 'package:logger/logger.dart';
import 'package:parking_user/models/models.dart';


final logger = Logger();

class VehiclesView extends StatefulWidget {
  const VehiclesView({super.key, required this.userPersonalNumber});

  final String userPersonalNumber;
  

  @override
  State<VehiclesView> createState() => _VehiclesViewState();
}

class _VehiclesViewState extends State<VehiclesView> {
  List<Vehicle> vehicles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    debugPrint('widget.userId: ${widget.userPersonalNumber}');
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
    final filteredVehicles = data.where((v) => v.owner?.personalNumber == widget.userPersonalNumber).toList();

    if (!mounted) return;

    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inga fordon hittades")),
      );
    } else {
      setState(() {
        vehicles = filteredVehicles;
      });
    }
  } catch (error, stackTrace) {
    logger.e("Fel vid hämtning av fordon", error: error, stackTrace: stackTrace);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Fel vid hämtning av fordon: $error")),
  );
  }
  setState(() {
    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mina fordon'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                final registrationNumber = vehicle.registrationNumber;
                final vehicleType = vehicle.vehicleType;
                return ListTile(
                  title: Text(registrationNumber),
                  subtitle: Text(vehicleType),
                );
              },
            ),
    );
  }
}
