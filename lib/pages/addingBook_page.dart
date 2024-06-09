import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _genre = 'Tarih';
  String _bookState = 'Yeni';
  File? _galleryFile;
  final _picker = ImagePicker();
  bool _isSuspended = false;

  final List<String> _genres = [
    'Tarih', 'Kurgu', 'Korku', 'Biyografi', 'Bilim Kurgu', 'Polisiye',
    'Klasikler', 'Çocuk Kitapları', 'Şiir', 'Felsefe-Dini', 'Kişisel Gelişim',
    'Bilim-Teknoloji', 'Politika-Ekonomi', 'Gezi', 'Sağlık-Psikolji', 'Eğitim',
  ];

  final List<String> _bookStates = [
    'Yeni', 'Eski', 'Yıpranmış',
  ];

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Fotoğraf Galerisi'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _galleryFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  Future<void> _addBook() async {
    if (!_formKey.currentState!.validate() || _galleryFile == null) {
      if (_galleryFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen kitap fotoğrafını yükleyin')),
        );
      }
      return;
    }
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtoken');

    final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book');

    String? base64Image;
    if (_galleryFile != null) {
      base64Image = await UploadImageService().uploadImageAsBase64(_galleryFile!);
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kitap başarıyla eklendi')),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kitap ekleme başarısız: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kitap eklenirken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }),
                )),
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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showPicker(context),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: _galleryFile != null
                        ? DecorationImage(
                      image: FileImage(_galleryFile!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _galleryFile == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: Colors.grey[600],
                        size: 60,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kitap fotoğrafı yükleyin',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                labelText: 'Kitap Adı',
                onSaved: (value) => _bookName = value!,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              _buildTextField(
                labelText: 'Yazar',
                onSaved: (value) => _author = value!,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              _buildTextField(
                labelText: 'İlanın Açıklaması',
                onSaved: (value) => _advertisementDescription = value!,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('Askıda Kitap Olsun'),
                value: _isSuspended,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isSuspended = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.deepOrange,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text('YÜKLE'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade300,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: const TextStyle(
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

  Widget _buildTextField({
    required String labelText,
    required FormFieldSetter<String> onSaved,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen $labelText giriniz';
        }
        return null;
      },
      onSaved: onSaved,
      maxLines: maxLines,
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
        labelStyle: const TextStyle(color: Colors.black),
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
      style: const TextStyle(color: Colors.black),
      dropdownColor: Colors.white,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }
}
