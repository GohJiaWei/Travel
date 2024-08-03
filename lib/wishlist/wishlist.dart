import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final List<String> tourismSpots = [
    'Pulau Tioman, Pahang',
    'A Famosa, Melaka',
    'River Walk, Melaka',
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tourism Wishlist'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: tourismSpots.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: Icon(Icons.place),
                title: Text(tourismSpots[index]),
                trailing: IconButton(
                  icon: Icon(Icons.favorite),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      tourismSpots.removeAt(index);
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
