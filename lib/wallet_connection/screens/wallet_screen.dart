import 'dart:convert';
import 'dart:developer';

import 'package:dapp/wallet_connection/screens/withdraw_amount_screen.dart';
import 'package:dapp/wallet_connection/widgets/proceed_button.dart';
import 'package:dapp/wallet_connection/widgets/wallet_body.dart';
import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:flutter/services.dart' show SystemChannels, rootBundle;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  W3MService? _w3mService;
  // late Web3Client _web3client;
  bool _isInitialized = false;
  bool isConncetWallet = false;
  String? adresss;

  final erc20Abi = """[
    "function approve(address spender, uint256 amount) external returns (bool)",
    "function allowance(address owner, address spender) external view returns (uint256)",
    "function transferFrom(address from, address to, uint256 amount) external returns (bool)",
    "function balanceOf(address account) external view returns (uint256)",
    "function transfer(address to, uint256 amount) returns (bool)"
  ]""";

  final usdtAddress = '0x7169D38820dfd117C3FA1f22a697dBA58d90BA06';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomDialogForPlatFormCharge(context);
    });
    _initializeW3MService();

    print("InitState us Work");
    super.initState();
  }

  Future<void> addFund(String from, num amount) async {
    try {
      String abiString =
          await rootBundle.loadString('assets/web3_config/USDT_abi.json');
      final deployedContract = DeployedContract(
        ContractAbi.fromJson(abiString, "USDT"),
        EthereumAddress.fromHex(usdtAddress),
      );
      log("transaction_============================>${deployedContract.address}");
      final transaction = Transaction(
        to: EthereumAddress.fromHex(
            "0x3D3956fbD188A706D921d912ab49EBC39ecdD33F"),
        from: EthereumAddress.fromHex(from),
        gasPrice: EtherAmount.inWei(BigInt.one),
      );
      log("transaction_============================>$transaction");
      // final suplyToken = await _w3mService?.requestReadContract(
      //   chainId: "eip155:11155111",
      //   topic: _w3mService?.session?.topic,
      //   deployedContract: deployedContract,
      //   functionName: 'totalSupply',
      // );
      final request = await _w3mService?.request(
        // switchToChainId: ,

        topic: _w3mService?.session?.topic ?? '',
        chainId: 'eip155:11155111',
        request: const SessionRequestParams(
          method: 'eth_signTransaction',
          params: '{json serializable parameters}',
        ),
      );
      // final suplyToken=  await  getTotalSupply(deployedContract,"eip155:11155111",_w3mService?.session?.topic);
      print(" supply token ====>   $request");

      final result = await _w3mService?.requestWriteContract(
        transaction: transaction,
        chainId: "eip155:11155111",
        topic: _w3mService?.session?.topic,
        deployedContract: deployedContract,
        functionName: 'transfer',
        parameters: [
          EthereumAddress.fromHex("0x3D3956fbD188A706D921d912ab49EBC39ecdD33F"),
          BigInt.from(amount),
        ],
      );
      print("result-->> $result");
    } catch (e) {
      print('Error during USDT transfer: $e');
    }
  }
// Future<List<dynamic>> getTotalSupply(DeployedContract deployedContract,String? chainId,String? topic) async {
//   // Get token total supplyDeployedContract deployedContract

