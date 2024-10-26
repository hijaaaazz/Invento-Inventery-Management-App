import 'package:flutter/material.dart';
import 'package:invento2/screens/screen_add/screen_add.dart';
import 'package:invento2/screens/screen_dashboard/screen_dashboard.dart';
import '../screen_inventory/screen_inventory.dart';
import '../screen_profile/screen_profile.dart';

class ScreenMain extends StatefulWidget {
  const ScreenMain({super.key, required userdetails});

  @override
  _ScreenMainState createState() => _ScreenMainState();
}

class _ScreenMainState extends State<ScreenMain> {
  final PageController _pageController = PageController(viewportFraction: 0.22, initialPage: 1);
  int _currentIndex = 1; // Set initial index to 1

  final List<IconData> icons = [
    Icons.bar_chart_rounded,
    Icons.add,
    Icons.inventory_2,
    Icons.person,
  ];

  final List<String> texts = [
    "Dashboard",
    "Add Order",
    "Inventory",
    "Profile",
  ];

  final List<Widget> screens = [
    ScreenDashboard(),
    ScreenAddOrder(),
    ScreenInventory(),
    ScreenProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Display the current screen
          screens[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 90,
              child: PageView.builder(
                controller: _pageController,
                itemCount: icons.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  double scale = _currentIndex == index ? 0.7 : 0.5;
                  return TweenAnimationBuilder(
                    tween: Tween<double>(begin: scale, end: scale),
                    duration: Duration(milliseconds: 300),
                    builder: (context, double scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                            setState(() {
                              _currentIndex = index; 
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              boxShadow: _currentIndex == index
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: Offset(0, 2),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Color.fromRGBO(184, 182, 182, 0.4),
                            ),
                            child: Center(
                              child: Icon(
                                icons[index],
                                color: _currentIndex == index
                                    ? Color(0xFF8C8C8C)
                                    : Colors.white,
                                size: _currentIndex == index ? 40 : 25,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
