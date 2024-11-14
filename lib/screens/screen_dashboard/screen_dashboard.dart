import 'package:flutter/material.dart';

class ScreenDashboard extends StatefulWidget {
  final dynamic userData;

  const ScreenDashboard({super.key, required this.userData});

  @override
  State<ScreenDashboard> createState() => _ScreenDashboardState();
}

class _ScreenDashboardState extends State<ScreenDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, -1), 
      end: const Offset(0, 0),    
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void toggleDrawer() {
    setState(() {
      if (isDrawerOpen) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      isDrawerOpen = !isDrawerOpen;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Drawer Example'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: toggleDrawer,
        ),
      ),
      body: Stack(
        children: [
          // Main content of the screen
          const Center(
            child: Text('Main Content'),
          ),

          // Semi-transparent background when drawer is open
          if (isDrawerOpen)
            GestureDetector(
              onTap: toggleDrawer,
              child: Container(
                color: Colors.black.withOpacity(0.5), // Black with 50% opacity
              ),
            ),

          // Top Drawer
          SlideTransition(
            position: _animation,
            child: Container(
              height: 250,
              color: Colors.blue[300],
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
