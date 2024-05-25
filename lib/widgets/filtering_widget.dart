import 'package:bookcycle/service/get_filtered_books.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Book.dart';
import '../pages/fileter_results_page.dart';

class FilterWidget extends StatefulWidget {
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  String? selectedCity;
  String? selectedState;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool? _isSuspended = null;

  List<String> genres = [
    'Şiir',
    'Gerilim',
    'Tarih-Coğrafya',
    'Kişisel Gelişim',
    'Siyaset',
    'Eğitim',
    'Çocuk',
    'Felsefi',
  ];
  List<String> cities = ['İstanbul', 'İzmir', 'Ankara', 'Antalya'];
  List<String> stateOfBook = ['Yeni', 'Eski', 'Yıpranmış'];

  List<bool> selectedGenres = List<bool>.generate(8, (_) => false);

  // Extract selected genres to a list
  List<String> selectedGenresList() {
    List<String> list = [];
    for (int i = 0; i < genres.length; i++) {
      if (selectedGenres[i]) {
        list.add(genres[i]);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.01;
    return Column(
      children: <Widget>[
        SizedBox(height: height),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Tür:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: height),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8.0,
              runSpacing: 8.0,
              children: List<Widget>.generate(genres.length, (int index) {
                return ChoiceChip(
                  label: Text(genres[index]),
                  selected: selectedGenres[index],
                  onSelected: (bool selected) {
                    setState(() {
                      selectedGenres[index] = selected;
                    });
                  },
                  backgroundColor: Colors.grey.shade300,
                  selectedColor: Colors.deepOrange.shade300,
                  labelStyle: TextStyle(
                    color: selectedGenres[index] ? Colors.white : Colors.black,
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: height),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Tarih:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: height),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Başlangıç',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Bitiş',
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        IntrinsicWidth(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    selectedStartDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedStartDate!)
                        : '__/__/____',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedStartDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      if (selectedEndDate != null &&
                          picked.isAfter(selectedEndDate!)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Uyarı'),
                              content: Text(
                                  'Başlangıç tarihi, bitiş tarihinden sonra olamaz!'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        setState(() {
                          selectedStartDate = picked;
                        });
                      }
                    }
                  },
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.deepOrange.shade300),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  label: Text(
                    selectedEndDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedEndDate!)
                        : '__/__/____',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedEndDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      if (selectedStartDate != null &&
                          picked.isBefore( selectedStartDate!.add(Duration(days: 1)))) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Uyarı'),
                              content: Text(
                                  'Bitiş tarihi, başlangıç tarihiyle aynı veya önce olamaz!'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        setState(() {
                          selectedEndDate = picked;
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Durum:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: height),
        DropdownButton<String>(
          hint: Text('Kitabın Durumu'),
          value: selectedState,
          onChanged: (String? newValue) {
            setState(() {
              selectedState = newValue;
            });
          },
          items: stateOfBook.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        SizedBox(height: height),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Şehir:',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: height),
        DropdownButton<String>(
          hint: Text('Şehir seçin'),
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
        SizedBox(height: height),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Askıda Kitap?'),
                    DropdownButton<bool>(
                      value: _isSuspended,
                      items: [
                        DropdownMenuItem<bool>(
                          value: true,
                          child: Text("Evet"),
                        ),
                        DropdownMenuItem<bool>(
                          value: false,
                          child: Text("Hayır"),
                        ),
                      ],
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isSuspended = newValue!;
                        });
                      },
                    ),

                    SizedBox(width: height),

                  ],
                ),
              ),
              SizedBox(height: height*2),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade300,
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  child: Text(
                    'Uygula',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    String? startDate = selectedStartDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedStartDate!)
                        : null;
                    String? endDate = selectedEndDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedEndDate!)
                        : null;

                    Future<List<Book>> list = getFilteredBooks(
                        selectedGenresList(), _isSuspended, startDate, endDate);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FilterResultsPage(books2: list),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
