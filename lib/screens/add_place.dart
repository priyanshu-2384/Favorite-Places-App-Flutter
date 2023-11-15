//import 'dart:js_interop';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_Input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _savePlace() {
    final _enteredTitle = _titleController.text;
    if (_enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      showDialog(
          //showing invalid input dialog box
          context: context,
          builder: (ctx) => AlertDialog(
                //Error message dialog box
                title: const Text("Invalid Input"),
                content: const Text(
                    "Make sure that you Enter Title, Pick a Image and add location"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Okay"))
                ],
              ));
      return;
    }
    ref.read(userPlacesProvider.notifier).addPlace(
        _enteredTitle,
        _selectedImage!,
        _selectedLocation!); //stored location, Image and title using riverpod in our userPlacesProvider
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Place')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              controller: _titleController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInput(onPickImage: (image) {
              _selectedImage =
                  image; //getting our image file here from Image_input
            }),
            const SizedBox(
              height: 12,
            ),
            LocationInput(onSelectLocation: (loc) {
              _selectedLocation =
                  loc; //getting our location data here from location_input
            }),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
                onPressed: _savePlace,
                icon: const Icon(Icons.add),
                label: const Text('Add Place')),
          ],
        ),
      ),
    );
  }
}
