import 'package:image_picker/image_picker.dart';

class PhotoDataSource {
  final _picker = ImagePicker();

  Future<String?> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        return pickedFile.path;
      } else {
        return null; // Usuário cancelou a seleção
      }
    } catch (e) {
      print('Erro ao obter foto da câmera: $e');
      return null;
    }
  }

  Future<String?> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return pickedFile.path;
      } else {
        return null; // Usuário cancelou a seleção
      }
    } catch (e) {
      print('Erro ao obter foto da galeria: $e');
      return null;
    }
  }
}
