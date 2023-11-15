import 'package:favorite_places/models/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//This Screen will be used to select location on map(which will not need any selected location)
//And Screen will be also used to view the location(which will need previoud location data)
//therefore not using required keyword
//therefore we can use map screen in two scenarios 1) when we have a location 2)We don't have location
class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location =
        const PlaceLocation(latitude: 37.422, longitude: -122.084, address: ''),
    this.isSelecting = true,
  });
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //Different Titles for two different Screens
          title: widget.isSelecting
              ? const Text("Pick Your Location")
              : const Text('Your Location'),
          actions: [
            if (widget.isSelecting)
              IconButton(
                  onPressed: () {
                    //on saving popping the screen and also passing the pickedLocation back to addPlace screen
                    Navigator.of(context).pop(_pickedLocation);
                  },
                  icon: const Icon(Icons.save))
          ]),
      body: GoogleMap(
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLocation = position;
                });
              },
        //Provided by flutter to access google maps
        initialCameraPosition: CameraPosition(
            target: LatLng(widget.location.latitude, widget.location.longitude),
            zoom: 16),
        //don't show marker if picked Location is null, i.e not tapped on screen -> not pickedLocation
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                    markerId: const MarkerId('m1'),
                    //if we pick any location thenmarker should point there if not then it shouldd be set on default only
                    position: _pickedLocation != null
                        ? _pickedLocation!
                        : LatLng(widget.location.latitude,
                            widget.location.longitude)),
              },
      ),
    );
  }
}
