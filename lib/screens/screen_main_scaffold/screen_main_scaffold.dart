import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:invento2/database/users/user_fuctions.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/screen_add/screen_add.dart';
import 'package:invento2/screens/screen_dashboard/screen_dashboard.dart';
import '../screen_inventory/screen_inventory.dart';
import '../screen_profile/screen_profile.dart';
import 'package:invento2/database/users/user_model.dart';

class ScreenMain extends StatefulWidget {
  final UserModel userdetails;
  const ScreenMain({super.key, required this.userdetails});

  @override
  // ignore: library_private_types_in_public_api
  _ScreenMainState createState() => _ScreenMainState();
}


class _ScreenMainState extends State<ScreenMain> {
  final PageController _pageController = PageController(viewportFraction: 0.22, initialPage: 1);
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    if (userDataNotifier.value.id.isNotEmpty) {
    log("Current User ID: ${userDataNotifier.value.id}");
    }
    
    

  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              ScreenDashboard(userData: widget.userdetails),
              ScreenAddOrder(userData: widget.userdetails), 
              ScreenInventory(userData: widget.userdetails),
              ScreenProfile(user: widget.userdetails,)  
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
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
                  return ValueListenableBuilder(
                    valueListenable:AppStyle.isDarkThemeNotifier ,
                    builder: (context, isDark, _){
                      return TweenAnimationBuilder(
                      tween: Tween<double>(begin: scale, end: scale),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, double scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                boxShadow: _currentIndex == index
                                    ? [
                                        BoxShadow(
                                          color: AppStyle.backgroundBlack.withOpacity(.5),
                                          offset: const Offset(0, 2),
                                          blurRadius: 20,
                                          spreadRadius: 6,
                                        ),
                                      ]
                                    : [],
                                shape: BoxShape.circle,
                                color: _currentIndex == index
                                    ? AppStyle.backgroundWhite
                                    : AppStyle.backgroundGrey,
                              ),
                              child: Center(
                                child: Icon(
                                  icons[index],
                                  color: _currentIndex == index
                                      ?  AppStyle.textPurple
                                      : AppStyle.backgroundWhite,
                                  size: _currentIndex == index ? 40 : 25,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
