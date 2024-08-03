import 'package:flutter/material.dart';
import 'package:travel/services/db.dart';

class Description extends StatefulWidget {
  final String rating;
  int Loc_id;

  Description({
    super.key,
    this.rating = '4.3/5',
    required this.Loc_id,
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    DBService db = DBService();
    final image = 'https://via.placeholder.com/300';
    final ratingParts = widget.rating.split('/');
    
    String formatTime(String timeString) {
      // Check if the time string contains milliseconds
      if (timeString.contains('.')) {
        return timeString.split('.').first; // Truncate milliseconds
      }
      return timeString; // Return as is if no milliseconds
    }
    return Scaffold(
      backgroundColor: const Color(0xFFfef5f1),
      body: Stack(
        children: [
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FutureBuilder(
                future: db.fetchDescription(widget.Loc_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No locations found'));
                  } else {
                    final data = snapshot.data;
                    List<Map<String, dynamic>> location = [];
                    for (var row in data!) {
                      location.add({
                        'Name': row['Name'],
                        'Description': row['Description'],
                        'Cost': row['Cost'],
                        'Review': row['Review'],
                        'start_time': row['start_time'],
                        'end_time': row['end_time'],
                      });
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 600.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                                child: Image.network(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40.0,
                              left: 16.0,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Positioned(
                              bottom: 20.0,
                              left: 16.0,
                              right: 16.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          location[0]['Name'],
                                          style: TextStyle(
                                            fontSize: 38.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0,
                                                color: Colors.black,
                                                offset: Offset(2.0, 2.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      SizedBox(width: 5,),
                                      Text(
                                        "${formatTime(location[0]['start_time'].toString())} -${formatTime(location[0]['end_time'].toString())}",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.favorite,
                                          color: Color(
                                              0xFF78231D), // Updated color
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          // Add save logic here
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader("Information", "more"),
                                SizedBox(height: 10.0),
                                Text(
                                  location[0]['Description'],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(thickness: 1.0, color: Colors.grey[300]),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionHeader(
                                    "Reviews (300 ratings)", "View All"),
                                SizedBox(height: 10.0),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    ReviewCard(
                                      reviewerName: "johndoe0101",
                                      reviewText:
                                          location[0]['Review'],
                                    ),
                                    ReviewCard(
                                      reviewerName: "janesmith0202",
                                      reviewText:
                                          "Had a wonderful time. Would highly recommend it!",
                                    ),
                                    ReviewCard(
                                      reviewerName: "alicejohnson0303",
                                      reviewText:
                                          "A must-visit place. The scenery is just stunning!",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Color(0xFFE7DACC), // Updated color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFF78231D)),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Say something...',
                            hintStyle: TextStyle(color: Color(0xFF78231D)),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Handle action
          },
          child: Text(
            action,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String reviewerName;
  final String reviewText;

  const ReviewCard({
    Key? key,
    required this.reviewerName,
    required this.reviewText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reviewerName,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              reviewText,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
