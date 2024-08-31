import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
const bluetext=  Color.fromRGBO(30, 49, 103, 1);
const gradnew = Color.fromRGBO(60, 76, 106, 1);
const gradnew1 = Color.fromRGBO(30, 60, 110, 1);
const white = Color.fromRGBO(255, 255, 255, 1);
class WithdrawalAmountScreen extends StatefulWidget {
  const WithdrawalAmountScreen({super.key});

  @override
  State<WithdrawalAmountScreen> createState() => _WithdrawalAmountScreenState();
}

class _WithdrawalAmountScreenState extends State<WithdrawalAmountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bluetext,
      appBar: AppBar(
        backgroundColor: bluetext,
        title: const Text(
          "Withdrawal Amount",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => TransferRubidiumWallet()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient:const LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                            child: Text(
                          "Transfer to Rubidya wallet",
                          style: TextStyle(fontSize: 14, color: white),
                        )),
                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => TransferToRubediumExchange()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.2),
                    gradient: LinearGradient(
                      colors: [gradnew, gradnew1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                            child: Text(
                          "Transfer to Rubideum Exchange",
                          style: TextStyle(fontSize: 14, color: white),
                        )),
                        SvgPicture.asset(
                          "assets/svg/arrowright.svg",
                          height: 12,
                        ),
                      ],
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
