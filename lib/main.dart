import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawskills/pages/login/Long_page.dart';
import 'package:pawskills/pages/login/Register_page.dart';
import 'package:pawskills/pages/login/Register_pet.dart';
import 'package:pawskills/pages/login/rootpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      },
    ),
  );
}
