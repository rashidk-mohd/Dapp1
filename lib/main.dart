import 'package:dapp/wallet_connection/screens/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late W3MService _w3mService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeW3MService();
  }

  void _initializeW3MService() async {
    try {
      _w3mService = W3MService(
        projectId: 'adced7e35b8e2dfa6593a41b9a75ba1b',
        metadata: const PairingMetadata(
          name: 'AppKit Flutter Example',
          description: 'AppKit Flutter Example',
          url: 'https://walletconnect.com/',
          icons: [
            'https://docs.walletconnect.com/assets/images/web3modalLogo-2cee77e07851ba0a710b56d03d4d09dd.png'
          ],
          redirect: Redirect(
            native: 'dapp://',
            universal: 'https://walletconnect.com/appkit',
          ),
        ),
      );
      await _w3mService.init();
      print("Wallet initialized: ${_w3mService.avatarUrl}");

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print("Error initializing WalletConnect: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Web3ModalTheme(
      isDarkMode: true,
      child: MaterialApp(
        title: 'AppKit Demo',
        home:WalletScreen(),
        
        //  Builder(
        //   builder: (context) {
        //     return Scaffold(
        //       appBar: AppBar(
        //         title: const Text('AppKit Demo'),
        //       ),
        //       backgroundColor: Web3ModalTheme.colorsOf(context).background300,
        //       body: _isInitialized
        //           ? Center(
        //               child: W3MConnectWalletButton(
        //                 service: _w3mService),
        //             )
        //           :const Center(
        //               child: CircularProgressIndicator(),
        //             ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
