import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _submitSearch() {
    final String query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('books')
          .orderBy('name')
          .startAt([query])
          .endAt([query + '\uf8ff'])
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        setState(() {
          _searchResults = snapshot.docs.map((doc) => doc.data()).toList();
        });
      }).catchError((error) {
        print('Error fetching search results: $error');
        setState(() {
          _searchResults = [];
        });
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submitSearch,
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final bookData = _searchResults[index];
                final name = bookData['name'] as String?;
                final author = bookData['author'] as String?;
                if (name == null || author == null) {
                  return const SizedBox();
                }
                return ListTile(
                  title: Text(name),
                  subtitle: Text(author),
                  // Customize the list tile layout as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
