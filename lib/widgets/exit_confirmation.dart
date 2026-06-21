import 'package:flutter/material.dart';

class ExitConfirmation {
  static Future<bool> showExitDialog(BuildContext context) async {
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Exit',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    
    return shouldExit ?? false;
  }
}