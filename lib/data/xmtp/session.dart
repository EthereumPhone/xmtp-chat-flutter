import 'dart:developer';

import 'package:web3dart/credentials.dart';
import 'package:xmtp/xmtp.dart' as xmtp;

import '../local/messages_store.dart';

late xmtp.Client client;

Future<xmtp.Client> initSession(Credentials wallet) async {
  var api = xmtp.Api.create(host: "dev.xmtp.network", isSecure: true);
  client = await xmtp.Client.createFromWallet(api, wallet);
  log("Client: ${client.address.hexEip55}");

  var existingConversations = await client.listConversations();
  store.setConversations(existingConversations);

  client.streamConversations().listen((newConversation) {
    store.addConversation(newConversation);
  });

  return client;
}
