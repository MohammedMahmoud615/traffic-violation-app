import 'package:flutter/material.dart';
import 'package:untitled5/1.dart';
import 'package:untitled5/all/Records.dart';
import 'package:untitled5/all/color.dart';
import 'package:untitled5/all/recocded_viodations.dart';

class MainNavigationScreen extends StatefulWidget {
  final String idu;
  final String nameu;

  const MainNavigationScreen({Key? key, required this.idu, required this.nameu})
    : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          children: [
            TrafficViolationForm(idu: widget.idu, nameu: widget.nameu),
            Records(idu: widget.idu, nameu: widget.nameu),
            ViolationsScreen(idu: widget.idu, nameu: widget.nameu),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Acolor.AppBar,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'MyCustomFont',
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'MyCustomFont',
          fontWeight: FontWeight.w700,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_rounded),
            label: "تسجيل مخالفة",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.outbox), label: "السجلات"),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: "السجلات",
          ),
        ],
      ),
    );
  }
}
