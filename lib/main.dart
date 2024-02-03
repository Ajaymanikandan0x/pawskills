import 'dart:js';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawskills/pages/login/Register_page.dart';
import 'package:pawskills/pages/login/rootpage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {'/': (context) => Root(), '/register': (context) => Register()},
    ),
  );
}
