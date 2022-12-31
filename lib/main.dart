import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';
import 'package:xmtp_chat/data/xmtp/session.dart';
import 'package:xmtp_chat/domain/repository/account_repository.dart';
import 'package:xmtp_chat/screens/home/home_screen.dart';
import 'package:xmtp_chat/screens/login/login_screen.dart';

import 'di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  var session = getIt<Session>();
  var accountRepository = getIt<AccountRepository>();

  var privateKey = await accountRepository.getPrivateKey();
  if (privateKey != null) {
    var wallet = EthPrivateKey.fromHex(privateKey);
    await session.initSession(wallet);
  }

  runApp(MyApp(privateKey: privateKey));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.privateKey});

  final String? privateKey;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF9667DD),
        colorScheme: const ColorScheme.light(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: const Color(0xFF9667DD),
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: const Color(0xFF232323),
      ),
      home: privateKey == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
