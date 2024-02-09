import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawskills/pages/login/Long_page.dart';
import 'package:pawskills/pages/login/Register_page.dart';
import 'package:pawskills/pages/login/Register_pet.dart';
import 'package:pawskills/pages/login/rootpage.dart';
import 'package:pawskills/pages/main/home.dart';
import 'package:pawskills/pages/main/skip.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.grey[200]),
      routes: {
        '/': (context) => Root(),
        '/register': (context) => Register(),
        '/RegPet': (context) => RegPet(),
        '/longin': (context) => UserLogin(),
        '/skip': (context) => Skip(),
        '/home': (context) => Home(),
      },
    ),
  );
}
