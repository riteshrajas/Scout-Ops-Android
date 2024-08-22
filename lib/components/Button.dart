import 'package:flutter/material.dart';

Widget buildButton({
  required BuildContext context,
  required String text,
  required Color color,
  Color? borderColor,
  required IconData icon,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width - 60,
    height: 70,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: borderColor != null
              ? BorderSide(color: borderColor)
              : BorderSide.none,
        ),
      ),
      icon: Icon(icon, size: 24),
      label: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    ),
  );
}
