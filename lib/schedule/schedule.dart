import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:travel/pages/description.dart';
import 'package:travel/services/db.dart';

class SchedulePage extends StatefulWidget {
  int id;
  SchedulePage({super.key, required this.id});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final locationController = Location();
  DBService db = DBService();
  List<int> _items = List.generate(10, (index) => index); // List to manage items

  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  int? _selectedLocation; // Variable to hold the selected radio button value
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) async => await initializeMap());
  }

  // Future<void> initializeMap() async {
  //   await fetchLocationUpdates();
  // }
  @override
  void didUpdateWidget(covariant SchedulePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          FutureBuilder(
              future: db.fetchSchedule(widget.id),
              builder: (context, snapshot) {
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
                      'Schedule_id': row['Schedule_id'],
                      'Loc_id': row['Loc_id']
                    });
                  }
                  return Column(
                    children: [
                      Center(
                        child: Container(
                          width: 400,
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(locations[0]['Longitude'],
                                  locations[0]['Latitude']),
                              zoom: 10,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId('sourceLocation'),
                                icon: BitmapDescriptor.defaultMarker,
                                position: LatLng(locations[0]['Longitude'],
                                    locations[0]['Latitude']),
                              )
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 450,
                        child: ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0 || index == 3) {
                                return Column(
                                  children: [
                                    Text(
                                      index == 0 ? 'Day 1': 'Day 2',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Dismissible(
                                      key: Key(_items[index]
                                          .toString()), // Unique key for each item
                                      direction: DismissDirection
                                          .startToEnd, // Swipe direction
                                      onDismissed: (direction) async {

                                        // Show confirmation dialog
                                        bool replace =
                                            await _showConfirmationDialog(
                                                context);
                                        db.deleteLocation(locations[index]['Loc_id'], locations[index]['Schedule_id']);

                                        if (replace) {
                                          // Show location selection dialog
                                          int? selectedLocation =
                                              await _showLocationSelectionDialog(
                                                  context, db.addLocation, locations[index]['Schedule_id']);
                                          if (selectedLocation != null) {
                                            setState(() {
                                              // Replace the item with the new location
                                              _items[index] = selectedLocation;
                                            });
                                          }

                                        } else {
                                          setState(() {
                                            // Remove item from the list
                                            _items.removeAt(index);

                                          });
                                        }
                                      },
                                      background: Container(
                                        color: Colors
                                            .red, // Background color when swiping
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 20),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => Description(Loc_id: locations[index]['Loc_id'])),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 3),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFBFB4AD),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                                  child: ListTile(
                                                    leading: Image.network(
                                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYArSfFlMh4VhBz3tYLefzqGLnDtzeSulxxQ&s',
                                                      width:
                                                          175.0, // Width of the image
                                                      height:
                                                          250.0, // Height of the image
                                                      fit: BoxFit
                                                          .cover, // How the image should be inscribed into the box
                                                    ),
                                                    title: Text(locations[index]
                                                        ['Name']),
                                                    subtitle: Text(
                                                        locations[index]['Cost']
                                                            .toString()),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Dismissible(
                                  key: Key(_items[index]
                                      .toString()), // Unique key for each item
                                  direction: DismissDirection
                                      .startToEnd, // Swipe direction
                                  onDismissed: (direction) async {
                                    // Show confirmation dialog
                                    bool replace =
                                        await _showConfirmationDialog(context);
                                    db.deleteLocation(locations[index]['Loc_id'], locations[index]['Schedule_id']);

                                    if (replace) {
                                      // Show location selection dialog
                                      int? selectedLocation =
                                          await _showLocationSelectionDialog(
                                              context, db.addLocation, locations[index]['Schedule_id'] );
                                      if (selectedLocation != null) {
                                        setState(() {
                                          // Replace the item with the new location
                                          _items[index] = selectedLocation;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        // Remove item from the list
                                        _items.removeAt(index);
                                      });
                                    }
                                  },
                                  background: Container(
                                    color: Colors
                                        .red, // Background color when swiping
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 20),
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => Description(Loc_id: locations[index]['Loc_id'])),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 3),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(0xFFBFB4AD),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                              child: ListTile(
                                                leading: Image.network(
                                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYArSfFlMh4VhBz3tYLefzqGLnDtzeSulxxQ&s',
                                                  width:
                                                      175.0, // Width of the image
                                                  height:
                                                      250.0, // Height of the image
                                                  fit: BoxFit
                                                      .cover, // How the image should be inscribed into the box
                                                ),
                                                title: Text(
                                                    locations[index]['Name']),
                                                subtitle: Text(locations[index]
                                                        ['Cost']
                                                    .toString()),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            itemCount: locations.length),
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Do you want to replace with a new location?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Return false if "No" is pressed
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Return true if "Yes" is pressed
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed
  }

  Future<int?> _showLocationSelectionDialog(BuildContext context, Function(int, int) addLocation, int scheduleId) async {
    int selectedLocId = -1; // Default value for no selection

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select a Location'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile<int>(
                      value: 9,
                      groupValue: selectedLocId,
                      title: Text('Chew Jetty, Georgetown'),
                      onChanged: (value) {
                        setState(() {
                          selectedLocId = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      value: 10,
                      groupValue: selectedLocId,
                      title: Text('Penang Street Art, 316, Beach St, Georgetown'),
                      onChanged: (value) {
                        setState(() {
                          selectedLocId = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      value: 11,
                      groupValue: selectedLocId,
                      title: Text('Hin Bus Depot, 31A, Jalan Gurdwara, 10300 George Town'),
                      onChanged: (value) {
                        setState(() {
                          selectedLocId = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    addLocation(selectedLocId, scheduleId);
                    Navigator.of(context).pop(selectedLocId);
                    setState(){
                    };
                    _showScheduledPopup(scheduleId);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
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

  void _showScheduledPopup(int Schedule_id) {
    Timer(Duration(seconds: 5), () {
      // Show a pop-up after 5 seconds
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              'Are you satisfied with the Day 1 schedule?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, // Adjust font size here
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle the 'Yes' action here
                      Navigator.of(context).pop(true); // Pass a value to indicate 'Yes'
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(fontSize: 18), // Adjust font size
                    ),
                  ),
                  SizedBox(width: 20), // Add space between buttons
                  TextButton(
                    onPressed: () {
                      // Handle the 'No' action here
                      Navigator.of(context).pop(false); // Pass a value to indicate 'No'

                      // Show another dialog if 'No' is clicked
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              'Would you like to reschedule the Day 2 schedule?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20, // Adjust font size here
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center, // Center align buttons
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      db.replanning(Schedule_id);
                                      Navigator.of(context).pop(true);
                                      setState(() {
                                        
                                      });
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(fontSize: 18), // Adjust font size
                                    ),
                                  ),
                                  SizedBox(width: 16), // Space between buttons
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false); // Return false for No
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(fontSize: 18), // Adjust font size
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },

                      );
                    },
                    child: Text(
                      'No',
                      style: TextStyle(fontSize: 18), // Adjust font size
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ).then((result) {
        if (result != null) {
          if (result) {
            setState(() {

            });
          } else {
            setState(() {

            });
          }
        }
        setState(() {

        });
      });
    });
  }

}
