import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildButton({
  required BuildContext context,
  required String text,
  required Color color,
  Color? borderColor,
  Color? iconColor,
  required IconData icon,
  required VoidCallback onPressed,
  Color? textColor,
}) {
  // Create a slightly darker shade for gradient effect
  Color darkShade = HSLColor.fromColor(color)
      .withLightness(
          (HSLColor.fromColor(color).lightness - 0.1).clamp(0.0, 1.0))
      .toColor();

  return Padding(
    padding:
        const EdgeInsets.symmetric(horizontal: 20), // Added horizontal margin
    child: SizedBox(
      width: double.infinity, // Fill available width
      height: 90,
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
        icon: Icon(icon, size: 24, color: iconColor ?? const Color(0xA1CCC2C2)),
        label: Text(
          text,
          style: GoogleFonts.museoModerno(
            fontSize: 25,
            color: textColor ?? const Color(0xA1CCC2C2),
          ),
        ),
      ),
    ),
  );
}
