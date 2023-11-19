import 'dart:io';

import 'package:camera_permission/bloc/photo_bloc.dart';
import 'package:camera_permission/datasource/photo_datasource.dart';
import 'package:camera_permission/datasource/upload_datasource.dart';
import 'package:camera_permission/usecase/photo_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoBloc(
        GetPhotoUseCase(
          PhotoDataSource(),
        ),
        UploadImageDataSource(),
      ),
      child: const MaterialApp(
        home: PhotoPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PhotoPageContent();
  }
}

class PhotoPageContent extends StatefulWidget {
  const PhotoPageContent({Key? key}) : super(key: key);

  @override
  PhotoPageContentState createState() => PhotoPageContentState();
}

class PhotoPageContentState extends State<PhotoPageContent> {
  String? selectedImagePath;
  String? selectedImageName;
  String? imageUrl;
  String? successMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Foto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _requestPermissions();
                _showPhotoModal(context);
              },
              child: const Icon(Icons.camera),
            ),
            if (selectedImagePath != null)
              Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.file(
                      File(selectedImagePath!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 8),
                    Text(selectedImageName ?? ''),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _uploadImage(context);
                      },
                      child: const Text('Enviar Imagem'),
                    ),
                    if (imageUrl != null && successMessage != null)
                      Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Image.network(
                              imageUrl!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(successMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _copyImageUrl(context);
                              },
                              child: const Text('Copiar URL'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    if (cameraStatus != PermissionStatus.granted ||
        photosStatus != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Permissões Necessárias'),
            content: const Text(
              'É necessário conceder permissões para acessar a câmera e a galeria de fotos.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showPhotoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Tirar Foto'),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<PhotoBloc>(context)
                    .add(GetPhotoFromCameraEvent());
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Escolher da Galeria'),
              onTap: () {
                Navigator.pop(context);
                BlocProvider.of<PhotoBloc>(context)
                    .add(GetPhotoFromGalleryEvent());
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (selectedImagePath != null) {
      BlocProvider.of<PhotoBloc>(context)
          .add(UploadImageEvent(selectedImagePath!));
    }
  }

  void _copyImageUrl(BuildContext context) {
    Clipboard.setData(ClipboardData(text: imageUrl!));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('URL copiada para a área de transferência'),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = BlocProvider.of<PhotoBloc>(context);

    bloc.stream.listen((state) {
      if (state is PhotoLoadedState) {
        setState(() {
          selectedImagePath = state.imagePath;
          selectedImageName = _getImageName(state.imagePath);
        });
      } else if (state is ImageUploadedState) {
        setState(() {
          imageUrl = state.imageUrl;
          successMessage =
              'Imagem enviada com sucesso. URL da imagem: $imageUrl';
        });
      }
    });
  }

  String _getImageName(String imagePath) {
    return imagePath.split('/').last;
  }
}
