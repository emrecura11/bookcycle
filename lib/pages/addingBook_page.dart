import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../service/upload_image.dart';
import 'home_page.dart';

class AddBookPage extends StatefulWidget {
  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  String _bookName = '';
  String _author = '';
  String _advertisementDescription = '';
  String _genre = 'Tarih'; // default value
  String _bookState = 'Yeni'; // default value
  File? galleryFile;
  final picker = ImagePicker();
  bool _isSuspended = false;

  final List<String> _genres = [
    'Tarih',
    'Kurgu',
    'Korku',
    'Biyografi',
    'Bilim Kurgu',
    'Polisiye',
    'Klasikler',
    'Çocuk Kitapları',
    'Şiir',
    'Felsefe-Dini',
    'Kişisel Gelişim',
    'Bilim-Teknoloji',
    'Politika-Ekonomi',
    'Gezi',
    'Sağlık-Psikolji',
    'Eğitim',
  ];

  final List<String> _bookStates = [
    'Yeni',
    'Eski',
    'Yıpranmış',
  ];

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Fotoğraf Galerisi'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
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

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(() {
      if (xfilePick != null) {
        galleryFile = File(pickedFile!.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Hiçbir şey seçilmedi')));
      }
    });
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate() || galleryFile == null) {
      if (galleryFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lütfen kitap fotoğrafını yükleyin')));
      }
      return;
    }
    _formKey.currentState!.save();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');

    final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book');
    String? base64Image;
    if (galleryFile != null) {
      base64Image = await UploadImageService().uploadImageAsBase64(galleryFile!);
    }
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
          'bookImage': base64Image,
        }),
      );

      if (response.statusCode == 201) {
        // Book added successfully
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kitap başarıyla eklendi')));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
        // Navigate to another page or show a success message here
      } else {
        // Book addition failed
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kitap ekleme başarısız: ${response.body}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kitap eklenirken hata oluştu: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitap Ekle'),
        backgroundColor: Colors.deepOrange.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showPicker(context: context),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: galleryFile != null
                        ? DecorationImage(
                      image: FileImage(galleryFile!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: galleryFile == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: Colors.grey[600],
                        size: 60,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Kitap fotoğrafı yükleyin',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kitap Adı',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kitap adını giriniz';
                  }
                  return null;
                },
                onSaved: (value) => _bookName = value!,
              ),
              SizedBox(height: 20),
              _buildDropdownButtonFormField(
                labelText: 'Tür',
                value: _genre,
                items: _genres,
                onChanged: (newValue) {
                  setState(() {
                    _genre = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Yazar',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen yazar adını giriniz';
                  }
                  return null;
                },
                onSaved: (value) => _author = value!,
              ),
              SizedBox(height: 20),
              _buildDropdownButtonFormField(
                labelText: 'Kitabın Durumu',
                value: _bookState,
                items: _bookStates,
                onChanged: (newValue) {
                  setState(() {
                    _bookState = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'İlanın Açıklaması',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ilan açıklamasını giriniz';
                  }
                  return null;
                },
                onSaved: (value) => _advertisementDescription = value!,
                maxLines: 3,
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
                activeColor: Colors.deepOrange,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: Text('YÜKLE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade300,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButtonFormField({
    required String labelText,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }
}
