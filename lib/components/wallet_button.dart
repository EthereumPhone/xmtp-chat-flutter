import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const String _wcProjectId = "af3346694438a7a937ee3aee9968e8fa";

String _wcLogo(logoId, {size = "md"}) {
  return "https://explorer-api.walletconnect.com/v3/logo/$size/$logoId?projectId=$_wcProjectId";
}

enum WalletType { metamask, rainbow }

class WalletDetails {
  final String logoId;
  final String name;
  final String preUri;

  WalletDetails(
      {required this.logoId, required this.name, required this.preUri});
}

WalletDetails _getWallet(WalletType type) {
  switch (type) {
    case WalletType.metamask:
      return WalletDetails(
        logoId: "5195e9db-94d8-4579-6f11-ef553be95100",
        name: "Metamask",
        preUri: "metamask://wc?uri=",
      );
    case WalletType.rainbow:
      return WalletDetails(
        logoId: "7a33d7f1-3d12-4b5c-f3ee-5cd83cb1b500",
        name: "Rainbow",
        preUri: "rainbow://wc?uri=",
      );
  }
}

class WalletButton extends StatelessWidget {
  const WalletButton({
    Key? key,
    required this.type,
    required this.displayUri,
  }) : super(key: key);

  final WalletType type;
  final String displayUri;

  @override
  Widget build(BuildContext context) {
    var details = _getWallet(type);

    return ListTile(
      onTap: () {
        Navigator.pop(context);

        launchUrl(
          Uri.parse(details.preUri + displayUri),
          mode: LaunchMode.externalNonBrowserApplication,
        ).then((launched) {
          if (!launched) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to open ${details.name}"),
            ));
          }
        });
      },
      title: Text(details.name),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
          child: Image.network(
            _wcLogo(
              details.logoId,
              size: "sm",
            ),
            height: 40,
            width: 40,
          ),
        ),
      ),
    );
  }
}
