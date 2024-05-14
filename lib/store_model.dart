import 'package:flutter/material.dart';
import 'package:flutter_application_7/databse_helper.dart';

class Store {
  final String name;
  final String location;
  final String userEmail;
  final double latitude;
  final double longitude;

  Store(this.name, this.location, this.userEmail, this.latitude, this.longitude);
}

class StoreProvider with ChangeNotifier {
  late DatabaseHelper _databaseHelper;

  StoreProvider() {
    _databaseHelper = DatabaseHelper();
  }

  List<Map<String, dynamic>> _allStores = [
    {'name': 'Store 1', 'location': 'Location 1', 'latitude': 12.345, 'longitude': 67.890},
    {'name': 'Store 2', 'location': 'Location 2', 'latitude': 23.456, 'longitude': 78.901},
    {'name': 'Store 3', 'location': 'Location 3', 'latitude': 34.567, 'longitude': 89.012},
  ];

  List<Store> _favoriteStores = [];

  List<Map<String, dynamic>> get allStores => _allStores;
  List<Store> get favoriteStores => _favoriteStores;

  Future<void> addFavoriteStore(Map<String, dynamic> store, String userEmail) async {
    try {
      // Insert the favorite store into the database
      await _databaseHelper.insertFavoriteStore(
        userEmail,
        store['name'],
        store['location'],
        store['latitude'],
        store['longitude'],
      );

      // Update the local favorite stores list with the new Store object
      _favoriteStores.add(Store(
        store['name'],
        store['location'],
        userEmail,
        store['latitude'],
        store['longitude'],
      ));

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      print('Error adding favorite store: $e');
    }
  }

  Future<void> loadFavoriteStores(String userEmail) async {
    try {
      // Fetch favorite stores for the specified user from the database
      List<Map<String, dynamic>> favoriteStores =
          await _databaseHelper.getFavoriteStoresByUserEmail(userEmail);

      // Update the local favorite stores list by mapping them to Store objects
      _favoriteStores = favoriteStores.map((store) {
        return Store(
          store['store_name'],
          store['store_location'],
          userEmail,
          store['latitude'],
          store['longitude'],
        );
      }).toList();

      // Notify listeners of the change
      notifyListeners();
    } catch (e) {
      print('Error loading favorite stores: $e');
    }
  }
}