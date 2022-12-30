import 'package:xmtp/xmtp.dart';
import 'package:xmtp_chat/domain/repository/xmtp_repository.dart';

class XmtpRepositoryImpl implements XmtpRepository {
  final Client client;

  XmtpRepositoryImpl({required this.client});

  @override
  Stream<Conversation> getConversations() {
    return client.streamConversations();
  }

  @override
  Stream<DecodedMessage> getMessages(Conversation conversation) {
    return client.streamMessages(conversation);
  }

  @override
  Future<Stream<DecodedMessage>> getMessagesWithAddress(String address) async {
    var conversation = await client.newConversation(address);
    return client.streamMessages(conversation);
  }

  @override
  Future<DecodedMessage> sendMessage(Conversation conversation, String content) {
    return client.sendMessage(conversation, content);
  }

  @override
  Future<DecodedMessage> sendMessageToAddress(String address, String content) async {
    var conversation = await client.newConversation(address);
    return client.sendMessage(conversation, content);
  }
}