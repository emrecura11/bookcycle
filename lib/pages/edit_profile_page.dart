import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bookcycle/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/get_user_by_id.dart';
import '../service/upload_image.dart';
import '../service/update_user.dart';
import '../widgets/basic_button.dart';
import '../models/User.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:typed_data';
import 'package:csc_picker/csc_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? galleryFile;
  final picker = ImagePicker();
  bool _isUploading = false;
  User user = User(id: '', userName: '', email: '', userImage: '');
  String? selectedProvince;
  String? selectedDistrict;
  final String baseUrl = 'https://bookcycle.azurewebsites.net/api/Account';
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    user = await getUserInfo(userId!);
    setState(() {
      _usernameController.text = user.userName;
      _emailController.text = user.email;
      _descriptionController.text = user.description ?? '';
    });
  }
  // Example data for provinces and districts
  List<String> provinces = ['Ankara', 'İstanbul', 'İzmir'];
  Map<String, List<String>> districts = {
    'Ankara': ['Çankaya', 'Keçiören', 'Yenimahalle'],
    'İstanbul': ['Kadıköy', 'Beşiktaş', 'Üsküdar'],
    'İzmir': ['Konak', 'Karşıyaka', 'Bornova'],
  };
  List<String> currentDistricts = [];
  Future<void> _saveProfile() async {
    setState(() {
      _isUploading = true;
    });

    final updateService = UpdateUserService(baseUrl: baseUrl);
    String? uploadedImageBase64 = user.userImage; // Use existing image as default
    String? formattedLocation=user.location;
    if (galleryFile != null) {
      final uploadService = UploadImageService();
      uploadedImageBase64 = await uploadService.uploadImageAsBase64(galleryFile!);
      if (uploadedImageBase64 == null) {
        uploadedImageBase64 = await getDefaultImageBase64();  // Fallback to default image if upload fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fotoğraf yüklenemedi, varsayılan kullanılacak!')),
        );
      }
    } else if (user.userImage == null) {
      uploadedImageBase64 = await getDefaultImageBase64();  // Use default image if no existing image
    } else {
      uploadedImageBase64 = user.userImage;  // Use existing user image
    }
    if (stateValue != null && cityValue != null) {
      formattedLocation = '$cityValue/$stateValue';
    }
    else if (stateValue != null && cityValue == null) {
      formattedLocation = '$stateValue';
    }
    bool success = await updateService.updateUser(
      userId: user.id,
      userName: _usernameController.text,
      location: formattedLocation??'Bilinmiyor',
      description: _descriptionController.text,
      base64Image: uploadedImageBase64!,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profiliniz başarıyla güncellendi')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(userFuture: getUserInfo(user.id))),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profiliniz güncellenemedi!')),
      );
    }

    setState(() {
      _isUploading = false;
    });
  }
  Future<String> getDefaultImageBase64() async {
    final ByteData data = await rootBundle.load('images/default.jpg');
    final Uint8List bytes = data.buffer.asUint8List();
    return base64Encode(bytes);
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
  Future<void> _pickImage(ImageSource img) async {
    // Diğer platformlar için
    final pickedFile = await picker.pickImage(source: img);
    if (pickedFile != null) {



      setState(() {
        galleryFile = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bir fotoğraf seçilmedi')),
      );
    }
  }

  ImageProvider<Object> getProfileImage() {
    if (galleryFile != null) {
      // Yerel dosya olarak seçilen fotoğrafı göster
      return FileImage(galleryFile!);
    } else if (user.userImage != null) {
      // Kullanıcı profil fotoğrafı varsa onu göster
      return user.userImage!.startsWith('http')
          ? NetworkImage(user.userImage!) as ImageProvider<Object>
          : MemoryImage(base64Decode(user.userImage!)) as ImageProvider<Object>;
    } else {
      // Hiçbir kaynak yoksa varsayılan resmi göster
      return const AssetImage('images/default.jpg');
    }
  }
  @override
  Widget build(BuildContext context) {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Düzenleme'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(  // Added SingleChildScrollView for better scrolling when keyboard appears
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showPicker(context: context),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: getProfileImage() as ImageProvider<Object>?,
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
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Kullanıcı adı',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                cursorColor: const Color(0xFF88C4A8),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Hakkımda',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF88C4A8)),
                  ),
                ),
                cursorColor: const Color(0xFF88C4A8),
                maxLines: null,
              ),
              const SizedBox(height: 20),
              ///Adding CSC Picker Widget in app
              CSCPicker(
                layout: Layout.vertical,
                flagState: CountryFlag.ENABLE,
                onCountryChanged: (country){
                  print(country);
                },
                onStateChanged: (state){
                  print(state);
                  stateValue=state;
                },
                onCityChanged: (city){
                  cityValue=city;
                },
                defaultCountry: CscCountry.Turkey, // Set default country to Turkey
                disableCountry: true,
                stateSearchPlaceholder: "İl",
                citySearchPlaceholder: "İlçe",

                stateDropdownLabel: "İl seçin",
                cityDropdownLabel: "İlçe seçin",
                dropdownDialogRadius: 12.0,
                searchBarRadius: 30.0,
                dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.grey.shade800, width: 2)),

                disabledDropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey.shade300,
                    border:
                    Border.all(color: Colors.grey.shade600, width: 2)),
                ///selected item style [OPTIONAL PARAMETER]
                selectedItemStyle: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                ),

                ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                dropdownHeadingStyle: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),

                ///DropdownDialog Item style [OPTIONAL PARAMETER]
                dropdownItemStyle: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              _isUploading
                  ? CircularProgressIndicator()
                  : BasicButton(
                onTap: _saveProfile,
                buttonText: "KAYDET",
              ),
            ],
          ),
        ),
      ),
    );
  }
}