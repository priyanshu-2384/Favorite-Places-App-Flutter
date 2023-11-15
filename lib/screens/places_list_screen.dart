//import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/user_places.dart';
import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});

  @override
  ConsumerState<PlacesListScreen> createState() {
    return _PlacesListScreenState();
  }
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesList;

  @override
  void initState() {
    _placesList = ref.read(userPlacesProvider.notifier).loadPlaces();
    super.initState();
  }

  void _addPlace(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => const AddPlaceScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(
        userPlacesProvider); //whenever data in provider changes here also automatically userPlaces updates the UI
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Places"),
          actions: [
            IconButton(
                onPressed: () {
                  _addPlace(context);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          //if our future's snapshot is in waiting we will display loading else we will display our screen
          child: FutureBuilder(
            future: _placesList,
            builder: (context, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : PlacesList(
                        placesList: userPlaces,
                      ),
          ),
        ));
  }
}
