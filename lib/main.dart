import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pawskills/pages/admin/add_new_pet.dart';
import 'package:pawskills/pages/admin/admin_functions/admin_navbar.dart';
import 'package:pawskills/pages/admin/admin_profile.dart';
import 'package:pawskills/pages/admin/category.dart';
import 'package:pawskills/pages/admin/training/admin_workout_list.dart';
import 'package:pawskills/pages/admin/training/workout_subAdd.dart';
import 'package:pawskills/pages/login/Long_page.dart';
import 'package:pawskills/pages/login/Register_page.dart';
import 'package:pawskills/pages/login/Register_pet.dart';
import 'package:pawskills/pages/login/rootpage.dart';
import 'package:pawskills/pages/login/skip.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pawskills/pages/login/splash.dart';
import 'package:pawskills/pages/user/functions/hive/user_hive.dart';
import 'package:pawskills/pages/user/user_navbar.dart';
import 'package:pawskills/pages/user/user_pet_add.dart';
import 'package:pawskills/pages/user/user_profile_edit.dart';
import 'package:pawskills/pages/user/user_wishlist.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'firebase_options.dart';

void main() async {
  // set firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  // Set Hive
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(UserProfileDataAdapter());
  Hive.registerAdapter(UserWorkoutCardDataAdapter());
  Hive.registerAdapter(PetDataAdapter());

  await Hive.openBox<UserWorkoutCardData>('workout_card_data');
  await Hive.openBox<UserProfileData>('user_profile_data');
  await Hive.openBox<PetData>('user_pets');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.grey[200]),
      routes: {
        '/': (context) => const SplashScreen(),
        '/root': (context) => const Root(),
        '/register': (context) => Register(),
        '/RegPet': (context) => const RegPet(),
        '/login': (context) => UserLogin(),
        '/skip': (context) => const Skip(),
        '/home': (context) => const AdminNavbar(),
        '/category': (context) => const Category(),
        '/adminprof': (context) => const AdminProf(),
        '/addnewpet': (context) => const AddNewPet(),
        '/user_pet_add': (context) => const UserPet(),
        '/user_prof_edt': (context) => const UserProfEdit(),
        '/userHome': (context) => const UserNavbar(),
        '/wishlist': (context) => const UserWishlist(),
        // -----------------workout---------------------
        '/admin_workout_list': (context) => const WorkoutList(),
        '/newWorkout': (context) => const NewWorkout(),
      },
    ),
  );
}
