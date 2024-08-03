import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:travel/pages/filter.dart';
import 'package:travel/services/db.dart';

class HomePage extends StatefulWidget {
  int id;
  HomePage({super.key, required this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  late int _currentPage;
  final _dbService = DBService();
  List<String> _tags = [
    'fun',
    'nature',
    'culture',
    'music',
    'interactive',
    'food',
    'history',
    'entertainment',
    'outdoor',
    'indoor'
  ];
  List<String> _selectedTags = [];
  double _tripBudget = 1000.0;
  double _hotelBudget = 500.0;
  String? _selectedState;
  DateTime? _startDate;
  DateTime? _endDate;

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
          int nextPage = (_currentPage + 1) %
              _imagePaths.length; // Use length of imagePaths list
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

  void _showMultiSelectDialog() async {
    final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          tags: _tags,
          selectedTags: _selectedTags,
          tripBudget: _tripBudget,
          hotelBudget: _hotelBudget,
          selectedState: _selectedState,
          startDate: _startDate,
          endDate: _endDate,
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedTags = List<String>.from(result['selectedTags']);
        _tripBudget = result['tripBudget'];
        _hotelBudget = result['hotelBudget'];
        _selectedState = result['selectedState'];
        _startDate = result['startDate'];
        _endDate = result['endDate'];
      });

      List<int> locations = await _dbService.fetchLocation(_selectedTags);
      print('Fetched locations: $locations');

      await _dbService.addScheduleAndLocations(locations);

      print('Selected tags: $_selectedTags');
      print('Trip Budget: \$${_tripBudget.toStringAsFixed(0)}');
      print('Hotel Budget: \$${_hotelBudget.toStringAsFixed(0)}');
      print('Selected State: $_selectedState');
      print(
          'Trip Dates: ${_startDate?.toLocal().toString().split(' ')[0]} to ${_endDate?.toLocal().toString().split(' ')[0]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color(0xFF97AFB8),
        toolbarHeight: 80.0,
        leading: IconButton(
          icon: Icon(Icons.filter_alt_outlined, color: Colors.white, size: 35),
          onPressed: _showMultiSelectDialog,
        ),
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
              SizedBox(width: 10),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // Add a PageView for horizontal scrolling
                Container(
                  height: screenWidth * 0.5, // Adjust height as needed
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount:
                        _imagePaths.length, // Use length of imagePaths list
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
                        child: ClipRRect(
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
                            color: _currentPage == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            // Venue Cards
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Top Picks',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  VenueCard(
                    imageUrl: 'images/TiomanIsland.jpg',
                    name: 'Pulau Tioman, Pahang',
                  ),
                  VenueCard(
                    imageUrl: 'images/KekLongTong.jpg',
                    name: 'Kek Lok Tong Cave Temple, Ipoh',
                  ),
                  VenueCard(
                    imageUrl: 'images/BatuFerringhi.jpg',
                    name: 'Batu Ferringhi, Penang',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Melaka',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  VenueCard(
                    imageUrl: 'images/AFamosa.jpg',
                    name: 'A Famosa',
                  ),
                  VenueCard(
                    imageUrl: 'images/RiverWalk.jpg',
                    name: 'River Walk',
                  ),
                  VenueCard(
                    imageUrl: 'images/NyonyaVillage.jpg',
                    name: 'Nyonya Village Melaka',
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 65,
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
    // Get the screen width and height from MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    // Set a fixed width for the container as a percentage of the screen width
    final containerWidth =
        screenWidth * 0.6; // 50% of the screen width, adjust as needed
    final imageHeight =
        containerWidth * 0.5; // 60% of the container width for image height

    return Container(
      width: containerWidth,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adjust image width and height to fit within the container
            Image.asset(
              widget.imageUrl,
              width: containerWidth, // Make the image fill the container width
              height:
                  imageHeight, // Set the height as a proportion of the container width
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Add padding around Row
              child: Row(
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
                  Expanded(
                    child: Text(
                      widget.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.visible, // Allows text to wrap
                      softWrap: true, // Enables text wrapping
                    ),
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
