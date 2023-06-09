import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bookopedia/screens/pages/HomeScreen.dart';
import 'package:bookopedia/screens/pages/CategoryScreen.dart';
import 'package:bookopedia/screens/pages/SavedScreen.dart';
import 'package:bookopedia/screens/pages/DiscoverScreen.dart';
import 'package:bookopedia/screens/pages/ProfileScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  User? _user;
  String _userName = "";
  String _userEmail = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _signOut() async {
    await _firebaseAuth.signOut();
    Navigator.pushNamed(context, '/login');
  }

  final List<Widget> _pages = [
    HomeScreen(),
    CategoryScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.category_outlined,
    Icons.book,
    Icons.account_circle,
  ];

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Category';
      case 2:
        return 'Saved';
      case 3:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
      await FirebaseFirestore.instance.collection('users').doc(user.email).get();
      if (userData.exists) {
        setState(() {
          _user = user;
          _userName = userData.get('name') ?? "Name";
          _userEmail = userData.get('email') ?? "Email";
        });
      }
    } else {
      print("User is null"); // Add this line
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 112, 85, 75),
        title: const Center(
          child: Text(
            "Bookopedia",
            style: TextStyle(
              fontFamily: 'Oswald',
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Align(
        //       alignment: Alignment.topRight,
        //       child: IconButton(
        //         color: Colors.white,
        //         icon: const Icon(Icons.search),
        //         onPressed: () {},
        //       ),
        //     ),
        //   )
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 112, 85, 75),
              ),
              child: UserAccountsDrawerHeader(
                margin: const EdgeInsets.only(bottom: 0),
                decoration: const BoxDecoration(color: Color.fromARGB(255, 112, 85, 75)),
                accountName: Text(
                  _userName,
                  style: const TextStyle(fontSize: 23),
                ),
                accountEmail: Text(_userEmail, style: const TextStyle(fontSize: 17),),
                currentAccountPictureSize: const Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color(0xffFFF4E6),
                  child: Text(
                    _userName.isNotEmpty ? _userName[0].toUpperCase() : "",
                    style: const TextStyle(fontSize: 30.0, color: Colors.brown),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
                Navigator.pop(context);
                // Navigator.pushNamed(context, '/profile');
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text(' Saved '),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_label),
              title: const Text(' Categories  '),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
                _signOut();
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: List.generate(
          _icons.length,
              (index) => BottomNavigationBarItem(
            icon: Icon(
              _icons[index],
              color: _currentIndex == index ? Colors.brown : Colors.brown[200],
            ),
            label: _getLabelForIndex(index),
          ),
        ),
        showUnselectedLabels: true,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.brown[200],
        selectedLabelStyle: const TextStyle(
          color: Colors.brown,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.brown[200],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
