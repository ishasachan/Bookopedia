import 'package:bookopedia/screens/auth/login_page.dart';
import 'package:bookopedia/screens/auth/register_page.dart';
import 'package:bookopedia/screens/auth/auth_page.dart';
import 'package:bookopedia/screens/home_page.dart';
import 'package:bookopedia/screens/preferences_page.dart';
import 'package:bookopedia/screens/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:bookopedia/screens/pages/ProfileScreen.dart';
import 'package:bookopedia/screens/pages/CategoryScreen.dart';
import 'package:bookopedia/screens/pages/SavedScreen.dart';
import 'package:bookopedia/screens/pages/DiscoverScreen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext context) => HomePage(),
  '/auth': (BuildContext context) => const AuthPage(),
  '/login': (BuildContext context) => const LoginPage(),
  '/register': (BuildContext context) => const RegisterPage(),
  '/welcome': (BuildContext context) => const WelcomePage(),
  '/preferences': (BuildContext context) => const Preferences(),
  '/category': (BuildContext context) =>  CategoryScreen(),
  '/saved': (BuildContext context) =>  SavedScreen(),
  '/discover': (BuildContext context) =>  DiscoverScreen(),
  '/profile': (BuildContext context) => ProfileScreen(),
};
