import 'package:bookopedia/screens/pages/BookDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<QuerySnapshot> bookStream;

  @override
  void initState() {
    super.initState();
    bookStream = getBookData();
  }

  Stream<QuerySnapshot> getBookData() {
    return FirebaseFirestore.instance.collection('books').snapshots();
  }

  Future<List<QueryDocumentSnapshot>> getRelatedBooks(String category) {
    return FirebaseFirestore.instance
        .collection('books')
        .where('category', isEqualTo: category)
        .limit(4) // Limit the number of related books to display
        .get()
        .then((querySnapshot) => querySnapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot>(
              stream: bookStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final books = snapshot.data!.docs;

                  return Container(
                    height: 400,
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 200,
                            child: BookCard(
                              imagePath: book['imageUrl'],
                              title: book['bookName'],
                              author: book['author'],
                              rating: book['rating'],
                              bookId: book.id,
                              key: Key(book.id),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: getBookData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final books = snapshot.data!.docs;

                  // Get distinct categories
                  final categories = books
                      .map((book) => book['category'])
                      .toSet()
                      .toList();

                  return Column(
                    children: categories.map((category) {
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            category,
                            style: const TextStyle(
                              fontFamily: 'Oswald',
                              color: Color.fromARGB(255, 102, 71, 59),
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Container(
                            height: 400,
                            padding: const EdgeInsets.all(10),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                final book = books[index];

                                if (book['category'] == category) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 200,
                                      child: BookCard(
                                        imagePath: book['imageUrl'],
                                        title: book['bookName'],
                                        author: book['author'],
                                        rating: book['rating'],
                                        bookId: book.id,
                                        key: Key(book.id),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String author;
  final String rating;
  final String bookId;

  const BookCard({
    required Key key,
    required this.imagePath,
    required this.title,
    required this.author,
    required this.rating,
    required this.bookId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context) => BookDetailsPage(documentId: bookId,)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Set the border radius here
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(0), // Set the border radius here
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 240,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                title,
                style: const TextStyle(

                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                author,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: "Playfair",
                ),
              ),
              const SizedBox(height: 5,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow,),
                    const SizedBox(width: 5,),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Poppins'
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
