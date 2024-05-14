import 'package:flutter/material.dart';
import 'package:flutter_application_7/store_model.dart';
import 'package:provider/provider.dart';

class AddFavoriteStoreScreen extends StatelessWidget {
  final String userEmail;

  AddFavoriteStoreScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Favorite Store'),
      ),
      body: ListView.builder(
        itemCount: storeProvider.allStores.length,
        itemBuilder: (context, index) {
          final store = storeProvider.allStores[index];
          return ListTile(
            title: Text(store['name']),
            subtitle: Text(store['location']),
            trailing: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                storeProvider.addFavoriteStore(store, userEmail);
              },
            ),
          );
        },
      ),
    );
  }
}