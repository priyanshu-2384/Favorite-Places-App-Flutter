import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart'; //to access location libraries
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});
  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    //using map static API(link is used from there website to create image of location)
    if (_pickedLocation == null) {
      return '';
    }
    double lat = _pickedLocation!.latitude;
    double lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyBfyXMjLnT5fGsDuWA0gZ756-E5q09Swrs';
  }

  //getCurrentLocation function code needs to be copied from flutter loacation readMe, to get current location of the user
  void _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    //getting permission for users location on its device
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData =
        await location.getLocation(); //information of  current location

    final latitude = locationData.latitude;
    final longitude = locationData.longitude;
    if (latitude == null || longitude == null) {
      return;
    }

    _savePlace(latitude, longitude);
  }

  void _savePlace(double latitude, double longitude) async {
    //sending http request to google's  geocoding api  to convert locationData longitude and latitude to Human readable address
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyBfyXMjLnT5fGsDuWA0gZ756-E5q09Swrs");
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0][
        'formatted_address']; //getting the text address from the response recieved from geoencode
    setState(() {
      _pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      _isGettingLocation = false;
      //_pickedLocation = locationData;
    });
    widget.onSelectLocation(
        _pickedLocation!); //Passing our location data to the addplace screen so that from there it can pass it to our provider
  }

  void _getLocationFromMap() async {
    final selectedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (ctx) {
        return const MapScreen();
      },
    ));

    if (selectedLocation == null) {
      return;
    }
    _savePlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No Location Chosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (_pickedLocation != null) {
      content = Image.network(
        //getting our image link from network using our link genereated by Google maps static API
        locationImage,
        fit: BoxFit.cover, width: double.infinity, height: double.infinity,
      );
    }
    if (_isGettingLocation) {
      content = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 1,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.2))),
          alignment: Alignment.center,
          child: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Get Current Location"),
            ),
            TextButton.icon(
              onPressed: _getLocationFromMap,
              icon: const Icon(Icons.map),
              label: const Text("Select on Map"),
            ),
          ],
        )
      ],
    );
  }
}
