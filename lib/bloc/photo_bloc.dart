// No arquivo photo_bloc.dart
import 'package:camera_permission/datasource/upload_datasource.dart';
import 'package:camera_permission/usecase/photo_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final GetPhotoUseCase _getPhotoUseCase;
  final UploadImageDataSource _uploadImageDataSource;

  PhotoBloc(this._getPhotoUseCase, this._uploadImageDataSource)
      : super(PhotoInitialState()) {
    on<GetPhotoFromCameraEvent>(_onGetPhotoFromCamera);
    on<GetPhotoFromGalleryEvent>(_onGetPhotoFromGallery);
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onGetPhotoFromCamera(
      GetPhotoFromCameraEvent event, Emitter<PhotoState> emit) async {
    try {
      final imagePath = await _getPhotoUseCase.getPhotoFromCamera();
      emit(PhotoLoadedState(imagePath ?? ''));
    } catch (e) {
      emit(PhotoErrorState('Erro ao obter foto da câmera'));
    }
  }

  Future<void> _onGetPhotoFromGallery(
      GetPhotoFromGalleryEvent event, Emitter<PhotoState> emit) async {
    try {
      final imagePath = await _getPhotoUseCase.getPhotoFromGallery();
      emit(PhotoLoadedState(imagePath ?? ''));
    } catch (e) {
      emit(PhotoErrorState('Erro ao obter foto da galeria'));
    }
  }

  Future<void> _onUploadImage(
      UploadImageEvent event, Emitter<PhotoState> emit) async {
    emit(ImageUploadingState());

    final imagePath = event.imagePath;
    final result = await _uploadImageDataSource.uploadImage(imagePath);

    if (result != null) {
      emit(ImageUploadedState(result));
    } else {
      emit(PhotoErrorState('Erro ao enviar imagem.'));
    }
  }
}
