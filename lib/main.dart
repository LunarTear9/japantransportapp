import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:japanmetroline/alltrains.dart';
import 'package:japanmetroline/stationinfo.dart';

int DurationVariable = 0;
Color ListTileColor = Color(0xffb0bf1e);
String line = 'Shinjuku';
int buttonFlag = 1;
String currentRegion = 'Shinjuku';
dynamic buttonColor3 = ListTileColor;
int buttonTrigger = 0;
dynamic buttonColor2 = const Color.fromARGB(148, 231, 231, 231);

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
  bool isButton3Pressed = true;

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
                        Text('$currentRegion',style: GoogleFonts.exo2(color: ListTileColor),textScaleFactor: 4,).animate().slideX(begin: -0.2,duration: Duration(milliseconds: 500 + DurationVariable)).fadeIn(duration: Duration(milliseconds: 500)),
                        Row(
  
  children: [
    Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(200, 50)),
          backgroundColor: MaterialStateProperty.all(buttonColor3),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
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
        child: Text("Station Info"),
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
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
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
        child: Text("All Trains"),
      ),
    ),
  ],
),
                        ClipRRect(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10 )),
                          child: Container(
                            height: 800,
                            width: 1200,
                            color: const Color.fromARGB(148, 231, 231, 231),
                            child: !isButton3Pressed ? MyList(trainData: trainData) : TrainInfoList(),
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

  void onButtonAClicked() async {
  setState(() async {
    ListTileColor = const Color(0xffec6e65);
    line = 'Asakusa';
    currentRegion = 'Asakusa';
    DurationVariable = 1;
    buttonTrigger = 0;
if(isButton3Pressed == true){
  isButton3Pressed = false;
}

    
      
      buttonColor2 = ListTileColor;
      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);


      try {
    final data = await fetchTrainData(line);
    setState(() {
      trainData = data;
    });
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
    buttonTrigger = 1;
    if(isButton3Pressed == true){
  isButton3Pressed = false;
}

    
   
    
      buttonColor2 = ListTileColor;
      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);
      try {
    final data = await fetchTrainData(line);
    setState(() {
      trainData = data;
    });
  } catch (error) {
    print('Error fetching train data: $error');
  }
    
  });

  

  print('Button E clicked');
}

void onButtonSClicked() async {
  setState(() async {
    ListTileColor = const Color(0xffb0bf1e);
    line = 'Shinjuku';
    currentRegion = 'Shinjuku';
    DurationVariable = 2;
    if(isButton3Pressed == true){
  isButton3Pressed = false;
}

    
    
    
      buttonColor2 = ListTileColor;
      buttonColor3 = const Color.fromARGB(148, 231, 231, 231);
      try {
    final data = await fetchTrainData(line);
    setState(() {
      trainData = data;
    });
  } catch (error) {
    print('Error fetching train data: $error');
  
    }
  });

  

  print('Button S clicked');
}}



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


