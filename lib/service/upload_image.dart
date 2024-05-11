import 'dart:convert'; // Base64 dönüştürme için
import 'dart:typed_data'; // Uint8List sınıfı için
import 'dart:io'; // File sınıfı için
import 'package:http/http.dart' as http; // HTTP istekleri için
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img; // Resim işlemleri için image paketi
import '../models/User.dart';
import 'get_user_by_id.dart';
class UploadImageService {
  final String baseUrl;

  UploadImageService({required this.baseUrl});

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
    User user = User(id: '', userName: '', email: '',userImage: '',);
    user = await getUserInfo(userId!);
    user.userImage = base64Image; // Sadece userImage güncellenir

    // JSON verisini hazırlayın
    final String jsonBody = jsonEncode({
      'id': user.id,
      'email': user.email,
      'userName': user.userName,
      'location': user.location,
      'userImage': user.userImage, // Güncel resmi gönderin
      'description': user.description,
    });

    // JSON formatında bir HTTP POST isteği yap
    final response = await http.put(
      Uri.parse('$baseUrl/update-user/$userId'),
      headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'},
      body: jsonBody,
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
    if (imageFile != null) {
      return await uploadImageAsBase64File(userId, imageFile);
    } else {
      return false; // Eğer hem `File` hem de `Base64` verisi yoksa yükleme yapılamaz
    }
  }
}
