import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, this.message = 'حدث خطأ غير متوقع'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خطأ', style: TextStyle(fontFamily: 'Cairo'))),
      body: Center(child: Text(message, style: const TextStyle(color: Colors.red))),
    );
  }
}
