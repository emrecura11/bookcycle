import 'dart:convert'; // Base64 dönüştürme için
import 'dart:io'; // File sınıfı için
import 'package:image/image.dart' as img; // Resim işlemleri için image paketi

class UploadImageService {
  /// Mobil/masaüstü platformları için resmi Base64 formatına çevirir
  Future<String> uploadImageAsBase64(File imageFile) async {
    // Resmi oku ve byte array'e dönüştür
    final bytes = await imageFile.readAsBytes();

    // Resmi küçültme işlemi (örnek olarak 300x300'e)
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception("Resim dosyası bozuk veya desteklenmeyen format.");
    }
    img.Image resizedImage = img.copyResize(originalImage, width: 300, height: 300);

    // Byte array'i Base64 formatına dönüştür
    final String base64Image = base64Encode(img.encodeJpg(resizedImage, quality: 60)); // Kalite ayarı

    return base64Image;
  }
}
