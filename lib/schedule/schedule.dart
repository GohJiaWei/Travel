import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:travel/services/db.dart';


class SchedulePage extends StatefulWidget {
  int id;
  SchedulePage({super.key, required this.id});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DBService db = DBService();
  final locationController = Location();

  static const googlePlex = LatLng(37.4223, -122.0848);
  static const mountainView = LatLng(37.3861, -122.0839);

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await initializeMap());
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60,),
          FutureBuilder(
              future: db.fetchSchedule(1),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No locations found'));
                } else {
                  final data = snapshot.data;
                  List<Map<String, dynamic>> locations = [];
                  for (var row in data!) {
                    locations.add({
                      'Name': row['Name'],
                      'Cost': row['Cost'],
                      'Longitude': row['Longitude'],
                      'Latitude': row['Latitude'],
                    });
                  }
                  return Column(
                    children: [
                      Center(
                        child: Container(
                          width: 400,
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition:
                            CameraPosition(
                              target: LatLng(locations[0]['Longitude'], locations[0]['Latitude']),
                              zoom: 10,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('sourceLocation'),
                                icon: BitmapDescriptor.defaultMarker,
                                position: LatLng(locations[0]['Longitude'], locations[0]['Latitude']),
                              ),
                              Marker(
                                markerId: MarkerId('destinationLocation'),
                                icon: BitmapDescriptor.defaultMarker,
                                position: LatLng(locations[1]['Longitude'], locations[1]['Latitude']),
                              )
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {

                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: Text('9.00 am'),
                                        ),
                                        SizedBox(height: 3,),
                                        Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFBFB4AD),
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 12, horizontal: 8),
                                              child: ListTile(
                                                leading: Image.network(
                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYArSfFlMh4VhBz3tYLefzqGLnDtzeSulxxQ&s',
                                                  width: 175.0,
                                                  // Width of the image
                                                  height: 250.0,
                                                  // Height of the image
                                                  fit: BoxFit
                                                      .cover, // How the image should be inscribed into the box
                                                ),
                                                title: Text(locations[index]['Name']),
                                                subtitle: Text(locations[index]['Cost']),
                                              ),
                                            )
                                        ),
                                        SizedBox(height: 8,)
                                      ],
                                    )
                                ),
                              );
                            },

                            itemCount: 5
                        ),
                      ),
                    ],
                  );
                }
              }
          ),
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }



  Future<void> generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }

}