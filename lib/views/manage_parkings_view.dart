import 'package:flutter/material.dart';

class ManageParkingsView extends StatefulWidget {
  const ManageParkingsView({super.key});

  @override
  State<ManageParkingsView> createState() => _ManageParkingsViewState();
}

class _ManageParkingsViewState extends State<ManageParkingsView> {
  // Dummy-data för aktiva parkeringar. Varje parkering representeras som en Map med unikt id, parkeringsplats, fordon och starttid.
  List<Map<String, String>> activeParkings = [
    {
      'id': '1',
      'parkingSpace': 'Parkeringsplats A',
      'vehicle': 'Volvo XC90',
      'startTime': '2023-04-01 08:00'
    },
    {
      'id': '2',
      'parkingSpace': 'Parkeringsplats B',
      'vehicle': 'Audi A4',
      'startTime': '2023-04-01 08:15'
    },
  ];

  // Dummy-data för historik (avslutade parkeringar)
  List<Map<String, String>> historicalParkings = [
    {
      'id': '3',
      'parkingSpace': 'Parkeringsplats C',
      'vehicle': 'BMW 3 Series',
      'startTime': '2023-03-31 10:00',
      'endTime': '2023-03-31 11:30'
    },
  ];

  // Metod för att avsluta en aktiv parkering
  void _endParking(String id) {
    setState(() {
      // Hitta parkeringen i aktiva listan och ta bort den
      final index = activeParkings.indexWhere((element) => element['id'] == id);
      if (index != -1) {
        final endedParking = activeParkings.removeAt(index);
        // Lägg till sluttid, här används DateTime.now() för demoändamål
        endedParking['endTime'] = DateTime.now().toString().substring(0, 16);
        historicalParkings.add(endedParking);
      }
    });
  }

  // Metod för att radera en historisk parkering
  void _deleteHistoricalParking(String id) {
    setState(() {
      historicalParkings.removeWhere((element) => element['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktiva parkeringar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rubrik för aktiva parkeringar
            //Text(
             // 'Aktiva parkeringar',
             // style: theme.textTheme.titleLarge,
            //),
            const SizedBox(height: 8.0),
            activeParkings.isEmpty
                ? const Text('Inga aktiva parkeringar.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activeParkings.length,
                    itemBuilder: (context, index) {
                      final parking = activeParkings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                              '${parking['parkingSpace']} - ${parking['vehicle']}'),
                          subtitle:
                              Text('Starttid: ${parking['startTime']}'),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              _endParking(parking['id']!);
                            },
                            child: const Text('Avsluta'),
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 24.0),
            // Rubrik för historik
            Text(
              'Historik',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            historicalParkings.isEmpty
                ? const Text('Ingen historik tillgänglig.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: historicalParkings.length,
                    itemBuilder: (context, index) {
                      final parking = historicalParkings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          title: Text(
                              '${parking['parkingSpace']} - ${parking['vehicle']}'),
                          subtitle: Text(
                              'Starttid: ${parking['startTime']}\nSluttid: ${parking['endTime']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteHistoricalParking(parking['id']!);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}