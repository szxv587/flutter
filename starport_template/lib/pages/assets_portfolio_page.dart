import 'package:cosmos_ui_components/components/content_state_switcher.dart';
import 'package:cosmos_ui_components/components/gradient_avatar.dart';
import 'package:cosmos_ui_components/components/template/cosmos_wallets_list_view.dart';
import 'package:cosmos_ui_components/cosmos_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:starport_template/entities/balance.dart';
import 'package:starport_template/starport_app.dart';
import 'package:starport_template/widgets/asset_portfolio_heading.dart';
import 'package:starport_template/widgets/balance_card_list.dart';
import 'package:starport_template/widgets/starport_button_bar.dart';

class AssetsPortfolioPage extends StatefulWidget {
  final WalletInfo walletInfo;

  const AssetsPortfolioPage({Key? key, required this.walletInfo}) : super(key: key);

  @override
  _AssetsPortfolioPageState createState() => _AssetsPortfolioPageState();
}

class _AssetsPortfolioPageState extends State<AssetsPortfolioPage> {
  ObservableList<Balance> get balancesList => StarportApp.walletsStore.balancesList;

  bool get isBalancesLoading => StarportApp.walletsStore.isBalancesLoading;

  bool get isSendMoneyLoading => StarportApp.walletsStore.isSendMoneyLoading;

  bool get isError => StarportApp.walletsStore.isBalancesLoadingError;

  @override
  void initState() {
    super.initState();
    _fetchWalletBalances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Observer(
            builder: (context) => ContentStateSwitcher(
              contentChild: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      _buildGradientAvatar(context),
                      AssetPortfolioHeading(title: widget.walletInfo.name),
                      SizedBox(height: CosmosTheme.of(context).spacingXL),
                      const Divider(),
                      SizedBox(height: CosmosTheme.of(context).spacingL),
                      SizedBox(height: CosmosTheme.of(context).spacingM),
                      BalanceCardList(balancesList: balancesList),
                    ],
                  ),
                  StarportButtonBar(onReceivePressed: () {}, onSendPressed: () {}),
                ],
              ),
              isLoading: isBalancesLoading,
              isError: isError,
              errorChild: const Center(child: Text('An unexpected error occurred')),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildGradientAvatar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(CosmosTheme.of(context).spacingL),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(height: 35, child: GradientAvatar(stringKey: widget.walletInfo.address)),
      ),
    );
  }

  // TODO: To be used when implementing send money

  // void _transferPressed(Balance balance) {
  //   final denom = Denom(balance.denom.text);
  //   _openSendMoneySheet(denom);
  // }

  // Future<void> _openSendMoneySheet(Denom denom) async {
  //   final result = await showModalBottomSheet(
  //     context: context,
  //     builder: (context) => SafeArea(
  //       child: SendMoneySheet(
  //         denom: denom,
  //         walletInfo: widget.walletInfo,
  //       ),
  //     ),
  //   );
  //   if (result == true) {
  //     StarportApp.walletsStore.getBalances(widget.walletInfo.address);
  //   }
  // }

  Future _fetchWalletBalances() async {
    await StarportApp.walletsStore.getBalances(widget.walletInfo.address);
  }
}