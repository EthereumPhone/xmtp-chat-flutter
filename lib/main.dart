import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';
import 'package:xmtp_chat/data/xmtp/session.dart';
import 'package:xmtp_chat/domain/repository/account_repository.dart';
import 'package:xmtp_chat/screens/home/home_screen.dart';
import 'package:xmtp_chat/screens/login/login_screen.dart';

import 'di/injection.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();

  var accountRepository = getIt<AccountRepository>();
  var session = getIt<Session>();

  var privateKey = await accountRepository.getPrivateKey();
  var keys = await accountRepository.getKeys();
  if (privateKey != null) {
    var wallet = EthPrivateKey.fromHex(privateKey);
    await session.initSession(wallet);
  } else if (keys != null) {
    await session.initSessionWithKeys();
  }

  runApp(MyApp(
    isConnected: keys != null || privateKey != null,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isConnected = false});

  final bool isConnected;

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
      home: !isConnected ? const LoginScreen() : const HomeScreen(),
      navigatorKey: navigatorKey,
    );
  }
}
