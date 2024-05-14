import 'package:flutter/material.dart';
import 'package:flutter_application_7/store_model.dart';
import 'package:provider/provider.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('All Stores'),
      ),
      body: ListView.builder(
        itemCount: storeProvider.allStores.length,
        itemBuilder: (context, index) {
          final store = storeProvider.allStores[index];
          return ListTile(
             title: Text(store['name']),
            subtitle: Text(store['location']),
          );
        },
      ),
    );
  }
}