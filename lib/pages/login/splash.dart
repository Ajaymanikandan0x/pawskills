import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => getLog(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // stops: [0.5, .10],
              colors: [Colors.green.shade400, Colors.white]),
        ),
        child: Center(
          child: SizedBox(
              width: 120,
              height: 120,
              child: Lottie.asset('assets/json/Animation_splash.json')),
        ),
      ),
    );
  }

  Future<void> getLog(context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final saveData = prefs.getString('User');
    final savePass = prefs.getString('Pass');
    final userRole = prefs.getString('role');
    if (saveData != null && savePass != null) {
      if (userRole == 'admin') {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/userHome');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/root');
    }
  }
}
