// ?dismiaible error


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class SchedulePage extends StatefulWidget {
//   const SchedulePage({super.key});

//   @override
//   State<SchedulePage> createState() => _SchedulePageState();
// }

// class _SchedulePageState extends State<SchedulePage> {
//   final locationController = Location();
  
//   static const googlePlex = LatLng(37.4223, -122.0848);
//   static const mountainView = LatLng(37.3861, -122.0839);
  
//   LatLng? currentPosition;
//   Map<PolylineId, Polyline> polylines = {};
//   int? _selectedLocation; // Variable to hold the selected radio button value
//   List<int> _items = List.generate(5, (index) => index); // List to manage items
  
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) async => await initializeMap());
//   }
  
//   Future<void> initializeMap() async {
//     await fetchLocationUpdates();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 60,),
//           Center(
//             child: Container(
//               width: 400,
//               height: 200,
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: googlePlex,
//                   zoom: 10,
//                 ),
//                 markers: {
//                   Marker(
//                     markerId: MarkerId('sourceLocation'),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: googlePlex,
//                   ),
//                   Marker(
//                     markerId: MarkerId('destinationLocation'),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: mountainView,
//                   )
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 10,),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _items.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Dismissible(
//                   key: Key(_items[index].toString()), // Unique key for each item
//                   direction: DismissDirection.startToEnd, // Swipe direction
//                   onDismissed: (direction) {
//                     // Remove item from the list
//                     setState(() {
//                       _items.removeAt(index);
//                     });

//                     // Show dialog when item is dismissed
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Select a Location'),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               RadioListTile<int>(
//                                 value: 1,
//                                 groupValue: _selectedLocation,
//                                 title: Text('Location 1'),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedLocation = value;
//                                   });
//                                 },
//                               ),
//                               RadioListTile<int>(
//                                 value: 2,
//                                 groupValue: _selectedLocation,
//                                 title: Text('Location 2'),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedLocation = value;
//                                   });
//                                 },
//                               ),
//                               RadioListTile<int>(
//                                 value: 3,
//                                 groupValue: _selectedLocation,
//                                 title: Text('Location 3'),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _selectedLocation = value;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 // Handle any action based on selected location
//                                 if (_selectedLocation != null) {
//                                   print('Selected Location: $_selectedLocation');
//                                 }
//                               },
//                               child: Text('OK'),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   background: Container(
//                     color: Colors.red, // Background color when swiping
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.only(left: 20),
//                     child: Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Handle item tap
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text('9.00 am to 5.00 pm'),
//                           ),
//                           SizedBox(height: 3),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Color(0xFFBFB4AD),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//                               child: ListTile(
//                                 leading: Image.network(
//                                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYArSfFlMh4VhBz3tYLefzqGLnDtzeSulxxQ&s',
//                                   width: 175.0, // Width of the image
//                                   height: 250.0, // Height of the image
//                                   fit: BoxFit.cover, // How the image should be inscribed into the box
//                                 ),
//                                 title: Text('The Enchanted Nightingale'),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Future<void> fetchLocationUpdates() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
    
//     serviceEnabled = await locationController.serviceEnabled();
//     if (serviceEnabled) {
//       serviceEnabled = await locationController.requestService();
//     } else {
//       return;
//     }
    
//     permissionGranted = await locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
    
//     locationController.onLocationChanged.listen((currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           currentPosition = LatLng(
//             currentLocation.latitude!,
//             currentLocation.longitude!,
//           );
//         });
//       }
//     });
//   }
  
//   Future<void> generatePolyLineFromPoints(
//       List<LatLng> polylineCoordinates) async {
//     const id = PolylineId('polyline');
    
//     final polyline = Polyline(
//       polylineId: id,
//       color: Colors.blueAccent,
//       points: polylineCoordinates,
//       width: 5,
//     );
    
//     setState(() => polylines[id] = polyline);
//   }
// }






// delete, pop yes or no, choose location


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class SchedulePage extends StatefulWidget {
//   const SchedulePage({super.key});

//   @override
//   State<SchedulePage> createState() => _SchedulePageState();
// }

// class _SchedulePageState extends State<SchedulePage> {
//   final locationController = Location();

//   static const googlePlex = LatLng(37.4223, -122.0848);
//   static const mountainView = LatLng(37.3861, -122.0839);

//   LatLng? currentPosition;
//   Map<PolylineId, Polyline> polylines = {};
//   int? _selectedLocation; // Variable to hold the selected radio button value
//   List<int> _items = List.generate(5, (index) => index); // List to manage items

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) async => await initializeMap());
//   }