//   return result??["Empty List"];
// }
  Future<void> _initializeW3MService() async {
    try {
      setState(() {
        _isInitialized = true;
      });
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
      await _w3mService?.init();

      setState(() {
        _isInitialized = false;
      });
    } catch (e) {
      print("Error initializing WalletConnect: $e");
    }
  }

  getAdress() async {
    _w3mService?.getApprovedEvents();
    _w3mService?.getApprovedChains();
    _w3mService?.onModalConnect.subscribe((ModalConnect? event) async {
      log("Adress");
      if (event != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('address', event.session.address.toString());
        print(
            'Session data saved successfully! ${event.session.address.toString()}');
      } else {
        print('No event received.');
      }
    });
  }

  getOwnAddress() async {
    final prefs = await SharedPreferences.getInstance();

    adresss = prefs.getString('address');
    log("adresss=============>>  $adresss");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: WalletAppBar(
        w3mService: _w3mService,
      ),
      body: _isInitialized
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                WalletBody(
                  fundAddOnTap: () {
                    setState(() {
                      isConncetWallet = _w3mService!.isConnected;
                    });
                    getAdress();
                    getOwnAddress();
                    try {
                      _initializeW3MService().then(
                        (value) {
                          addFund(adresss!, 1);
                        },
                      );
                    } catch (e) {
                      print("error when on  tap $e");
                    }
                  },
                  withDrawOnTap: isConncetWallet == false
                      ? null
                      : () {
                          _showAmountModalBottomSheet(context, "Withdraw Fund",
                              isAddFund: true);
                        },
                ),
                // isConncetWallet == false
                //     ? const SizedBox()
                //     : W3MAccountButton(service: _w3mService),
              ],
            ),
    );
  }

  void _showAmountModalBottomSheet(BuildContext context, String title,
      {bool isAddFund = true}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 21, 44, 63),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Image.asset(
                        "assets/logo/logowt.png",
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const AmountInputDialog(),
              isAddFund
                  ? const SizedBox(
                      height: 10,
                    )
                  : const SizedBox(),
              isAddFund
                  ? const Text(
                      "A service charge of \$0.50 will be applied to this transaction.",
                      style: TextStyle(color: Colors.white),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              ProceedButton(
                text: "Submit",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showCustomDialogForSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Image.asset("assets/logo/Icon_success.png"),
              const Text(
                "Payment Success",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
              const Text(
                "Your Wallet membership has been ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "successfully done",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(height: 40)
            ],
          ),
          content: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: bluetext, borderRadius: BorderRadius.circular(10)),
                width: 50,
                height: 50.0,
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        );
      },
    );
  }
}

void showCustomDialogForPlatFormCharge(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/logo/doller_icon.png"),
            ),
            const Text(
              "Please complete your payment to",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "continue using our services  ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "without interruption",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
        content: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: bluetext, borderRadius: BorderRadius.circular(10)),
              width: 50,
              height: 50.0,
              child: const Text(
                '\$5 platform charge',
                style: TextStyle(color: Colors.white),
              )),
        ),
      );
    },
  );
}

class AmountInputDialog extends StatelessWidget {
  const AmountInputDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Enter amount',
        hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        border: OutlineInputBorder(),
      ),
      onChanged: (text) {},
      style: const TextStyle(fontSize: 14),
    );
  }
}

class WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalletAppBar({super.key, this.onTap, this.w3mService});

  final void Function()? onTap;
  final W3MService? w3mService;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20.0),
        bottomRight: Radius.circular(20.0),
      ),
      child: Container(
        color: bluetext,
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // Ensures the column only takes the required space
          children: [
            AppBar(
              backgroundColor: bluetext,
              automaticallyImplyLeading: false,
              centerTitle: true,
              elevation: 0,
              title: const Text(
                "Wallet Connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, // Increase font size for better visibility
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between title and buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0), // Padding for the buttons
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      width: screenWidth *
                          0.4, // Adjust width based on screen size
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
                    ),
                  ),
                  W3MConnectWalletButton(service: w3mService ?? W3MService()),
                  // // Right button
                  // Container(
                  //   width: screenWidth * 0.4, // Adjust width based on screen size
                  //   height: 40,
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12.0,
                  //     vertical: 6.0,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white.withOpacity(0.2),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: const Row(
                  //     children: [
                  //       Expanded(
                  //         child: Text(
                  //           'Dynamic Text', // Replace with your actual dynamic text
                  //           style: TextStyle(color: Colors.white),
                  //           overflow: TextOverflow.ellipsis,
                  //         ),
                  //       ),
                  //       SizedBox(width: 8.0),
                  //       CircleAvatar(
                  //         radius: 20,
                  //         backgroundImage: AssetImage('assets/logo/rubidyalogosmall.png'),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 10), // Additional space if needed
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(150.0); // Adjust the height to fit the content
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 177,
          width: double.infinity,
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
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Available balance",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logowt.png",
                    height: 30,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "12.8900", // Add balance value here
                    style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AmountInputField extends StatelessWidget {
  const AmountInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Enter your Amount',
        hintStyle: const TextStyle(color: Colors.white, fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Image.asset(
          "assets/logo/logowt1.png",
          height: 20,
        ),
      ),
      onChanged: (text) {},
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }
}
