import 'package:camera_permission/datasource/photo_datasource.dart';

class GetPhotoUseCase {
  final PhotoDataSource _photoDataSource;

  GetPhotoUseCase(this._photoDataSource);

  Future<String?> getPhotoFromCamera() async {
    return await _photoDataSource.pickImageFromCamera();
  }

  Future<String?> getPhotoFromGallery() async {
    return await _photoDataSource.pickImageFromGallery();
  }
}