//   Future<void> initializeMap() async {
//     await fetchLocationUpdates();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 60,),
//           Center(
//             child: Container(
//               width: 400,
//               height: 200,
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: googlePlex,
//                   zoom: 10,
//                 ),
//                 markers: {
//                   Marker(
//                     markerId: MarkerId('sourceLocation'),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: googlePlex,
//                   ),
//                   Marker(
//                     markerId: MarkerId('destinationLocation'),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: mountainView,
//                   )
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 10,),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _items.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Dismissible(
//                   key: Key(_items[index].toString()), // Unique key for each item
//                   direction: DismissDirection.startToEnd, // Swipe direction
//                   onDismissed: (direction) async {
//                     // Show confirmation dialog
//                     bool replace = await _showConfirmationDialog(context);
//                     if (replace) {
//                       // Show location selection dialog
//                       int? selectedLocation = await _showLocationSelectionDialog(context);
//                       if (selectedLocation != null) {
//                         setState(() {
//                           // Replace the item with the new location
//                           _items[index] = selectedLocation;
//                         });
//                       }
//                     } else {
//                       setState(() {
//                         // Remove item from the list
//                         _items.removeAt(index);
//                       });
//                     }
//                   },
//                   background: Container(
//                     color: Colors.red, // Background color when swiping
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.only(left: 20),
//                     child: Icon(
//                       Icons.delete,
//                       color: Colors.white,
//                     ),
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       // Handle item tap
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text('9.00 am to 5.00 pm'),
//                           ),
//                           SizedBox(height: 3),
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Color(0xFFBFB4AD),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//                               child: ListTile(
//                                 leading: Image.network(
//                                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYArSfFlMh4VhBz3tYLefzqGLnDtzeSulxxQ&s',
//                                   width: 175.0, // Width of the image
//                                   height: 250.0, // Height of the image
//                                   fit: BoxFit.cover, // How the image should be inscribed into the box
//                                 ),
//                                 title: Text('The Enchanted Nightingale'),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> _showConfirmationDialog(BuildContext context) async {
//     return await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Do you want to replace with a new location?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false); // Return false if "No" is pressed
//               },
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // Return true if "Yes" is pressed
//               },
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     ) ?? false; // Default to false if dialog is dismissed
//   }

//   Future<int?> _showLocationSelectionDialog(BuildContext context) async {
//     return showDialog<int>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select a Location'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 RadioListTile<int>(
//                   value: 1,
//                   groupValue: _selectedLocation,
//                   title: Text('Location 1'),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedLocation = value;
//                     });
//                   },
//                 ),
//                 RadioListTile<int>(
//                   value: 2,
//                   groupValue: _selectedLocation,
//                   title: Text('Location 2'),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedLocation = value;
//                     });
//                   },
//                 ),
//                 RadioListTile<int>(
//                   value: 3,
//                   groupValue: _selectedLocation,
//                   title: Text('Location 3'),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedLocation = value;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(_selectedLocation);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> fetchLocationUpdates() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;

//     serviceEnabled = await locationController.serviceEnabled();
//     if (serviceEnabled) {
//       serviceEnabled = await locationController.requestService();
//     } else {
//       return;
//     }

//     permissionGranted = await locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }

//     locationController.onLocationChanged.listen((currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           currentPosition = LatLng(
//             currentLocation.latitude!,
//             currentLocation.longitude!,
//           );
//         });
//       }
//     });
//   }

//   Future<void> generatePolyLineFromPoints(
//       List<LatLng> polylineCoordinates) async {
//     const id = PolylineId('polyline');

//     final polyline = Polyline(
//       polylineId: id,
//       color: Colors.blueAccent,
//       points: polylineCoordinates,
//       width: 5,
//     );

//     setState(() => polylines[id] = polyline);
//   }
// }

