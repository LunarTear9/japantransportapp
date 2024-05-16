import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:japanmetroline/main.dart';

dynamic departureTimesLogic;
List<String> destinationStations = [];
dynamic stationName = "Ojima";
late Future<List<Map<String, dynamic>>> trainDataFuture;

class TrainInfoList extends StatefulWidget {
  final List<Map<String, dynamic>>? trainInfo;

  const TrainInfoList({Key? key, required this.trainInfo}) : super(key: key);

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
          return Expanded(
            child: ListView.builder(
              itemCount: trainData.length,
              itemBuilder: (context, index) {
                final trainInfo = trainData[index];
                return TrainInfoCard(trainInfo: trainInfo);
              },
            ),
          );
        }
      },
    );
  }
}

class TrainInfoCard extends StatefulWidget {
  final Map<String, dynamic> trainInfo;

  const TrainInfoCard({Key? key, required this.trainInfo}) : super(key: key);

  @override
  _TrainInfoCardState createState() => _TrainInfoCardState();
}

class _TrainInfoCardState extends State<TrainInfoCard> {
  bool _isExpanded = false;
  late Future<List<String>> _departureTimesFuture;

  @override
  void initState() {
    super.initState();
    _departureTimesFuture = Future.value([]);
  }

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
    final railway = widget.trainInfo['owl:sameAs'] ?? 'Unknown railway';
    final title = widget.trainInfo['dc:title'] ?? 'Unknown railway';
    final stationName = extractStationName(railway);

    return Padding(padding:EdgeInsets.only(left:40,right:40),child:Card(
      color: ListTileColor,
      margin: EdgeInsets.all(8.0),
      elevation: 0, // Remove shadow
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            key: Key(stationName), // Unique key for each ListTile
            tileColor: ListTileColor,
            title: Text('$title', style: TextStyle(color: Colors.white),),
            subtitle: Text('$stationName', style: TextStyle(color: Colors.white),),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
                if (_isExpanded) {
                  _departureTimesFuture = fetchDepartureTimes(line, stationName);
                }
              });
            },
          ),
          AbsorbPointer(absorbing: true,
            child: Visibility(
              visible: _isExpanded,
              child: FutureBuilder<List<String>>(
                future: _departureTimesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError || snapshot.data == null) {
                    // Instead of showing an error message, return an empty container
                    return Container(child: Text("Not Available",style: TextStyle(color: Colors.white)));
                  } else {
                    final departureTimes = snapshot.data!;
                    return Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            'Schedules for $stationName',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: 206,
                            itemBuilder: (context, index) {
                              final departureTime = departureTimes[index];
                              final destinationStation = index < destinationStations.length ? destinationStations[index] : "Not available";
            
                              return ListTile(
                                leading: Icon(Icons.train),
                                title: Text(
                                  "${departureTime} --> ${destinationStation}",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              );
                            },
                          ),
                          // Add more detailed information here
                          SizedBox(height: 16),
                        ],
                      ),)
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
          ));
  }
}
Future<List<String>> fetchDepartureTimes(Line, stationName) async {
  final response = await http.get(Uri.parse("https://api-public.odpt.org/api/v4/odpt:StationTimetable?odpt:railway=odpt.Railway:Toei.$Line&odpt:station=odpt.Station:Toei.$Line.$stationName&odpt:operator=odpt.Operator:Toei")); 

  print('printing data for $stationName');

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    print('Fetched data: $data');
    List<String> departureTimes = [];
    
    // Clear the destinationStations list before adding new station names
    destinationStations.clear();

    if (data == null || data.isEmpty) {
      // If data is null or empty, return a list containing "Not Available"
      return ['Not Available'];
    }

    for (var stationTimetable in data) {
      for (var timetableObject in stationTimetable['odpt:stationTimetableObject']) {
        String? departureTime = timetableObject['odpt:departureTime'];

        // Check if departureTime is null, if so, set it to "Not Available"
        if (departureTime == null) {
          departureTime = "Not Available";
        } else {
          departureTimes.add(departureTime);
        }
        
        // Extracting destination stations from the list
        List<dynamic> destinationStationList = timetableObject['odpt:destinationStation'];
        for (var destinationStation in destinationStationList) {
          destinationStations.add(extractDestinationStationName(destinationStation));
        }
      }
    }

    print('Departure times: $departureTimes');
    
    return departureTimes;
  } else {
    throw Exception('Failed to load departure times');
  }
}

String extractDestinationStationName(String station) {
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