import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:xmtp/xmtp.dart';
import 'package:xmtp_chat/components/wallet_button.dart';
import 'package:xmtp_chat/data/xmtp/session.dart';
import 'package:xmtp_chat/di/injection.dart';
import 'package:xmtp_chat/main.dart';
import 'package:xmtp_chat/screens/home/home_screen.dart';
import 'package:xmtp_chat/screens/login/qr_screen.dart';

class WalletsSheet extends StatefulWidget {
  const WalletsSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: ((_) {
        return const WalletsSheet();
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  State<WalletsSheet> createState() => _WalletsSheetState();
}

class _WalletsSheetState extends State<WalletsSheet> {
  String _displayUri = "";
  late WalletConnect _connector;

  _connect() async {
    _connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'XMTP Chat',
        description: 'An XMTP chat app.',
        url: 'https://xmtp.org',
        icons: ['https://xmtp.vercel.app/xmtp-icon.png'],
      ),
    );

    _connector.on('connect', (session) async {
      log("connect: $session");
      var address = _connector.session.accounts.first;
      var signer = Signer.create(
        address,
        (text) {
          return _connector.sendCustomRequest(
            method: "personal_sign",
            params: [text, address],
          ).then((value) => hexToBytes(value));
        },
      );

      await getIt<Session>().initSessionWithSigner(signer);

      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) {
            return const HomeScreen();
          },
        ),
        (route) => false,
      );
    });

    await _connector.createSession(
      chainId: 4160,
      onDisplayUri: (uri) {
        setState(() {
          _displayUri = uri;
        });
      },
    );
  }

  _showQR() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return QRScreen(displayUri: _displayUri);
    }));
  }

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    if (_displayUri.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Connect Wallet",
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Select what wallet you want to connect bellow.",
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          WalletButton(type: WalletType.metamask, displayUri: _displayUri),
          const Divider(height: 1),
          WalletButton(type: WalletType.rainbow, displayUri: _displayUri),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: _showQR,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Show QR Code"),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
