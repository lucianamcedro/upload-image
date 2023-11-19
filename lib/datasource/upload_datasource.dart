import 'package:dio/dio.dart';

class UploadImageDataSource {
  static const apiKey = '51b2379bf3ec0d981a82d97c6b1164c5';
  static const apiUrl = 'https://api.imgbb.com/1/upload';

  Future<String?> uploadImage(String imagePath) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        apiUrl,
        data: FormData.fromMap({
          'key': apiKey,
          'image': await MultipartFile.fromFile(imagePath),
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final imageUrl = responseData['data']['url'];
        print('Imagem enviada com sucesso. URL da imagem: $imageUrl');
        return imageUrl;
      } else {
        print(
            'Erro ao enviar imagem. Código de resposta: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro durante a solicitação Dio: $e');
      return null;
    }
  }
}
