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
    'images/advertisement1.jpeg',
    'images/advertisement2.jpeg',
    'images/advertisement3.jpeg',
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
      // backgroundColor: Colors.grey[300],
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
            SizedBox(height: 20,),
            Stack(
              alignment: Alignment.center,
              children: [
                // Add a PageView for horizontal scrolling
                Container(
                  height: screenWidth * 0.5, // Adjust height as needed
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _imagePaths.length, // Use length of imagePaths list
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      // Use local images from assets
                      final imagePath = _imagePaths[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //   color: Colors.black, // Outline color
                        //   width: 1.0, // Outline width
                        // ),),
                        child: ClipRRect(
                          
                          // borderRadius: BorderRadius.circular(12.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: screenWidth * 0.8, // Adjust width as needed
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Add a circular bullet indicator at the bottom center
                Positioned(
                  bottom: 10,
                  child: Container(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_imagePaths.length, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index ? Colors.blue : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ),

              ],
            ),
            // Venue Cards
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Top Picks', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  VenueCard(
                    imageUrl: 'images/login.png',
                    name: 'Batu Ferringhi, Penang',
                  ),
                  VenueCard(
                    imageUrl: 'images/login.png',
                    name: 'Sg. Siput, Perak',
                  ),
                  VenueCard(
                    imageUrl: 'images/login.png',
                    name: 'Pulau Tioman,',
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

class VenueCard extends StatefulWidget {
  final String imageUrl;
  final String name;

  VenueCard({required this.imageUrl, required this.name});

  @override
  State<VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {
  bool isFavorited = false;

  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
      if (isFavorited) {
        print('Added ${widget.name} to collection');
      } else {
        print('Removed ${widget.name} from collection');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(widget.imageUrl,
              width: 165, height: 140, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: toggleFavorite,
                  icon: Icon(
                    isFavorited
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: isFavorited ? Colors.red : Colors.grey,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
