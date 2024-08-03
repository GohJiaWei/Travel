import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    late PageController _pageController;
  late int _currentPage;

  // List of image paths
  final List<String> _imagePaths = [
    'images/ad 1.avif',
    'images/ad 2.avif',
    'images/ad 3.avif',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPage = 0;
    
    // Automatically scroll images every 3 seconds
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          int nextPage = (_currentPage + 1) % _imagePaths.length; // Use length of imagePaths list
          _pageController.animateToPage(
            nextPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = nextPage;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF97AFB8),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0), // Add bottom padding
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF97AFB8)),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    // Handle search input change
                    print('Search: $value');
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.filter_alt_outlined, color: Colors.white,size: 35,),
                onPressed: () {
                  // Handle filter button press
                  print('Filter pressed');
                },
              ),
          
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     // Add a PageView for horizontal scrolling
            //     Container(
            //       height: screenWidth * 0.5, // Adjust height as needed
            //       child: PageView.builder(
            //         controller: _pageController,
            //         itemCount: _imagePaths.length, // Use length of imagePaths list
            //         onPageChanged: (index) {
            //           setState(() {
            //             _currentPage = index;
            //           });
            //         },
            //         itemBuilder: (context, index) {
            //           // Use local images from assets
            //           final imagePath = _imagePaths[index];
            //           return Container(
            //             margin: EdgeInsets.symmetric(horizontal: 8.0),
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(12.0),
            //               child: Image.asset(
            //                 imagePath,
            //                 fit: BoxFit.cover,
            //                 width: screenWidth * 0.8, // Adjust width as needed
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     ),
            //     // Add a circular bullet indicator at the bottom center
            //     Positioned(
            //       bottom: 10,
            //       child: Container(
            //         height: 20,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: List.generate(_imagePaths.length, (index) {
            //             return Container(
            //               margin: EdgeInsets.symmetric(horizontal: 4.0),
            //               width: 10,
            //               height: 10,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: _currentPage == index ? Colors.blue : Colors.grey,
            //               ),
            //             );
            //           }),
            //         ),
            //       ),
            //     ),

            //   ],
            // ),
            // Venue Cards
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Top Picks', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  VenueCard(
                    imageUrl: 'assets/venue1.jpg',
                    name: 'Venue 1',
                    rating: 4.5,
                  ),
                  VenueCard(
                    imageUrl: 'assets/venue2.jpg',
                    name: 'Venue 2',
                    rating: 4.0,
                  ),
                  VenueCard(
                    imageUrl: 'assets/venue3.jpg',
                    name: 'Venue 3',
                    rating: 4.8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VenueCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double rating;

  VenueCard({required this.imageUrl, required this.name, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imageUrl, width: 160, height: 120, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('Rating: $rating', style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }
}
