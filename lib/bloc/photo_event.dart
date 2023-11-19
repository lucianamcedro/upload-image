part of 'photo_bloc.dart';

// Eventos
abstract class PhotoEvent {}

class GetPhotoFromCameraEvent extends PhotoEvent {}

class GetPhotoFromGalleryEvent extends PhotoEvent {}

class UploadImageEvent extends PhotoEvent {
  final String imagePath;

  UploadImageEvent(this.imagePath);
}
