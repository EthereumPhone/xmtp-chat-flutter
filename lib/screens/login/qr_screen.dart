import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({Key? key, required this.displayUri}) : super(key: key);

  final String displayUri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 16),
                Row(),
                QrImage(
                  data: displayUri,
                  version: QrVersions.auto,
                  size: 300,
                  gapless: true,
                  foregroundColor: Theme.of(context).colorScheme.onBackground,
                ),
                const Text("Scan this code to connect"),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: displayUri)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Copied")),
                    );
                  });
                },
                icon: const Icon(Icons.copy_outlined),
                label: const Text("Copy to clipboard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
