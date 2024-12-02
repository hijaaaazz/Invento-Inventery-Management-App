import 'package:flutter/material.dart';
import 'package:invento2/helpers/styles_helper/styles_helper.dart';
import 'package:invento2/screens/widgets/app_bar.dart';

class ScreenAbout extends StatelessWidget {
  const ScreenAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundWhite,
      appBar: appBarHelper("about us"),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Invento!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Our app is designed to help you efficiently manage your inventory and sales, making your business operations smoother and more productive.",
              style: TextStyle(fontSize: 16),
            ),
            Divider(height: 30, thickness: 1),
            Text(
              "Our Mission",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We aim to provide a simple yet powerful solution for businesses to:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• Keep track of inventory.", style: TextStyle(fontSize: 16)),
                  Text("• Analyze sales data with ease.", style: TextStyle(fontSize: 16)),
                  Text("• Make informed decisions using clear, interactive charts.", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Divider(height: 30, thickness: 1),
            Text(
              "Key Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• Sales Tracking: View and compare daily, monthly, and yearly performance.",
                      style: TextStyle(fontSize: 16)),
                  Text("• Interactive Charts: Gain insights into your revenue trends.",
                      style: TextStyle(fontSize: 16)),
                  Text("• Inventory Management: Keep all your products organized in one place.",
                      style: TextStyle(fontSize: 16)),
                  Text("• Seamless Feedback: Share your experience or suggestions directly from the app.",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Divider(height: 30, thickness: 1),
            Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "We value your feedback and are here to assist you with any queries or suggestions. Feel free to reach out:",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Email: mkcnkd@gmail.com",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            Divider(height: 30, thickness: 1),
            Text(
              "Version Info",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Current Version: 1.0.0\nStay tuned for updates as we continue improving your experience!",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
