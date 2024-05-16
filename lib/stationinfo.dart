import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:japanmetroline/main.dart';
late Future<List<Map<String, dynamic>>> trainDataFuture;

class TrainInfoList extends StatefulWidget {
  @override
  TrainInfoListState createState() => TrainInfoListState();
}

class TrainInfoListState extends State<TrainInfoList> {
  

  @override
  void initState() {
    super.initState();
    trainDataFuture = fetchTrainInformation(line);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: trainDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final trainData = snapshot.data!;
          return ListView.builder(
            itemCount: trainData.length,
            itemBuilder: (context, index) {
              final trainInfo = trainData[index];
              return TrainInfoCard(trainInfo: trainInfo);
            },
          );
        }
      },
    );
  }
}


class TrainInfoCard extends StatelessWidget {
  final Map<String, dynamic> trainInfo;

  const TrainInfoCard({Key? key, required this.trainInfo}) : super(key: key);

  String extractStationName(dynamic station) {
    if (station != null && station is String) {
      final parts = station.split('.');
      if (parts.isNotEmpty) {
        final stationName = parts.last;
        final partsAfterLastDot = stationName.split(RegExp(r'(?<=[a-z])(?=[A-Z])'));
        return partsAfterLastDot.isNotEmpty ? partsAfterLastDot.last : '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final trainInformationText =
        trainInfo['odpt:trainInformationText']?['ja'] ?? 'No information available';
    final railway = trainInfo['owl:sameAs'] ?? 'Unknown railway';
    final stationName = extractStationName(railway);
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 0, // Remove shadow
      child: ListTile(
        tileColor: ListTileColor,
        title: Text(' Station Name: $stationName'),
      ),
    );
  }
}