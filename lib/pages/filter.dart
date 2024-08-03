import 'package:flutter/material.dart';
import 'package:travel/services/db.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<String> selectedTags;
  final double tripBudget;
  final double hotelBudget;
  final String? selectedState;
  final DateTime? startDate;
  final DateTime? endDate;

  MultiSelectDialog({
    required this.selectedTags,
    required this.tripBudget,
    required this.hotelBudget,
    required this.selectedState,
    required this.startDate,
    required this.endDate,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _selectedTags;
  late double _tripBudget;
  late double _hotelBudget;
  String? _selectedState;
  DateTime? _startDate;
  DateTime? _endDate;
  DBService db = DBService();

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _tripBudget = widget.tripBudget;
    _hotelBudget = widget.hotelBudget;
    _selectedState = widget.selectedState;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Travel Filters',
        style: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.bold, // You can adjust the font size as needed
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Picker
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 15.0),
              child: Divider(
                thickness: 2.0, // Adjust the thickness
                color: Colors.black, // Change the color
                // Add padding to the left
              ),
            ),
            Text(
              'Trip Dates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19.0, // Adjust the font weight
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _selectDateRange,
              child: Text(
                _startDate != null && _endDate != null
                    ? 'From ${_startDate!.toLocal().toString().split(' ')[0]} to ${_endDate!.toLocal().toString().split(' ')[0]}'
                    : 'Select date range',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17.0, // Adjust the font size here
                ),
              ),
            ),
            SizedBox(height: 20),

            // Trip Budget Slider
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20.0),
              child: Divider(
                thickness: 1.0, // Adjust the thickness
                color: Colors.grey, // Change the color
                // Add padding to the left
              ),
            ),
            Text(
              'Trip Budget: \$${_tripBudget.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19.0, // Adjust the font weight
              ),
            ),
            Slider(
              value: _tripBudget,
              min: 0,
              max: 5000,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _tripBudget = value;
                });
              },
            ),
            SizedBox(height: 20),

            // State Travel Dropdown
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20.0),
              child: Divider(
                thickness: 1.0,
                color: Colors.grey,
              ),
            ),
            Text(
              'Area Travel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19.0,
              ),
            ),
            SizedBox(height: 13.0), // Adjust the height to your desired space
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: InputBorder.none,
                ),
                hint: Text('Select an area'),
                items: [
                  'George Town, Penang',
                  'Teluk Bahang, Penang',
                  'Pulau Langkawi, Kedah',
                  'Bahau, Negeri Sembilan'
                ].map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                  });
                },
                isExpanded: true,
              ),
            ),
            SizedBox(height: 20),

            // Tags Multi-Select
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20.0),
              child: Divider(
                thickness: 1.0, // Adjust the thickness
                color: Colors.grey, // Change the color
                // Add padding to the left
              ),
            ),
            Text(
              'Tags',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19.0, // Adjust the font weight
              ),
            ),
            SizedBox(height: 13.0),
            FutureBuilder(
                future: db.fetchTag(),
                builder: (context, snapshot){

                  final data = snapshot.data;
                  if (data == null || data.isEmpty) {
                    return CircularProgressIndicator();
                  }
                  List<Map<String, dynamic>> tags = [];
                  for (var row in data!) {
                    tags.add({
                      'name': row['Tag_name'],
                    });
                  }
                  return Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: tags.map((tag) {
                      return FilterChip(
                        label: Text(
                          tag['name'],
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        selected: _selectedTags.contains(tag['name']),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag['name']);
                            } else {
                              _selectedTags.remove(tag['name']);
                            }
                          });
                        },
                      );
                    }).toList(), // Convert Iterable to List
                  );
                }
            ),
            SizedBox(height: 20),

            // Hotel Budget Slider
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 20.0),
              child: Divider(
                thickness: 1.0, // Adjust the thickness
                color: Colors.grey, // Change the color
                // Add padding to the left
              ),
            ),
            Text(
              'Hotel Budget: \$${_hotelBudget.toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19.0, // Adjust the font weight
              ),
            ),
            Slider(
              value: _hotelBudget,
              min: 0,
              max: 2000,
              divisions: 100,
              onChanged: (value) {
                setState(() {
                  _hotelBudget = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Done'),
          onPressed: () {
            Navigator.of(context).pop({
              'selectedTags': _selectedTags,
              'tripBudget': _tripBudget,
              'hotelBudget': _hotelBudget,
              'selectedState': _selectedState,
              'startDate': _startDate,
              'endDate': _endDate,
            });
          },
        ),
      ],
    );
  }
}