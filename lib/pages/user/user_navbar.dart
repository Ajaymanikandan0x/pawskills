import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/user_profile.dart';
import 'package:pawskills/pages/user/user_home.dart';
import 'package:pawskills/pages/user/user_wishlist.dart';

class UserNavbar extends StatefulWidget {
  const UserNavbar({Key? key}) : super(key: key);

  @override
  State<UserNavbar> createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  int selectTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        elevation: 8, // Add elevation for a shadow effect
        child: SizedBox(
          height: kToolbarHeight + 30, // Increase height for better touch area
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTab(Icons.home, "Home", 0),
              _buildTab(Icons.favorite_border_outlined, "Wishlist", 1),
              _buildTab(Icons.person, "Profile", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selectTab == index ? Colors.blue : Colors.grey,
            size: 25,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selectTab == index ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (selectTab) {
      case 0:
        return const UserHome();
      case 1:
        return const UserWishlist();
      case 2:
        return const UserProfile();
      default:
        return const SizedBox(); // in case off error
    }
  }
}
