import 'package:flutter/material.dart';
import 'package:pawskills/pages/user/user_home.dart';
import 'package:pawskills/pages/user/user_profile.dart';
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
        child: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TabButton(
                  icon: Icons.home,
                  onTap: () {
                    setState(() {
                      selectTab = 0;
                    });
                  },
                  isSelected: selectTab == 0,
                ),
                TabButton(
                  icon: Icons.favorite_border_outlined,
                  onTap: () {
                    setState(() {
                      selectTab = 1;
                    });
                  },
                  isSelected: selectTab == 1,
                ),
                TabButton(
                  icon: Icons.person,
                  onTap: () {
                    setState(() {
                      selectTab = 2;
                    });
                  },
                  isSelected: selectTab == 2,
                ),
              ],
            ),
          ),
        ),
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
        return const UserProf();
      default:
        return const SizedBox(); // Handle any other case
    }
  }
}

class TabButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const TabButton({
    required this.icon,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 25,
          ),
          SizedBox(
            height: isSelected ? 8 : 2,
          ),
          if (isSelected)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
              ),
              height: 4,
              width: 4,
            )
        ],
      ),
    );
  }
}
