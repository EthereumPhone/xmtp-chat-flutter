import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:xmtp_chat/data/repository/account_repository_impl.dart';
import 'package:xmtp_chat/data/repository/xmtp_repository_impl.dart';
import 'package:xmtp_chat/data/xmtp/session.dart';
import 'package:xmtp_chat/domain/repository/account_repository.dart';
import 'package:xmtp_chat/domain/repository/xmtp_repository.dart';

@module
abstract class AppModule {
  XmtpRepository provideXmtpRepository(Session session) => XmtpRepositoryImpl(session);

  AccountRepository provideAccountRepository() => AccountRepositoryImpl(const FlutterSecureStorage());

  @singleton
  Session provideSession() => Session();
}
