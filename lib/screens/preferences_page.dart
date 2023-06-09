import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  Set<String> selectedGenres = {};

  void _onButtonPressed(String genreName) {
    setState(() {
      if (selectedGenres.contains(genreName)) {
        selectedGenres.remove(genreName);
      } else {
        selectedGenres.add(genreName);
      }
    });
  }

  Future<void> saveSelectedGenres() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final selectedGenresList = selectedGenres.toList();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email) // Use the user's email as the document ID
            .set({'selectedGenres': selectedGenresList}, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error saving selected genres: $e');
    }
  }



  Widget _buildGenreButton(String genreName) {
    final isSelected = selectedGenres.contains(genreName);
    return InkWell(
      onTap: () => _onButtonPressed(genreName),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF795548),
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(30.0),
          color: isSelected ? Colors.brown : Colors.transparent,
        ),
        child: Text(
          genreName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.brown,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preferences",
          style: TextStyle(
            fontFamily: 'Oswald',
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Choose the Book Genre you like",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Select your preferred book genre for better recommendation ",
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 20.0,
                        runSpacing: 18.0,
                        children: [
                          _buildGenreButton('Romantic'),
                          _buildGenreButton('Mystery'),
                          _buildGenreButton('Sci-fi'),
                          _buildGenreButton('Horror'),
                          _buildGenreButton('Comedy'),
                          _buildGenreButton('Fantasy'),
                          _buildGenreButton('Action'),
                          _buildGenreButton('Travel'),
                          _buildGenreButton('Love'),
                          _buildGenreButton('Inspiration'),
                          _buildGenreButton('Comic'),
                          _buildGenreButton('Thriller'),
                          _buildGenreButton('Adventure'),
                          _buildGenreButton('Poetry'),
                          _buildGenreButton('Crime Fiction'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () {
                saveSelectedGenres();
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: myTheme.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "Get Started",
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
        ),
      ),
    );
  }
}
