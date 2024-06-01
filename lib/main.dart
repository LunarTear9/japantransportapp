import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:japanmetroline/alltrains.dart';
import 'package:japanmetroline/stationinfo.dart';
import 'package:text_scroll/text_scroll.dart';


int DurationVariable = 0;
dynamic pinData = data;
int uselessFlag = 0;
dynamic Camera = CameraPosition(target: LatLng(35.6895, 139.6917), zoom: 12);
Color ListTileColor = Color(0xffb0bf1e);
String line = 'Shinjuku';
  final Key  keyTextScroll = const ObjectKey(1);
dynamic physics = AlwaysScrollableScrollPhysics();
bool value1 = false;
bool switchvalue1 = false;
int buttonFlag = 1;
String currentRegion = 'Shinjuku';
dynamic buttonColor3 = ListTileColor;
int buttonTrigger = 0;
List<Map<String, dynamic>> Stations = ShinjukuStations;
dynamic buttonColor2 = const Color.fromARGB(148, 231, 231, 231);
final Map<String, Marker> _markers = {};
Future<Map<String, dynamic>> fetchTrainInformationText(String line) async {
  final response = await http.get(Uri.parse('https://api-public.odpt.org/api/v4/odpt:TrainInformation?odpt:railway=odpt.Railway:Toei.$line&odpt:operator=odpt.Operator:Toei'));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    if (responseData.isNotEmpty) {
      return responseData.first as Map<String, dynamic>;
    } else {
      throw Exception('No train information available');
    }
  } else {
    throw Exception('Failed to load train information');
  }
}

Future<List<Map<String, dynamic>>> fetchTrainInformation(Line) async {
  final response = await http.get(
      Uri.parse('https://api-public.odpt.org/api/v4/odpt:Station?odpt:railway=odpt.Railway:Toei.$Line&odpt:operator=odpt.Operator:Toei')); // Replace with your API endpoint
  print('apicall');
  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
    return responseData.map((data) => data as Map<String, dynamic>).toList();
  } else {
    throw Exception('Failed to load train information');
  }
}

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
      debugShowCheckedModeBanner: false,
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

  _generateMarkers() async {

  for (int i = 0; i < pinData.length; i++) {
   BitmapDescriptor markerIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(


   ),
   pinData[i]['assetPath']
   
   
   
   );

  _markers[i.toString()] = Marker( markerId: MarkerId(i.toString()), position: pinData[i]['position'], icon: markerIcon,infoWindow: InfoWindow(title: pinData[i]['title'], snippet: 'Toei Shinjuku Line'));
    setState((){});
   
  }
}
  String currentAssetImage = 'lib/assets/C.png';

 LatLng? selectedCoordinates;

  void filterSearchResults(String query) {
    final matchedItem = pinData.firstWhere(
      (item) => item['title'].toString().toLowerCase() == query.toLowerCase(),
      orElse: () => {},
    );

    setState(() {
      if (matchedItem.isNotEmpty) {
        selectedCoordinates = matchedItem['position'];
        Camera = CameraPosition(target: selectedCoordinates!, zoom: 15);
         _mapKey.currentState?.setState(() {
          _controller?.animateCamera(CameraUpdate.newCameraPosition(Camera));
         });
      } else {
        selectedCoordinates = null;
      }
      print(selectedCoordinates);
    });
  }
  // Define trainData variable here
  List<Map<String, dynamic>>? trainData = [];
  List<Map<String, dynamic>>? trainInfo = [];
  List<dynamic> stationNames = pinData.map((station) => station['title']).toList();
  bool isButton3Pressed = true;
  Future<Map<String, dynamic>>? trainInfoFuture;
  int keyValue = 1;
  GoogleMapController? _controller;
final GlobalKey _mapKey = GlobalKey();
  @override
  void initState() {
    _generateMarkers();
    super.initState();
    _loadMapStyle();
    // Fetch train data when widget is initialized
    fetchTrainData(line).then((data) {
      setState(() {
        trainData = data;
      });
    }).catchError((error) {
      print('Error fetching train data: $error');
    });

    // Fetch train information text
    trainInfoFuture = fetchTrainInformationText(line);

    
  }
    Future<void> _loadMapStyle() async {
    String style = await rootBundle.loadString('lib/assets/map_style.json');
    _controller?.setMapStyle(style);
  }
