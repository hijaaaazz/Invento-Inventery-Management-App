import 'package:flutter/material.dart';

class SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? textColor;

  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: trailing == null ? Colors.white : const Color.fromARGB(255, 223, 223, 223),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(icon,color: textColor,),
          ),
          Expanded(
            child: Text(
              title,
              style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w500,color: textColor),
            ),
          ),
          if (trailing != null) Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: trailing),
        ],
      ),
    );
  }
}
