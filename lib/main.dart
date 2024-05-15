import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Color ListTileColor = Color(0xffb0bf1e);
String line = 'Shinjuku';
String currentRegion = 'Shinjuku';

Future<List<Map<String, dynamic>>> fetchTrainData(Line) async {
  final response = await http.get(Uri.parse('https://api-public.odpt.org/api/v4/odpt:Train?odpt:railway=odpt.Railway:Toei.$Line&odpt:operator=odpt.Operator:Toei'));
  print('apicall');
  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    return responseData.map((data) => data as Map<String, dynamic>).toList();
  } else {
    throw Exception('Failed to load train data');
  }
}

void main() {
  runApp(const MyAppHome());
}

class MyAppHome extends StatelessWidget {
  const MyAppHome({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentAssetImage = 'lib/assets/C.png';
  String hoveredAssetImage = '';

  // Define trainData variable here
  List<Map<String, dynamic>>? trainData = [];

  @override
  void initState() {
    super.initState();
    // Fetch train data when widget is initialized
    fetchTrainData(line).then((data) {
      setState(() {
        trainData = data;
      });
    }).catchError((error) {
      print('Error fetching train data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          background: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIconButton('lib/assets/A.png', onButtonAClicked),
              buildIconButton('lib/assets/E.png', onButtonEClicked),
              buildIconButton('lib/assets/s.png', onButtonSClicked),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'lib/assets/1200px-Fukutoshin_Line_Shibuya_Station_002 (1).jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(120.0),
                  child: SizedBox(
                    height: 1200,
                    width: 1200,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Text(
                            '${_getCurrentTime()}',
                            style: GoogleFonts.exo2(color: Colors.white),
                            textScaleFactor: 4,
                          ),
                          
                        ),
                        Text('$currentRegion',style: GoogleFonts.exo2(color: ListTileColor),textScaleFactor: 4,),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            height: 800,
                            width: 1200,
                            color: const Color.fromARGB(148, 231, 231, 231),
                            child: MyList(trainData: trainData), // Pass trainData to MyList
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _getCurrentTime() {
    var now = DateTime.now();
    var japanTime = now.toUtc().add(Duration(hours: 9)); // Japan timezone is UTC+9
    var formatter = DateFormat('HH:mm');
    return formatter.format(japanTime);
  }

  Widget buildIconButton(String imagePath, VoidCallback onPressed) {
    return HoverableIconButton(
      imagePath: imagePath,
      onTap: () {
        setState(() {
          currentAssetImage = imagePath;
          print('Icon pressed: $imagePath');
        });
        onPressed(); // Perform the specific action for each button
      },
      onHover: (hover) {
        setState(() {
          hoveredAssetImage = hover ? imagePath : '';
          print(hover ? 'Icon hovered: $imagePath' : 'No icon hovered');
        });
      },
      isHovered: hoveredAssetImage == imagePath || currentAssetImage == imagePath,
    );
  }

  void onButtonAClicked() {
    // Custom action for button A
    setState(() {
      ListTileColor = Color(0xffec6e65);
      line = 'Asakusa';
      fetchTrainData(line).then((data) {
        setState(() {
          trainData = data;
          currentRegion = 'Asakusa';
        });
      }).catchError((error) {
        print('Error fetching train data: $error');
      });

    });
    print('Button A clicked');
  }

  void onButtonEClicked() {
    // Custom action for button E
    ListTileColor = Color(0xffce045b);
    line = 'Oedo';
    fetchTrainData(line).then((data) {
      setState(() {
        trainData = data;
        currentRegion = 'Oedo';
      });
    }).catchError((error) {
      print('Error fetching train data: $error');
    });
    print('Button E clicked');
  }

  void onButtonSClicked() {
    // Custom action for button S
    ListTileColor = Color(0xffb0bf1e);
    line = 'Shinjuku';
    fetchTrainData(line).then((data) {
      setState(() {
        trainData = data;
        currentRegion = 'Shinjuku';
      });
    }).catchError((error) {
      print('Error fetching train data: $error');
    });
    print('Button S clicked');
  }
}

class MyList extends StatelessWidget {
  final List<Map<String, dynamic>>? trainData;

  const MyList({Key? key, required this.trainData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trainData == null) {
      return Center(child: CircularProgressIndicator());
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

class HoverableIconButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;
  final bool isHovered;

  const HoverableIconButton({
    required this.imagePath,
    required this.onTap,
    required this.onHover,
    required this.isHovered,
  });

  @override
  _HoverableIconButtonState createState() => _HoverableIconButtonState();
}

class _HoverableIconButtonState extends State<HoverableIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        widget.onHover(true);
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        widget.onHover(false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0), // Increased padding
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: (widget.isHovered || _isHovered) ? 60.0 : 36.0, // Increased sizes
            height: (widget.isHovered || _isHovered) ? 60.0 : 36.0, // Increased sizes
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            child: Image.asset(
              widget.imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high, // Set high quality for images
            ),
          ),
        ),
      ),
    );
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
        margin: EdgeInsets.all(8.0),
        color: Colors.transparent, // Set the color to transparent
        elevation: 0, // Remove shadow
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            tileColor: ListTileColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text('Train Number: $trainNumber'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To Station: ${extractStationName(toStation)}'),
                Text('Destination Station: ${extractStationName(destinationStation)}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}