part of 'photo_bloc.dart';

// Estados
abstract class PhotoState {}

class PhotoInitialState extends PhotoState {}

class PhotoLoadedState extends PhotoState {
  final String imagePath;

  PhotoLoadedState(this.imagePath);
}

class PhotoErrorState extends PhotoState {
  final String errorMessage;

  PhotoErrorState(this.errorMessage);
}

class ImageUploadingState extends PhotoState {}

class ImageUploadedState extends PhotoState {
  final String imageUrl;

  ImageUploadedState(this.imageUrl);
}
