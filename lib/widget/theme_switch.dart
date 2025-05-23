import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggle;

  const ThemeSwitch({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDarkMode,
      activeColor: Colors.black,
      inactiveTrackColor: Colors.grey.shade600,
      inactiveThumbColor: Colors.blue,
      activeTrackColor: Colors.white,
      onChanged: onToggle,
    );
  }
}
