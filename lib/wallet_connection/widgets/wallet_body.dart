import 'package:dapp/wallet_connection/screens/wallet_screen.dart';
import 'package:dapp/wallet_connection/widgets/fund_managing_button.dart';
import 'package:flutter/material.dart';

class WalletBody extends StatelessWidget {
  const WalletBody({super.key, this.fundAddOnTap, this.withDrawOnTap});
  final void Function()? fundAddOnTap;
  final void Function()? withDrawOnTap;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const BalanceCard(),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FuntManagingButton(
                    title: "Add Fund",
                    onTap: fundAddOnTap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FuntManagingButton(
                    title: "Withdraw Fund",
                    onTap:withDrawOnTap,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
