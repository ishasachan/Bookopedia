import 'package:bookopedia/routes.dart';
import 'package:bookopedia/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //Firebase Configuration
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChannels.platform.invokeMethod('SystemChrome.setPreferredOrientations',
      <String>['portraitUp', 'portraitDown']);

  //Main App run
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bookopedia',
      theme: myTheme,
      // initialRoute: '/welcome',
      initialRoute: '/auth',
      routes: routes,
    );
  }
}
