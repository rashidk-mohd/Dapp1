
import 'package:flutter/material.dart';

class FuntManagingButton extends StatelessWidget {
  const FuntManagingButton({super.key, this.title, this.onTap});
  final String? title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.2),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(60, 76, 106, 1),
              Color.fromRGBO(30, 60, 110, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}