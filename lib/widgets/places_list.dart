import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.placesList});
  final List<Place> placesList;

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
        child: Text(
      "No Places Added yet.",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    ));
    if (placesList.isNotEmpty) {
      content = ListView.builder(
        itemCount: placesList.length,
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
              onTap: () {
                //Navigating to PlacesDetail Screen
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => PlaceDetailScreen(place: placesList[index]),
                ));
              },
              leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(placesList[index]
                      .image)), //displaying circular small image before title
              title: Text(
                placesList[index].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              subtitle: Text(
                placesList[index].location.address,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              )),
        ),
      );
    }
    return content;
  }
}
