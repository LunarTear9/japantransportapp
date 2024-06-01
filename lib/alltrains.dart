import 'package:flutter/material.dart';
import 'main.dart'; // Import TrainInfoCard widget if it's in a separate file.

class MyList extends StatelessWidget {
  final List<Map<String, dynamic>>? trainData;

  const MyList({Key? key, required this.trainData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trainData == null) {
      return Center(child: CircularProgressIndicator());
    } else if (trainData!.isEmpty) {
      return Center(child: Text('No trains available'));
    } else {
      return CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final train = trainData![index];
                return TrainInfoCard(
                  toStation: train['odpt:toStation'] ?? 'Please wait',
                  lastStation: train['odpt:fromStation'] ?? '',
                  trainNumber: train['odpt:trainNumber'] ?? '',
                  raildirection: train['odpt:railDirection'] ?? '',
                );
              },
              childCount: trainData!.length,
            ),
          ),
         
        ],
      );
    }
  }
}

class TrainInfoCard extends StatelessWidget {
  final String raildirection;
  final String toStation;
  final dynamic lastStation; // Adjusted type to dynamic
  final String trainNumber;

  const TrainInfoCard({
    Key? key,
    required this.lastStation,
    required this.trainNumber,
    required this.toStation,
    required this.raildirection,
  }) : super(key: key);

  String formatStationName(String stationName) {
    return stationName.replaceAllMapped(RegExp(r'(?<=[a-z])([A-Z])'), (match) {
      return '-' + match.group(0)!;
    });
  }

  String extractStationName(dynamic station) {
    if (station != null) {
      if (station is String) {
        final parts = formatStationName(station).split('.');
        return parts.isNotEmpty ? parts.last : '';
      } else if (station is List<String> && station.isNotEmpty) {
        final parts = formatStationName(station.last).split('.');
        return parts.isNotEmpty ? parts.last : '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Set the color to transparent
      child: Card(
        margin: EdgeInsets.only(left: 40.0, right: 40, bottom: 10,top: 10),
        color: Colors.transparent, // Set the color to transparent
        elevation: 4, // Add shadow with elevation
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            onTap: () {},
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            tileColor: ListTileColor, // Use appropriate color variable
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Train Number: $trainNumber', style: TextStyle(color: Colors.white)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To Station: ${extractStationName(toStation)}', style: TextStyle(color: Colors.white)),
                Text('From: ${extractStationName(lastStation)} -> To: ${getNextStation(extractStationName(lastStation), raildirection)}', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


List<Map<String, dynamic>> ShinjukuStations = [
  {
    'id': '1',
    'title': 'Shinjuku',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '2',
    'title': 'Shinjuku-Sanchome',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '3',
    'title': 'Akebonobashi',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '4',
    'title': 'Ichigaya',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '5',
    'title': 'Kudanshita',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '6',
    'title': 'Jimbocho',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '7',
    'title': 'Ogawamachi',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '8',
    'title': 'Iwamotocho',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '9',
    'title': 'Hamacho',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '10',
    'title': 'Morishita',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '11',
    'title': 'Kikukawa',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '12',
    'title': 'Sumiyoshi',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '13',
    'title': 'Nishi-Ojima',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '14',
    'title': 'Ojima',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '15',
    'title': 'Higashi-Ojima',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '16',
    'title': 'Funabori',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '17',
    'title': 'Ichinoe',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '18',
    'title': 'Mizue',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '19',
    'title': 'Shinozaki',
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '20',
    'title': 'Motoyawata',
    'assetPath': 'lib/assets/s2.png',
  },
];

String? getNextStation(String lastStation, String railDirection) {
  // Extract the direction from the railDirection string
  String direction = railDirection.toLowerCase().contains('westbound') ? 'westbound' : 'eastbound';

  // Find the index of the last station in the Stations list
  int lastIndex = Stations.indexWhere((station) => station['title'] == lastStation);

  if (lastIndex != -1) {
    if (direction == 'westbound') {
      // If the direction is westbound, get the previous station by decrementing the index
      if (lastIndex > 0) {
        return Stations[lastIndex - 1]['title'];
      } else {
        return 'End of the line'; // or return Stations[Stations.length - 1]['title'] if you want to loop back
      }
    } else if (direction == 'eastbound') {
      // If the direction is eastbound, get the next station by incrementing the index
      if (lastIndex < Stations.length - 1) {
        return Stations[lastIndex + 1]['title'];
      } else {
        return 'End of the line'; // or return Stations[0]['title'] if you want to loop back
      }
    }
  }

  // Return null if the next station cannot be found
  return 'Loading...';
}