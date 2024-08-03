import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  final String image, name, detail, price, rating;

  Description({
    super.key,
    this.detail =
        'The Lake District is a region and national park in Cumbria in Northwest England. A popular vacation destination, it\'s known for its glacial ribbon lakes, rugged fell mountains, and historic literary associations. Lake District National Park offers picturesque landscapes and numerous outdoor activities.',
    this.image = 'https://via.placeholder.com/300',
    this.name = 'The TOP Komtar, Theme Park Penang',
    this.price = '99.99',
    this.rating = '4.3/5',
  });

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    final nameParts = widget.name.split(', ');
    final ratingParts = widget.rating.split('/');

    return Scaffold(
      backgroundColor: const Color(0xFFfef5f1),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
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
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40.0,
                      left: 16.0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                                  nameParts[0],
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
                          SizedBox(height: 0.0),
                          Text(
                            nameParts.length > 1 ? nameParts[1] : '',
                            style: TextStyle(
                              fontSize: 24.0,
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
                          SizedBox(height: 15.0),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.orange, size: 30.0),
                              SizedBox(width: 8.0),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: ratingParts[0],
                                      style: TextStyle(
                                        fontSize: 22.0,
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
                                    TextSpan(
                                      text: '/${ratingParts[1]}',
                                      style: TextStyle(
                                        fontSize: 19.0,
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
                                  ],
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Color(0xFF78231D), // Updated color
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
                          widget.detail,
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ReviewCard(
                              reviewerName: "johndoe0101",
                              reviewText:
                                  "Amazing experience! The views are breathtaking.",
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
                            SizedBox(height: 55.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
