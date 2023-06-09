import 'package:bookopedia/main.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: myTheme.primaryColorLight,
          title: const Center(
            child: Text(
              "Romance",
              style: TextStyle(
                fontFamily: 'Oswald',
                color: Color.fromARGB(255, 126, 92, 78),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Center(
            child: GridView.extent(
          childAspectRatio: 2 / 3,
          primary: false,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          maxCrossAxisExtent: 300.0,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: const BookCard(
                  imagePath: "assets/images/cover.jpg",
                  title: "Harry",
                  key: Key('1'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: const BookCard(
                  imagePath: "assets/images/cover.jpg",
                  title: "Harry",
                  key: Key('2'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: const BookCard(
                  imagePath: "assets/images/cover.jpg",
                  title: "Harry",
                  key: Key('3'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: const BookCard(
                  imagePath: "assets/images/cover.jpg",
                  title: "Harry",
                  key: Key('4'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 200,
                child: const BookCard(
                  imagePath: "assets/images/cover.jpg",
                  title: "Harry",
                  key: Key('5'),
                ),
              ),
            ),
          ],
        )),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                activeIcon: const Icon(
                  Icons.home,
                  color: Colors.brown,
                ),
                icon: Icon(
                  Icons.home,
                  color: Colors.brown[200],
                ),
                label: 'Home'),
            BottomNavigationBarItem(
              activeIcon: const Icon(
                Icons.category_outlined,
                color: Colors.brown,
              ),
              icon: Icon(
                Icons.category_outlined,
                color: Colors.brown[200],
              ),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              activeIcon: const Icon(
                Icons.book,
                color: Colors.brown,
              ),
              icon: Icon(
                Icons.book,
                color: Colors.brown[200],
              ),
              label: 'Saved',
            ),

            BottomNavigationBarItem(
              activeIcon: const Icon(
                Icons.explore,
                color: Colors.brown,
              ),
              icon: Icon(
                Icons.explore,
                color: Colors.brown[200],
              ),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              activeIcon: const Icon(
                Icons.account_circle,
                color: Colors.brown,
              ),
              icon: Icon(
                Icons.account_circle,
                color: Colors.brown[200],
              ),
              label: 'Profile',
            ),
            // Add more bottom navigation bar items as needed
          ],
          selectedItemColor: Colors.brown,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.normal,
          ),
        ));
  }
}

class BookCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const BookCard({
    required Key key,
    required this.imagePath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 270,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
