import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'BookDetailScreen.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final books = snapshot.data!.docs;
          final categoryMap = <String, String>{};
          for (final book in books) {
            final bookData = book.data();
            final category = bookData['category'] as String?;
            final imageUrl = bookData['imageUrl'] as String?;
            if (category != null && imageUrl != null && !categoryMap.containsKey(category)) {
              categoryMap[category] = imageUrl;
            }
          }
          final categories = categoryMap.keys.toList();
          return GridView.builder(

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final categoryName = categories[index];
              final categoryImageUrl = categoryMap[categoryName];
              return Padding(
                padding: const EdgeInsets.all(14.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryListScreen(categoryName: categoryName),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blue, // Replace with your desired box color
                        ),
                      ),
                      categoryImageUrl != null
                          ? Image.network(
                        categoryImageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                          : const SizedBox(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54.withOpacity(0.7),
                        ),
                        child: Center(
                          child: Text(
                            categoryName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
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



class CategoryListScreen extends StatelessWidget {
  final String categoryName;

  const CategoryListScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontFamily: 'Oswald',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('category', isEqualTo: categoryName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final books = snapshot.data!.docs;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final bookData = books[index].data();
              final bookTitle = bookData['bookName'] as String?;
              final bookAuthor = bookData['author'] as String?;
              final bookRating = bookData['rating'] as String?;
              final bookImageUrl = bookData['imageUrl'] as String?;
              final bookId = books[index].id;
              final bookTags = bookData['tags'] as String?;

              final tagsList = bookTags != null
                  ? bookTags.split(',').where((tag) => tag.trim().isNotEmpty).toList()
                  : [];

              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context) => BookDetailsPage(documentId: bookId,)));
                },
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        if (bookImageUrl != null)
                          Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(bookImageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bookTitle ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Oswald',
                                  color: Color.fromARGB(255, 102, 71, 59),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
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
                                    bookRating != null ? bookRating.toString() : '',
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
                        ),
                      ],
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
