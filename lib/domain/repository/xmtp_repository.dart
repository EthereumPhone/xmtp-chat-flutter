import 'package:xmtp/xmtp.dart';

abstract class XmtpRepository {
  Future<DecodedMessage> sendMessage(Conversation conversation, String content);

  Future<DecodedMessage> sendMessageToAddress(String address, String content);

  Stream<Conversation> getConversations();

  Stream<DecodedMessage> getMessages(Conversation conversation);

  Future<Stream<DecodedMessage>> getMessagesWithAddress(String address);
}
