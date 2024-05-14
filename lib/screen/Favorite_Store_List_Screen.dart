import 'package:flutter/material.dart';
import 'package:flutter_application_7/store_model.dart';
import 'package:provider/provider.dart';

import 'DistanceScreen.dart';


class FavoriteStoreListScreen extends StatelessWidget {
  final String userEmail;

  FavoriteStoreListScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    // Filter the favorite stores based on the userEmail
    final favoriteStores = storeProvider.favoriteStores
        .where((store) => store.userEmail == userEmail)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Stores'),
      ),
      body: ListView.builder(
        itemCount: favoriteStores.length,
        itemBuilder: (context, index) {
          final store = favoriteStores[index];
          return ListTile(
            title: Text(store.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: ${store.location}'),
                Text('Latitude: ${store.latitude}'),
                Text('Longitude: ${store.longitude}'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DistanceScreen(store: store),
                  ),
                );
              },
              child: Text('Calculate Distance'),
            ),
          );
        },
      ),
    );
  }
}