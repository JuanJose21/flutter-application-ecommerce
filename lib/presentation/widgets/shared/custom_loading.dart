import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  final Color spinnerColor;
  final double spinnerSize;

  const CustomLoading({
    super.key,
    this.spinnerColor = Colors.deepPurple,
    this.spinnerSize = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            strokeWidth: 4.0,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
