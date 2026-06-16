import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_graduated/About.dart';
import 'package:project_graduated/hair_screen.dart';
import 'package:project_graduated/home_screen.dart';
import 'package:project_graduated/profile_screen.dart';
import 'package:project_graduated/rules_screen.dart';
import 'dart:async';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool _isExitWarning = false;
  Timer? _exitTimer;

  final _iconList = <IconData>[
    Iconsax.home,
    Iconsax.profile_circle,
    Icons.rule,
    Icons.info_outline_rounded,
  ];
  final _labelList = ['Home', 'About', 'Rules', 'Profile'];
  final List<Widget> _screens = [
    const Homescreen(),
    AboutPage(),
    Rulesscreen(),
    const Profile()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      if (_isExitWarning) {
        return true;
      } else {
        setState(() {
          _isExitWarning = true;
        });
        _exitTimer?.cancel();
        _exitTimer = Timer(Duration(seconds: 2), () {
          setState(() {
            _isExitWarning = false;
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Press back again to exit the app'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width * 0.075;
    double indicatorSize = MediaQuery.of(context).size.width * 0.04;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: _iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color =
                isActive ? Colors.teal : Colors.grey; // Updated to teal
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.teal
                          : Colors.white, // Updated to teal
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Icon(_iconList[index], color: color, size: 20),
                  Text(
                    _labelList[index],
                    style: TextStyle(color: color, fontSize: 14),
                  ),
                ],
              ),
            );
          },
          height: 70 + MediaQuery.of(context).size.height * 0.02,
          backgroundColor: Colors.white,
          activeIndex: _selectedIndex,
          splashColor: Colors.teal, // Updated to teal
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.none,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
