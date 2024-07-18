import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro/data/models/tadbiro.dart';

class CustomSearchDelegate extends SearchDelegate {
  final Function(Tadbiro) onSearchResultSelected;

  CustomSearchDelegate({required this.onSearchResultSelected});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Tadbiro>>(
      future: searchEvents(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final event = results[index];
            return ListTile(
              title: Text(event.name),
              subtitle: Text(event.description),
              onTap: () {
                onSearchResultSelected(event);
                close(context, null);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Search for events'),
    );
  }

  Future<List<Tadbiro>> searchEvents(String query) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('events')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();

    return snapshot.docs.map((doc) => Tadbiro.fromFirestore(doc)).toList();
  }
}
