import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ParkingProcessState { selectParkingSpace, selectVehicle }

class StartParkingView extends StatefulWidget {
  const StartParkingView({super.key});

  @override
  State<StartParkingView> createState() => _StartParkingViewState();
}

class _StartParkingViewState extends State<StartParkingView> {
  ParkingProcessState _currentState = ParkingProcessState.selectParkingSpace;

  // Dummy-data för lediga parkeringsplatser.
  final List<String> parkingSpaces = [
    'Parkeringsplats A',
    'Parkeringsplats B',
    'Parkeringsplats C',
  ];

  // Dummy-data för användarens fordon.
  final List<String> vehicles = [
    'Volvo XC90',
    'Audi A4',
    'BMW 3 Series',
  ];

  String? _selectedParkingSpace;
  String? _selectedVehicle;
  DateTime? _startTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starta parkering'),
      ),
      body: _buildCurrentState(),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case ParkingProcessState.selectParkingSpace:
        return _buildParkingSpaceSelection();
      case ParkingProcessState.selectVehicle:
        return _buildVehicleSelection();
    }
  }

  Widget _buildParkingSpaceSelection() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: parkingSpaces.length,
            itemBuilder: (context, index) {
              String space = parkingSpaces[index];
              bool isSelected = _selectedParkingSpace == space;
              return ListTile(
                title: Text(space),
                trailing: isSelected ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() {
                    _selectedParkingSpace = space;
                  });
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _selectedParkingSpace == null
                ? null
                : () {
                    setState(() {
                      _currentState = ParkingProcessState.selectVehicle;
                    });
                  },
            child: const Text('Starta parkering'),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleSelection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Välj ditt fordon:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              String vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle),
                onTap: () {
                  setState(() {
                    _selectedVehicle = vehicle;
                    _startTime = DateTime.now();
                  });
                  // Formatera tiden med intl-paketet
                  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
                  String formattedTime =
                      formatter.format(_startTime ?? DateTime.now());

                  // Visa SnackBar (toaster) med bekräftelseinformation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Parkering startad!\n'
                        'Parkeringsplats: $_selectedParkingSpace\n'
                        'Fordon: $_selectedVehicle\n'
                        'Starttid: $formattedTime',
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  );

                  // Återställ till första steget (om det passar din logik)
                  setState(() {
                    _selectedParkingSpace = null;
                    _selectedVehicle = null;
                    _startTime = null;
                    _currentState = ParkingProcessState.selectParkingSpace;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}