import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Book.dart';
import '../service/get_book_by_id.dart';
import '../service/get_favorites.dart';
import '../service/upload_image.dart';
import 'home_page.dart';

class UpdateBookPage extends StatefulWidget {
  final Book book;

  UpdateBookPage({required this.book});

  @override
  _UpdateBookPageState createState() => _UpdateBookPageState();
}

class _UpdateBookPageState extends State<UpdateBookPage> {
  final _formKey = GlobalKey<FormState>();
  late String _bookName;
  late String _author;
  late String _advertisementDescription;
  late String _genre;
  late String _bookState;
  File? _galleryFile;
  final _picker = ImagePicker();
  late bool _isSuspended;

  final List<String> _genres = [
    'Tarih', 'Kurgu', 'Korku', 'Biyografi', 'Bilim Kurgu', 'Polisiye',
    'Klasikler', 'Çocuk Kitapları', 'Şiir', 'Felsefe-Dini', 'Kişisel Gelişim',
    'Bilim-Teknoloji', 'Politika-Ekonomi', 'Gezi', 'Sağlık-Psikolji', 'Eğitim',
  ];

  final List<String> _bookStates = [
    'Yeni', 'Eski', 'Yıpranmış',
  ];

  @override
  void initState() {
    super.initState();
    _bookName = widget.book.name;
    _author = widget.book.author;
    _advertisementDescription = widget.book.description;
    _genre = widget.book.genre;
    _bookState = widget.book.stateOfBook;
    _isSuspended = widget.book.isAskida;
  }



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

  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtoken');

    final apiUrl = Uri.parse('https://bookcycle.azurewebsites.net/api/v1/Book/${widget.book.id}');

    String? base64Image;
    if (_galleryFile != null) {
      base64Image = await UploadImageService().uploadImageAsBase64(_galleryFile!);
    }

    try {
      final response = await http.put(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.book.id,
          'name': _bookName,
          'author': _author,
          'genre': _genre,
          'stateOfBook': _bookState,
          'description': _advertisementDescription,
          'isAskida': _isSuspended,
          'bookImage': base64Image ?? widget.book.bookImage,
          'location': widget.book.location,
          'createdBy': widget.book.createdBy,
          'created' : widget.book.created
        }),
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kitap başarıyla güncellendi')),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kitap güncelleme başarısız: ${response.statusCode}, ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kitap güncellenirken hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kitap Güncelle'),
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
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 4,
                    right: MediaQuery.of(context).size.width / 4,
                    bottom: 5,
                    top: 5,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(8),
                      right: Radius.circular(8),
                    ),
                    child: widget.book.bookImage != null && widget.book.bookImage!.isNotEmpty
                        ? Image.memory(
                      base64Decode(base64.normalize(widget.book.bookImage!)),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset("images/book1.jpg", fit: BoxFit.cover);
                      },
                    )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                labelText: 'Kitap Adı',
                initialValue: _bookName,
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
                initialValue: _author,
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
                initialValue: _advertisementDescription,
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
                onPressed: _updateBook,
                child: const Text('GÜNCELLE'),
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
    String? initialValue,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: initialValue,
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
