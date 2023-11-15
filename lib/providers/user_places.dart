import 'dart:io'; //You need to ad this when working with files
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/models/place.dart';
import 'package:path_provider/path_provider.dart'
    as syspaths; //Provides path tha an operating system provides us to store data locally on device
import 'package:path/path.dart' as path; //Helps us to create paths
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
//packages used for storing data in sql database of user's device

Future<Database> _getDataBase() async {
  //to open or create a dataaBase
  final dbPath = await sql
      .getDatabasesPath(); //dbPath will point to a directory in which we can create our database
  final dataBase = await sql.openDatabase(
    //opening a database, or creating
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)'); //when first time the database will be created then it will execute this function and run the query of creating a table
    },
    version: 1,
  ); //if the database exist will open that else it would create that database
  return dataBase;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final dataBase = await _getDataBase();
    final data = await dataBase.query(
        'user_places'); //will give us that table (list of maps , each row will have an map giving the place information)
    final places = data
        .map((row) => Place(
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String)))
        .toList(); // converting list of maps to list of places(which we required with help of PLace class)

    state = places.reversed
        .toList(); //setting our data in provider to the data we have recieved from database
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDirectory = await syspaths
        .getApplicationDocumentsDirectory(); //Getting the app's Directory on local device of our app
    final filename =
        path.basename(image.path); //filename extracted from image's path
    final copiedImage = await image.copy(
        '${appDirectory.path}/$filename'); //copying the image to the path -> 'appDirectory/filename'
    //copiedImage is the image which is stored at tcorrect path in the user's device, therefore we wil usecopiedImage to store in our provider
    final newPlace =
        Place(title: title, image: copiedImage, location: location);
    final dataBase = await _getDataBase(); //getting the database

    dataBase.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    }); //enter table name and values(will take a map)
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
