import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:xmtp_chat/domain/repository/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  late final FlutterSecureStorage _secureStorage;

  AccountRepositoryImpl(FlutterSecureStorage secureStorage) {
    _secureStorage = secureStorage;
  }

  static const storageKey = "private_key";
  static const keysKey = "keys";

  @override
  Future<String?> getPrivateKey() async {
    return await _secureStorage.read(key: storageKey);
  }

  @override
  Future<void> savePrivateKey(String privateKey) async {
    await _secureStorage.write(key: storageKey, value: privateKey);
  }

  @override
  Future<void> deletePrivateKey() async {
    await _secureStorage.delete(key: storageKey);
  }

  @override
  Future<String?> getKeys() async {
    return await _secureStorage.read(key: keysKey);
  }

  @override
  Future<void> saveKeys(String keys) async {
    await _secureStorage.write(key: keysKey, value: keys);
  }

  @override
  Future<void> deleteKeys() async {
    await _secureStorage.delete(key: keysKey);
  }
}
