import 'dart:convert'; // Base64 dönüştürme için
import 'dart:typed_data'; // Uint8List sınıfı için
import 'dart:io'; // File sınıfı için
import 'package:http/http.dart' as http; // HTTP istekleri için
import 'package:flutter/foundation.dart'; // kIsWeb kontrolü için
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img; // Resim işlemleri için image paketi

class UploadImageService {
  final String baseUrl;

  UploadImageService({required this.baseUrl});

  /// Web platformu için Base64 string olarak resmi gönderir
  Future<bool> uploadImageAsBase64String(String userId, Uint8List webImageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');

    // Web platformu için resim boyutlandırma
    img.Image originalImage = img.decodeImage(webImageBytes)!;
    img.Image resizedImage = img.copyResize(originalImage, width: 200, height: 200);

    // Byte array'i Base64 formatına dönüştür
    final String base64Image = base64Encode(img.encodeJpg(resizedImage, quality: 60));

    // Gönderilecek JSON verisi
    final Map<String, String> body = {
      'Id': userId,
      'UserImage': base64Image,
    };

    // JSON formatında bir HTTP PUT isteği yap
    final response = await http.put(
      Uri.parse('$baseUrl/update-image/$userId'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    // Başarılı olup olmadığını kontrol et
    return response.statusCode == 204;
  }

  /// Mobil/masaüstü platformları için resmi Base64 formatına çevirip gönderir
  Future<bool> uploadImageAsBase64File(String userId, File imageFile) async {
    // Resmi oku ve byte array'e dönüştür
    final bytes = await imageFile.readAsBytes();

    // Resmi küçültme işlemi (örnek olarak 300x300'e)
    img.Image? originalImage = img.decodeImage(Uint8List.fromList(bytes));
    img.Image resizedImage = img.copyResize(originalImage!, width: 200, height: 200);

    // Byte array'i Base64 formatına dönüştür
    final String base64Image = base64Encode(img.encodeJpg(resizedImage, quality: 60)); // Kalite ayarı

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtoken');
    // Gönderilecek JSON verisi
    final Map<String, String> body = {
      'Id': userId,
      'UserImage': base64Image,
    };

    // JSON formatında bir HTTP POST isteği yap
    final response = await http.put(
      Uri.parse('$baseUrl/update-image/$userId'),
      headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    // Başarılı olup olmadığını kontrol et
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  /// Platforma göre doğru yükleme işlevini seçer
  Future<bool> uploadImage(String userId, {File? imageFile, Uint8List? base64Image}) async {
    if (kIsWeb && base64Image != null) {
      return await uploadImageAsBase64String(userId, base64Image);
    } else if (imageFile != null) {
      return await uploadImageAsBase64File(userId, imageFile);
    } else {
      return false; // Eğer hem `File` hem de `Base64` verisi yoksa yükleme yapılamaz
    }
  }
}