dynamic? selectedStation;
List<dynamic> _filterStationNames(dynamic query) {
    return stationNames.where((station) => station.toLowerCase().contains(query.toLowerCase())).toList();
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
        physics: physics,
        
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
                    padding: const EdgeInsets.only(top:120.0,left: 16,right:16),
                    child: SizedBox(
                      height: 1800,
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
                          Text(
                            '$currentRegion',
                            style: GoogleFonts.exo2(color: ListTileColor),
                            textScaleFactor: 4,
                          ).animate().slideX(
                              begin: -0.2,
                              duration: Duration(milliseconds: 500 + DurationVariable)).fadeIn(
                              duration: Duration(milliseconds: 500)),
                          Row(
                            children: [
                              
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                    backgroundColor: MaterialStateProperty.all(buttonColor3),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      buttonColor3 = ListTileColor;
                                      buttonColor2 = Color.fromARGB(148, 231, 231, (231 + buttonTrigger));
                                      buttonFlag = 1;
                                      isButton3Pressed = true;
                                    });
                                  },
                                  child: Text("Station Info",style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              // Add some spacing between buttons
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size(200, 50)),
                                    backgroundColor: MaterialStateProperty.all(buttonColor2),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10))
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      buttonColor2 = ListTileColor;
                                      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);
                                      buttonFlag = 0;
                                      isButton3Pressed = false;
                                    });
                                  },
                                  child: Text("All Trains",style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                            child: Container(
                              height: 1500,
                              width: 1200,
                              color: const Color.fromARGB(148, 231, 231, 231),
                              child: !isButton3Pressed
                                  ? MyList(trainData: trainData)
                                  : Column(
                                children: [
          
                                SizedBox(
                                  height: 400,
                                  child:  Padding(
                                            
                                    padding: EdgeInsets.all(24),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                     
                                      child: MouseRegion(
                                       onHover:  (event) {
                                            
                                       
                                       },
                                       onExit: ( event) {
                                       
                                       },
                                        child: 
                                        GoogleMap(
                                         key: _mapKey,
                                          onMapCreated: (GoogleMapController controller) {
                                            _controller = controller;
                                            _loadMapStyle();
                                          },
                                          zoomGesturesEnabled: false,
                                          webGestureHandling: WebGestureHandling.cooperative,
                                          trafficEnabled: switchvalue1,
                                           initialCameraPosition: Camera,markers: _markers.values.toSet()),
                                      ),
                                    ),
                                  ),
                                ),Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:32.0,vertical: 8),
                                                          child: SizedBox(child: Autocomplete<String>(
                                        optionsBuilder: (TextEditingValue textEditingValue) {
                                          // Filter station names based on user input
                                          return Future<Iterable<String>>.value(_filterStationNames(textEditingValue.text).map<String>((dynamic value) => value.toString()));
                                        },
                                        onSelected: (String value) {
                                          setState(() {
                                            selectedStation = value;
                                          });
                                        },
                                        fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                          return TextField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            onSubmitted: (String value) {
                                              filterSearchResults(value);
                                              onFieldSubmitted(


                                              );
                                              
                                            },
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(Icons.search, color: Colors.black),
                                              hintText: 'Search Station',
                                              hintStyle: TextStyle(color: Colors.black),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(color: Colors.black),
                                              ),
                                            ),
                                          );
                                        },
                                        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                              elevation: 4.0,
                                              child: Container(
                                                color: ListTileColor,
                                                height: 200,
                                                width: 600,
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  children: options.map<Widget>((String option) {
                                                    return ListTile(
                                                      title: Text(option),
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                  height: 100,
                  width: 600,
                
            ),
                                    ),
                                    Column(children: [
                                      ClipRRect(borderRadius: BorderRadius.circular(12),child:
                                      Container(
                                        color: Color.fromARGB(164, 255, 255, 255),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text( 'Show Traffic',style: TextStyle(color: ListTileColor,fontSize: 24),),
                                        ),),),
                                                                   Switch(
                                    activeColor: ListTileColor,
                                        value: switchvalue1,
                                        onChanged: (value) {
                                          setState(() {
                                            switchvalue1 = value;
                                          });
                                        },
                                      ),]),
                                  ],
                                ),
                                  FutureBuilder<Map<String, dynamic>>(
                                    future: trainInfoFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else if (snapshot.hasData) {
                                        final trainInfoText = snapshot.data!['odpt:trainInformationText']['ja'] ?? 'No information available';
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(borderRadius: BorderRadius.circular(12),child:Container(
                                            color: Color.fromARGB(146, 104, 104, 104),
                                            child: AnimatedContainer(
                                              duration: Duration(seconds: 1),
                                              child: TextScroll(
                                                key: keyTextScroll,
                                                "$trainInfoText                                ",
                                                style: TextStyle(color: ListTileColor, fontSize: 48),
                                              ),
                                            ),
                                            
                                          ),
                                        ));
                                      } else {
                                       
          
                                        return Center(child: Text('No information available'));
                                      }
                                    },
                                  ),
                                   Divider(color: ListTileColor,thickness: 2,indent: 20,endIndent: 20,),
                                  TrainInfoList(trainInfo: trainInfo),
                                 
                                ],
                              ),
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
        onPressed(); // Perform the specific action for each button
      },
    );
  }

  void onButtonAClicked() async {
    setState(() async {
      ListTileColor = const Color(0xffec6e65);
      line = 'Asakusa';
      Stations = dataAsakusa;
      pinData = dataAsakusa;
      currentRegion = 'Asakusa';
      DurationVariable = 1;
      _generateMarkers();
      buttonTrigger = 0;
      if (isButton3Pressed == true) {
        isButton3Pressed = false;
      }

      buttonColor2 = ListTileColor;
      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);

      try {
        final data = await fetchTrainData(line);
        setState(() {
          trainData = data;
        });
        trainInfoFuture = fetchTrainInformationText(line);
      } catch (error) {
        print('Error fetching train data: $error');
      }

      print('Button A clicked');
    });
  }

  void onButtonEClicked() async {
    setState(() async {
      ListTileColor = const Color(0xffce045b);
      line = 'Oedo';
      currentRegion = 'Oedo';
      DurationVariable = 0;
      _generateMarkers();
      buttonTrigger = 1;
      if (isButton3Pressed == true) {
        isButton3Pressed = false;
      }

      buttonColor2 = ListTileColor;
      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);

      try {
        final data = await fetchTrainData(line);
        setState(() {
          trainData = data;
        });
        trainInfoFuture = fetchTrainInformationText(line);
      } catch (error) {
        print('Error fetching train data: $error');
      }

      print('Button E clicked');
    });
  }

  void onButtonSClicked() async {
    setState(() async {
      ListTileColor = const Color(0xffb0bf1e);
      line = 'Shinjuku';
      Stations = ShinjukuStations;
      pinData = data;
      _generateMarkers();
      currentRegion = 'Shinjuku';
      DurationVariable = 2;
      if (isButton3Pressed == true) {
        isButton3Pressed = false;
      }

      buttonColor2 = ListTileColor;
      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);

      try {
        final data = await fetchTrainData(line);
        setState(() {
          trainData = data;
        });
        trainInfoFuture = fetchTrainInformationText(line);
      } catch (error) {
        print('Error fetching train data: $error');
      }
    });

    print('Button S clicked');
  }
}

class HoverableIconButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const HoverableIconButton({
    required this.imagePath,
    required this.onTap,
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
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(6.0), // Increased padding
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: (_isHovered) ? 60.0 : 36.0, // Increased sizes
            height: (_isHovered) ? 60.0 : 36.0, // Increased sizes
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

List<Map<String, dynamic>> data = [
  {
    'id': '1',
    'title': 'Shinjuku',
    'position': const LatLng(35.6896021,139.7004839), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '2',
    'title': 'Shinjuku-sanchome',
    'position': const LatLng(35.6908636,139.7047682), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '3',
    'title': 'Akebonobashi',
    'position': const LatLng(35.6923429,139.7225317), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '4',
    'title': 'Ichigaya',
    'position': const LatLng(35.6910045,139.735467), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '5',
    'title': 'Kudanshita',
    'position': const LatLng(35.6954587,139.7510729), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '6',
    'title': 'Jinbocho',
    'position': const LatLng(35.6959019,139.7575118), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '7',
    'title': 'Ogawamachi',
    'position': const LatLng(35.6951586,139.7667557), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '8',
    'title': 'Iwamotocho',
    'position': const LatLng(35.6955489,139.7750715), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '9',
    'title': 'Hamacho',
    'position': const LatLng(35.6884112,139.7876368), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '10',
    'title': 'Morishita',
    'position': const LatLng(35.6880153,139.7975693), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '11',
    'title': 'Kikukawa',
    'position': const LatLng(35.6883655,139.8059956), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '12',
    'title': 'Sumiyoshi',
    'position': const LatLng(35.6889909,139.8157427), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '13',
    'title': 'Nishi-Ojima',
    'position': const LatLng(35.6893517,139.8262506), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '14',
    'title': 'Ojima',
    'position': const LatLng(35.6897503,139.8346515), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '15',
    'title': 'Higashi-Ojima',
    'position': const LatLng(35.6898852,139.8474303), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '16',
    'title': 'Funabori',
    'position': const LatLng(35.6838116,139.8640594), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '17',
    'title': 'Ichinoe',
    'position': const LatLng(35.685903,139.882367), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '18',
    'title': 'Mizue',
    'position': const LatLng(35.6932817,139.8976135), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '19',
    'title': 'Shinozaki',
    'position': const LatLng(35.705976,139.9038004), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
  {
    'id': '20',
    'title': 'Motoyawata',
    'position': const LatLng(35.7209044,139.9272774), // Placeholder coordinates
    'assetPath': 'lib/assets/s2.png',
  },
];


List<Map<String, dynamic>> dataAsakusa = [
  {
    'id': '1',
    'title': 'Nishi-Magome',
    'position': const LatLng(35.5868063,139.705787), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '2',
    'title': 'Magome',
    'position': const LatLng(35.5963742,139.7117779), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '3',
    'title': 'Nakanobu',
    'position': const LatLng(35.6057769,139.7126001), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '4',
    'title': 'Togoshi',
    'position': const LatLng(35.6144648,139.716284), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '5',
    'title': 'Gotanda',
    'position': const LatLng(35.6262851,139.7234455), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '6',
    'title': 'Takawanawadai',
    'position': const LatLng(35.6317899,139.7304399), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '7',
    'title': 'Sengakuji',
    'position': const LatLng(35.6386228,139.7398764), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '8',
    'title': 'Mita',
    'position': const LatLng(35.6476645,139.7460769), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '9',
    'title': 'Daimon',
    'position': const LatLng(35.6567195,139.75547), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '10',
    'title': 'Shinbashi',
    'position': const LatLng(35.666371,139.7582187), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '11',
    'title': 'Higashi-Ginza',
    'position': const LatLng(35.6697046,139.7645596), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '12',
    'title': 'Takaracho',
    'position': const LatLng(35.675472,139.7718032), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '13',
    'title': 'Nihombashi',
    'position': const LatLng(35.6820973,139.7746189), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '14',
    'title': 'Ningyocho',
    'position': const LatLng(35.6863497,139.7822313,), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '15',
    'title': 'Higashi-Nihombashi',
    'position': const LatLng(35.6921504,139.7847954), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '16',
    'title': 'Asakusabashi',
    'position': const LatLng( 35.6974588,139.7859034),// Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '17',
    'title': 'Kuramae',
    'position': const LatLng(35.7031149,139.790577), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '18',
    'title': 'Asakusa',
    'position': const LatLng(35.7107633,139.7976384), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '19',
    'title': 'Honjo-Azumabashi',
    'position': const LatLng(35.7085714,139.8044621), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
  {
    'id': '20',
    'title': 'Oshiage',
    'position': const LatLng(35.7103115,139.8130936), // Placeholder coordinates
    'assetPath': 'lib/assets/A2.png',
  },
];
