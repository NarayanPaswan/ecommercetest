

import '../exports.dart';

class AppErrorSnackBar {
  final BuildContext context;
  AppErrorSnackBar(this.context);
  void error(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$e",
          style: const TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w400),
        ),
        // behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }
}
