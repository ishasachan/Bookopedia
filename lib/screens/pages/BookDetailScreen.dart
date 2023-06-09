import 'package:bookopedia/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ReadPdf.dart';

class BookDetailsPage extends StatefulWidget {
  final String documentId;

  const BookDetailsPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<DocumentSnapshot> bookFuture;
  bool isBookSaved = false;
  @override

  void initState() {
    super.initState();
    bookFuture = getBookData();
    checkIfBookSaved();
  }

  Future<DocumentSnapshot> getBookData() {
    return FirebaseFirestore.instance
        .collection('books')
        .doc(widget.documentId)
        .get();
  }

  Future<void> checkIfBookSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      final savedBooks = snapshot.data()?['SavedBooks'] ?? [];
      setState(() {
        isBookSaved = savedBooks.contains(widget.documentId);
      });
    }
  }

  Future<void> saveBook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.email);

      final snapshot = await userRef.get();
      final savedBooks = snapshot.data()?['SavedBooks'] ?? [];

      savedBooks.add(widget.documentId);
      await userRef.set({'SavedBooks': savedBooks}, SetOptions(merge: true));

      setState(() {
        isBookSaved = true;
      });
    }
  }

  Future<void> removeBook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.email);

      final snapshot = await userRef.get();
      final savedBooks = snapshot.data()?['SavedBooks'] ?? [];

      savedBooks.remove(widget.documentId);
      await userRef.set({'SavedBooks': savedBooks}, SetOptions(merge: true));

      setState(() {
        isBookSaved = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myTheme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 25,
        ),
        actions: [
          IconButton(
            icon: Icon(isBookSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded),
            onPressed: () {
              if (isBookSaved) {
                removeBook();
              } else {
                saveBook();
              }
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: bookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Book not found'));
          }

          final bookData = snapshot.data!.data() as Map<String, dynamic>;

          // Extract the tags from the bookData and remove empty tags
          final tags = (bookData['tags'] as String)
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 150,
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(bookData['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  bookData['bookName'],
                                  style: const TextStyle(
                                    fontFamily: 'Oswald',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  'By ${bookData['author']}',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 102, 71, 59),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Category: ${bookData['category']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rating: ⭐️${bookData['rating']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: tags.map((tag) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: myTheme.primaryColor, // Adjust the color to your preference
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 25),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                        child: Text(
                          "About this book",
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            color: Color.fromARGB(255, 102, 71, 59),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          bookData['description'],
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadPdf(
                          title: bookData['bookName'],
                          pdf: bookData['pdfUrl'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: myTheme.primaryColor, // Adjust the color to your preference
                    ),
                    child: const Center(
                      child: Text(
                        "Read Book",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}