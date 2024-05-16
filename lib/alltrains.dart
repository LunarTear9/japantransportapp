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
      return ListView.builder(
        itemCount: trainData!.length,
        itemBuilder: (context, index) {
          final train = trainData![index];
          return TrainInfoCard(
            toStation: train['odpt:toStation'] ?? 'Please wait',
            destinationStation: train['odpt:fromStation'] ?? '',
            trainNumber: train['odpt:trainNumber'] ?? '',
          );
        },
      );
    }
  }
}

class TrainInfoCard extends StatelessWidget {
  final String toStation;
  final dynamic destinationStation; // Adjusted type to dynamic
  final String trainNumber;

  const TrainInfoCard({
    Key? key,
    required this.destinationStation,
    required this.trainNumber,
    required this.toStation,
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
        margin: EdgeInsets.only(left:40.0,right:40,bottom: 10),
        color: Colors.transparent, // Set the color to transparent
        elevation: 0, // Remove shadow
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            tileColor: ListTileColor, // Use appropriate color variable
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Train Number: $trainNumber',style: TextStyle(color: Colors.white),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To Station: ${extractStationName(toStation)}',style: TextStyle(color: Colors.white),),
                Text('Destination Station: ${extractStationName(destinationStation)}',style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
