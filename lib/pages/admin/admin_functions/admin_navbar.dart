import 'package:flutter/material.dart';
import '../admin_profile.dart';
import '../home.dart';
import '../workout_subAdd.dart';

class AdminNavbar extends StatefulWidget {
  const AdminNavbar({Key? key}) : super(key: key);

  @override
  State<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
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
                  icon: Icons.add_box_outlined,
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
        return const Home();
      case 1:
        return const NewWorkout();
      case 2:
        return const AdminProf();

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
