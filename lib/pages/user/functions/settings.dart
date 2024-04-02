import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSettings {
  static Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('Pass');
      await prefs.remove('User');
      await prefs.remove('role');

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print('Error signing out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign out. Please try again.'),
        ),
      );
    }
  }

  static Future<void> kickOut(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Exit',
            style: GoogleFonts.spaceGrotesk(
              textStyle: const TextStyle(color: Colors.red),
            ),
          ),
          content: const Text('Do you want to exit'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () => _signOut(context), child: const Text('Yes'))
          ],
        ),
      );

  static void openPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
    );
  }

  static void openContact(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactPage()),
    );
  }

  static void openSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupportPage()),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SfPdfViewer.asset(
          'assets/imp/privacy.pdf',
          enableTextSelection: false,
        ),
      ),
    );
  }
}
// _____________________________________contsct_________________________________

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email & Phone Section
            const Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Email: contact@pawskills.com',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(MdiIcons.linkedin, color: Colors.blue),
                const SizedBox(width: 10),
                const Text(
                  'linkedin: ajaymanikandan ',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Office Address Section
            const Text(
              'Office Address:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '123 Main Street',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'cochin, kerala,',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// _______________________________________________support_______________________

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Support',
          style: TextStyle(color: Colors.black), // Set text color
        ),
        backgroundColor: Colors.blueGrey[100], // Set background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              'If you have any questions, feedback, or encounter any issues with our app, please feel free to reach out to us.',
              style: TextStyle(
                  fontSize: 18, color: Colors.black87), // Set text color
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue),
                // Add icon for email
                const SizedBox(width: 10),
                InkWell(
                  onTap: () => launchUrl(
                      Uri.parse("https://gmail.com konamipes1921@gmail.com")),
                  child: const Text(
                    'konamipes1921@gmail.com',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(MdiIcons.github, color: Colors.blue),
                const SizedBox(width: 10),
                InkWell(
                    onTap: () => launchUrl(Uri.parse(
                        "https://github.com/Ajaymanikandan0x/pawskills")),
                    child: const Text(
                      'Git Hub ...',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
