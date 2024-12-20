import 'package:flutter/material.dart';

class AppStyles {
  // Метод для получения стиля заголовка
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
        ); // Резервный стиль, если titleLarge равно null
  }

  // Метод для получения стиля для ввода
  static InputDecoration getInputDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Enter value',
      labelStyle: TextStyle(color: Colors.black54),
      hintText: 'Enter some text',
    );
  }

  // Метод для получения стиля текста кнопки
  static TextStyle getButtonTextStyle() {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
  }

  // Другие стили, если нужны
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
}
