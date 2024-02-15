import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawskills/pages/admin/add_new_pet.dart';
import 'package:pawskills/pages/admin/admin_functions/admin_navbar.dart';
import 'package:pawskills/pages/admin/admin_profile.dart';
import 'package:pawskills/pages/admin/category.dart';
import 'package:pawskills/pages/login/Long_page.dart';
import 'package:pawskills/pages/login/Register_page.dart';
import 'package:pawskills/pages/login/Register_pet.dart';
import 'package:pawskills/pages/login/rootpage.dart';
import 'package:pawskills/pages/admin/home.dart';
import 'package:pawskills/pages/login/skip.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawskills/pages/user/user_home.dart';
import 'package:pawskills/pages/user/user_pet_details.dart';
import 'package:pawskills/pages/user/user_profile.dart';

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
          scaffoldBackgroundColor: const Color(0xFFE5E5E5)),
      routes: {
        '/': (context) => const Root(),
        '/register': (context) => Register(),
        '/RegPet': (context) => const RegPet(),
        '/longin': (context) => UserLogin(),
        '/skip': (context) => const Skip(),
        '/home': (context) => const Home(),
        '/category': (context) => const Category(),
        '/adminprof': (context) => const AdminProf(),
        '/addnewpet': (context) => const AddNewPet(),
        '/user_pet_add': (context) => UserPet(),
        '/userprof': (context) => UserProf(),
        '/userHome': (context) => const UserHome()
      },
    ),
  );
}
