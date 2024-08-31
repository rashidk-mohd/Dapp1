import 'package:flutter/material.dart';

class ProceedButton extends StatelessWidget {
  const ProceedButton({super.key, this.text, this.onTap});
  final String? text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.2),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(60, 76, 106, 1),
              Color.fromRGBO(30, 60, 110, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,       
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text ?? "",
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
