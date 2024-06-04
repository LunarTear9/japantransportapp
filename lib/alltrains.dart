import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart'; // Import TrainInfoCard widget if it's in a separate file.


bool isExpanded2 = false;
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
                  trainType: train['odpt:trainType'] ?? '',
                  delay: train['odpt:delay'] ?? '',
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

class TrainInfoCard extends StatefulWidget {
  final String raildirection;
  final String toStation;
  final dynamic lastStation; // Adjusted type to dynamic
  final String trainNumber;
  final String trainType;
  final int delay;

  const TrainInfoCard({
    Key? key,
    required this.lastStation,
    required this.trainNumber,
    required this.toStation,
    required this.raildirection,
    required this.trainType,
    required this.delay,
  }) : super(key: key);

  @override
  State<TrainInfoCard> createState() => _TrainInfoCardState();
}

class _TrainInfoCardState extends State<TrainInfoCard> {
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
Widget getDelay(int delay) {


  if (delay == 0) {
    return Text('On Time', style: TextStyle(color: Colors.white));
  } else if (delay > 0) {
    return Text('Delayed by $delay Seconds', style: TextStyle(color: Colors.red));
  } else {
    return Text('Early by ${delay.abs()} Seconds', style: TextStyle(color: Colors.white));
  }
}

double getSizedBox(delay){

 if(delay==0){
   return  70;
 }
   else if (delay > 0){
     return 150;

     
   


}

else {

  return 32;
}

}

  @override
  Widget build(BuildContext context) {
    
    return Material(
      color: Colors.transparent, // Set the color to transparent
      child: Card(
        margin: EdgeInsets.only(left: 40.0, right: 40, bottom: 10,top: 10),
        color: Colors.transparent, // Set the color to transparent
        elevation: 4, // Add shadow with elevation
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListTile(
                onTap: () {
            setState(() {
              isExpanded2 = !isExpanded2;
            });
            
                },
                trailing: SizedBox(width: getSizedBox(widget.delay),child: Row(children: [Padding(padding: EdgeInsets.only(right:14),child:getDelay(widget.delay)),isExpanded2? Icon(Icons.arrow_downward, color: Colors.white):Icon(Icons.arrow_forward_ios, color: Colors.white)],)),
                tileColor: ListTileColor, // Use appropriate color variable
                shape: RoundedRectangleBorder(
                  borderRadius: !isExpanded2 ? BorderRadius.circular(12) : BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                ),
               
                
                title: Text('Train Number: ${widget.trainNumber}', style: TextStyle(color: Colors.white)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('To Station: ${extractStationName(widget.toStation)}', style: TextStyle(color: Colors.white)),
                    Text('From: ${extractStationName(widget.lastStation)} -> To: ${getNextStation(extractStationName(widget.lastStation), widget.raildirection)}', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
Visibility(
  visible: isExpanded2,
  child: Menu(trainNumber: widget.trainNumber,trainType: widget.trainType,railDirection: widget.raildirection,lastStation: extractStationName(widget.lastStation),nextStation: getNextStation(extractStationName(widget.lastStation), widget.raildirection,),delay: getDelay(widget.delay)))
          ],
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

class Menu extends StatefulWidget {
  final trainNumber;
  final trainType;
  final railDirection;
  final lastStation;
  final nextStation;
  final delay;
  const Menu({super.key,required this.trainNumber,required this.trainType,required this.railDirection,required this.lastStation,required this.nextStation,required this.delay});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    
    String lastStationImage = stationImageMap[(widget.lastStation)] ?? 'lib/assets/s2.png';
  print(widget.nextStation);
    String nextStationImage = stationImageMap[widget.nextStation] ?? 'lib/assets/s2.png';
        String direction = widget.railDirection.toLowerCase().contains('westbound') ? 'Westbound' : 'Eastbound';
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24),bottomRight: Radius.circular(24)),
      child: Container(
       
        width: double.infinity,
        height: 400,
      color: ListTileColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        
      Text('${widget.trainNumber} ($direction)', style: GoogleFonts.roboto(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                
                image: AssetImage(lastStationImage),height: 50, width: 50,),
              Text("${widget.lastStation}",style: GoogleFonts.roboto(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Icon(Icons.arrow_right_rounded, color: Colors.white, size: 50,),
                
                Padding(padding: EdgeInsets.only(top:38),child: widget.delay),
              ],
            ),
          ),Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(nextStationImage),height: 50, width: 50,),
              Text("${widget.nextStation}",style: GoogleFonts.roboto(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold)),

            ],
          )
        ],
      ),
      
    
      
      
      ])
      
      ),
    );
  }
}
