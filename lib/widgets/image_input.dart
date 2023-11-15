import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; //You need to ad this when working with files

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});
  final void Function(File image)
      onPickImage; //To pass the image file fromhere to add_place screen

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();
    //pickedImage contains image
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth:
            600); //imagePicker. = > pickVideo, pickMultipleImages and many options available, Also ImageSource -> gives access to Gallery also

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _selectedImage = File(
          pickedImage.path); //File constructor used to convert XFile -> File
    });

    widget.onPickImage(
        _selectedImage!); //passing our selected image to the function recieved from add place which will store added image in that screen
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
        onPressed: _takePicture,
        icon: const Icon(Icons.camera),
        label: const Text('Take Picture'));

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap:
            _takePicture, //If the image is tapped then it will take new picture again
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ); //shows image, Converts file of Image -> Image
    }
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2))),
      alignment: Alignment.center,
      child: content,
    );
  }
}
