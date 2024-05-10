import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  String _bookName = '';
  String _author = '';
  String _advertisementDescription = '';
  String _genre = 'Şiir'; // default value
  String _bookState = 'Yeni'; // default value
  File? galleryFile;
  final picker = ImagePicker();
  bool _isSuspended = false;

  final List<String> _genres = [  'Şiir',
    'Gerilim',
    'Tarih-Coğrafya',
    'Kişisel Gelişim',
    'Siyaset',
    'Eğitim',
    'Çocuk',
    'Felsefi',];
  final List<String> _bookStates = ['Yeni', 'Eski', 'Yıpranmış'];

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img,) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
  
  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');

    final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book');

    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _bookName,
          'author': _author,
          'genre': _genre,
          'stateOfBook': _bookState,
          'description': _advertisementDescription,
          'isAskida': _isSuspended,
          'bookImage': galleryFile != null ? galleryFile!.path : null,
        }),
      );

      if (response.statusCode == 201) {
        // Book added successfully
        print('Book added successfully');
        // You can navigate to another page or show a success message here
      } else {
        // Book addition failed
        print('Failed to add book: ${response.body}');
        // You can show an error message here
      }
    } catch (e) {
      print('Error adding book: $e');
      // You can show an error message here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 70),
              GestureDetector(
                onTap: () => _showPicker(context: context),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: galleryFile != null
                        ? DecorationImage(
                      image: FileImage(File(galleryFile!.path)),
                      fit: BoxFit.contain,
                    )
                        : null,
                  ),
                  child: galleryFile == null
                      ? Icon(
                    Icons.photo_library,
                    color: Colors.grey[600],
                    size: 60,
                  )
                      : null,
                ),
              ),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Book Name',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onSaved: (value) => _bookName = value!,
              ),
              SizedBox(height: 40),
              DropdownButtonFormField(
                value: _genre,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                items: _genres.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _genre = newValue as String;
                  });
                },
              ),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Author',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onSaved: (value) => _author = value!,
              ),
              SizedBox(height: 40),
              DropdownButtonFormField(
                value: _bookState,
                decoration: InputDecoration(
                  labelText: 'State of the Book',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                items: _bookStates.map((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _bookState = newValue as String;
                  });
                },
              ),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Advertisement Description',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                onSaved: (value) => _advertisementDescription = value!,
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text('Askıda Kitap Olsun'),
                value: _isSuspended,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isSuspended = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              ElevatedButton(
                onPressed: _addBook,
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
