import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedCity;
  String? selectedGenre;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool isAscending = true;

  // Bu kısımları veritabanınız veya state yönetiminiz ile bağlayabilirsiniz
  List<String> genres = ['Romance', 'Horror', 'Fantasy', 'Historical', 'Travel', 'Politics', 'Educational'];
  List<String> cities = ['İstanbul', 'İzmir', 'Ankara', 'Antalya'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Genre:',
            style: TextStyle(fontFamily: 'LexendExa',fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: genres.map((genre) => ChoiceChip(
            label: Text(genre),
            selected: selectedGenre == genre,
            onSelected: (selected) {
              setState(() {
                selectedGenre = genre;
              });
            },
          )).toList(),
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Date:',
            style: TextStyle(fontFamily: 'LexendExa',fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF88C4A8),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Text('Start Date',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedStartDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedStartDate)
                  setState(() {
                    selectedStartDate = picked;
                  });
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF88C4A8),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
              child: Text('End Date',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedEndDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedEndDate)
                  setState(() {
                    selectedEndDate = picked;
                  });
              },
            ),
          ],
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Alphabetical Order:',
            style: TextStyle(fontFamily: 'LexendExa',fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Alphabetical Order'),
            Switch(
              value: isAscending,
              onChanged: (value) {
                setState(() {
                  isAscending = value;
                });
              },
              activeColor: Color(0xFF98C2AC),
              activeTrackColor: Color(0xFFABE8CD),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade300,
            ),
            Text(isAscending ? 'A to Z' : 'Z to A'),
          ],
        ),
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'City:',
            style: TextStyle(fontFamily: 'LexendExa',fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          hint: Text('Select City'),
          value: selectedCity,
          onChanged: (String? newValue) {
            setState(() {
              selectedCity = newValue;
            });
          },
          items: cities.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
