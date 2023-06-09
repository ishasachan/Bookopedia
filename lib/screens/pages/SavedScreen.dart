import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'BookDetailScreen.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  late Future<List<DocumentSnapshot>> savedBooksFuture;

  @override
  void initState() {
    super.initState();
    savedBooksFuture = getSavedBooks();
  }

  Future<List<DocumentSnapshot>> getSavedBooks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      final savedBooks = snapshot.data()?['SavedBooks'] ?? [];

      final savedBooksQuery = await FirebaseFirestore.instance
          .collection('books')
          .where(FieldPath.documentId, whereIn: savedBooks)
          .get();

      return savedBooksQuery.docs;
    } else {
      return [];
    }
  }

  Future<void> unsaveBook(String documentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.email);

      final snapshot = await userRef.get();
      final savedBooks = snapshot.data()?['SavedBooks'] ?? [];

      savedBooks.remove(documentId);
      await userRef.set({'SavedBooks': savedBooks}, SetOptions(merge: true));

      setState(() {
        savedBooksFuture = getSavedBooks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: savedBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Books Saved'));
          }

          final savedBooks = snapshot.data!;

          if (savedBooks.isEmpty) {
            return const Center(child: Text('No saved books'));
          }

          return ListView.builder(
            itemCount: savedBooks.length,
            itemBuilder: (context, index) {
              final bookData = savedBooks[index].data()! as Map<String, dynamic>;
              final bookTitle = bookData['bookName'] as String?;
              final bookAuthor = bookData['author'] as String?;
              final bookRating = bookData['rating'] as String?;
              final bookImageUrl = bookData['imageUrl'] as String?;
              final bookId = savedBooks[index].id;
              final bookTags = bookData['tags'] as String?;

              final tagsList = bookTags != null
                  ? bookTags.split(',').where((tag) => tag.trim().isNotEmpty).toList()
                  : [];

              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsPage(documentId: bookId),
                        ),
                      );
                    },
                    leading: bookImageUrl != null
                        ? Container(
                      width: 60,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(bookImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container(),
                    title: Text(
                      bookTitle ?? '',
                      style: const TextStyle(
                        fontFamily: 'Oswald',
                        color: Color.fromARGB(255, 102, 71, 59),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookAuthor ?? '',
                          style: const TextStyle(fontSize: 17),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              bookRating ?? '',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          children: tagsList.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tag.trim(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => unsaveBook(bookId),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
