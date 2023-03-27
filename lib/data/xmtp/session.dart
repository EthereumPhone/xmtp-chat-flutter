import 'dart:developer';

import 'package:web3dart/credentials.dart';
import 'package:xmtp/xmtp.dart' as xmtp;
import 'package:xmtp_chat/di/injection.dart';
import 'package:xmtp_chat/domain/repository/account_repository.dart';

import '../local/messages_store.dart';

class Session {
  late xmtp.Client _client;

  xmtp.Client get client => _client;

  Future<xmtp.Client> initSessionWithKeys() async {
    var api = xmtp.Api.create(host: "dev.xmtp.network", isSecure: true);

    var keys = await getIt<AccountRepository>().getKeys();
    if (keys != null) {
      var bundle = xmtp.PrivateKeyBundle.fromJson(keys);
      _client = await xmtp.Client.createFromKeys(api, bundle);
      // Save keys
      await getIt<AccountRepository>().saveKeys(_client.keys.writeToJson());
    }

    log("Client: ${_client.address.hexEip55}");

    _listenForNewConversations();

    return _client;
  }

  Future<xmtp.Client> initSession(Credentials wallet) async {
    var api = xmtp.Api.create(host: "dev.xmtp.network", isSecure: true);

    var signer = await wallet.asSigner();
    _client = await xmtp.Client.createFromWallet(api, signer);

    log("Client: ${_client.address.hexEip55}");

    _listenForNewConversations();

    return _client;
  }

  Future<xmtp.Client> initSessionWithSigner(xmtp.Signer signer) async {
    var api = xmtp.Api.create(host: "dev.xmtp.network", isSecure: true);
    _client = await xmtp.Client.createFromWallet(api, signer);
    // Save keys
    await getIt<AccountRepository>().saveKeys(_client.keys.writeToJson());
    return _client;
  }

  _listenForNewConversations() async {
    var existingConversations = await client.listConversations();
    store.setConversations(existingConversations);

    _client.streamConversations().listen((newConversation) {
      store.addConversation(newConversation);
    });
  }
}
