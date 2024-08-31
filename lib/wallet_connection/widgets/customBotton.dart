import 'package:flutter/material.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';

class CustomConnectWalletButton extends StatelessWidget {
  final W3MService _w3mService;

  CustomConnectWalletButton({required W3MService w3mService})
      : _w3mService = w3mService;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return 
    GestureDetector(
        onTap: () async {
          // Manually trigger the wallet connection
          await _w3mService.connectSelectedWallet();
        },
        child:
         Container(
          width: screenWidth * 0.4, // Adjust width based on screen size
          height: 40,
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '\$5 platform charge',
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ));
  }
}
