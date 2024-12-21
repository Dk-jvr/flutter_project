import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle getTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ) ??
        TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ); 
  }

  static InputDecoration getInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Enter value',
      labelStyle: TextStyle(color: Colors.black54),
      hintText: 'Enter some text',
    );
  }

  static TextStyle getButtonTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  static TextStyle bodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black87,
        ) ??
        TextStyle(
          color: Colors.black87,
        );
  }

  static TextStyle captionStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ) ??
        TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        );
  }

  static TextStyle descriptionStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black54,
        ) ??
        TextStyle(
          color: Colors.black54,
        );
  }

  static TextStyle quantityTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.black87,
        ) ??
        TextStyle(
          color: Colors.black87,
        );
  }

  static TextStyle priceTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ) ??
        TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        );
  }
  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Use backgroundColor instead of primary
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
  );
}
