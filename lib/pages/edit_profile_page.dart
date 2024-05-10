import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:html' as html; // Web platformu için gerekli
import 'dart:typed_data';
import 'package:bookcycle/pages/profile_page.dart';
import 'package:flutter/foundation.dart'; // kIsWeb kontrolü için
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/get_user_by_id.dart';
import '../service/upload_image.dart';
import '../widgets/basic_button.dart';
import '../models/User.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? galleryFile; // Mobil veya masaüstü platformlar için kullanılacak
  String? base64Image; // Web platformu için Base64 formatında saklanır
  Uint8List? webImageBytes;
  final picker = ImagePicker();
  bool _isUploading = false;
  User user = User(id: '', userName: '', email: '');

  final String baseUrl = 'https://localhost:9001/api/Account';

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    // Kullanıcı bilgilerini SharedPreferences'tan alın
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? userName = prefs.getString('userName');
    String? email = prefs.getString('email');
    user = await getUserInfo(userId!);
    // User nesnesini güncelle
    setState(() {

      _usernameController.text = user.userName;
      _emailController.text = user.email;
    });
  }

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
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  ImageProvider<Object> getProfileImage() {
    if (galleryFile != null) {
      // Yerel dosya olarak seçilen fotoğrafı göster
      return FileImage(galleryFile!);
    } else if (kIsWeb && webImageBytes != null) {
      // Web platformunda seçilen Base64 verisini göster
      return MemoryImage(webImageBytes!);
    } else if (user.userImage != null) {
      // Kullanıcı profil fotoğrafı varsa onu göster
      return user.userImage!.startsWith('http')
          ? NetworkImage(user.userImage!) as ImageProvider<Object>
          : MemoryImage(base64Decode(user.userImage!)) as ImageProvider<Object>;
    } else {
      // Hiçbir kaynak yoksa varsayılan resmi göster
      return const AssetImage('images/logo_bookcycle.jpeg');
    }
  }
  Future<File?> _cropImage(File imageFile) async {
    // Görüntüyü kırp
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }
  Future<File?> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));

    // Yeni dosya için bir ad belirleyin
    final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';

    // Dosyayı sıkıştırarak yeni bir dosya oluştur
    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 60, // Kaliteyi ayarla (0-100)
      minWidth: 300, // Genişlik
      minHeight: 300, // Yükseklik
    );

    return result; // Yeni sıkıştırılmış dosya
  }
  Future<void> _pickImage(ImageSource img) async {
    if (kIsWeb) {
      // Web platformu için Base64'e çevir
      final html.InputElement input = html.InputElement(type: 'file');
      input.accept = 'image/*';
      input.click();

      input.onChange.listen((event) {
        final files = input.files;
        if (files != null && files.isNotEmpty) {
          final html.File file = files.first;

          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);

          reader.onLoadEnd.listen((event) {
            webImageBytes = Uint8List.fromList(reader.result as List<int>);
            setState(() {
              base64Image = base64Encode(webImageBytes!);
              galleryFile = null;// Web platformunda `File` kullanılmaz
            });
          });
        }
      });
    } else {
      // Diğer platformlar için
      final pickedFile = await picker.pickImage(source: img);
      if (pickedFile != null) {
        // Kırpma işlemi
        final croppedFile = await _cropImage(File(pickedFile.path));

        // Sıkıştırma işlemi
        final compressedFile = croppedFile != null
            ? await compressImage(croppedFile)
            : await compressImage(File(pickedFile.path));

        setState(() {
          galleryFile = compressedFile ?? File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (galleryFile == null  && webImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image to upload')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final uploadService = UploadImageService(baseUrl: baseUrl);

    if (kIsWeb&& webImageBytes != null) {
      // Web platformunda Base64 verisini gönder
      bool success = await uploadService.uploadImageAsBase64String(user.id, webImageBytes!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userFuture: getUserInfo(user.id!))), // Burada doğru userFuture'ı sağlayın
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    } else if (galleryFile != null)  {
      // Diğer platformlarda `File` kullanarak gönder
      bool success = await uploadService.uploadImageAsBase64File(user.id, galleryFile!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(userFuture: getUserInfo(user.id!))), // Burada doğru userFuture'ı sağlayın
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    }

    setState(() {
      _isUploading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _showPicker(context: context),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: getProfileImage()
                as ImageProvider<Object>?,
                child: const Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                cursorColor: const Color(0xFF88C4A8),
                maxLines: null,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF88C4A8)),
                  ),
                ),
                cursorColor: const Color(0xFF88C4A8),
                keyboardType: TextInputType.emailAddress,
                maxLines: null,
              ),
            ),
            const SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator()
                : BasicButton(
              onTap: _saveProfile,
              buttonText: "SAVE",
            ),
          ],
        ),
      ),
    );
  }
}
