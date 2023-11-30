import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  final String role;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed; // Make onPressed nullable

  const RoleCard({
    Key key, // Make Key nullable
    this.role,
    this.icon,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if the card is enabled based on whether onPressed is null
    final bool isEnabled = onPressed != null;

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: isEnabled ? color : Colors.grey, // Use grey if the button is disabled
        onPrimary: Colors.white,
        minimumSize: Size(double.infinity, 50),
      ).copyWith(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.shade200; // Lighter shade of grey for the overlay color
            }
            return null; // Defer to the widget's default.
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return TextStyle(color: Colors.white.withOpacity(0.5), inherit: false); // Add inherit: false explicitly
            }
            return TextStyle(color: Colors.white, inherit: false); // Add inherit: false explicitly
          },
        ),
      ),
      icon: Icon(icon, size: 24, color: isEnabled ? null : Colors.white.withOpacity(0.5)), // More transparent icon if disabled
      label: Text(role, style: TextStyle(inherit: false, color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5))), // Add inherit: false explicitly
      onPressed: onPressed, // If null, the button will be disabled automatically
    );
  }
}
