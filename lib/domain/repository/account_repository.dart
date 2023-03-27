abstract class AccountRepository {
  Future<void> savePrivateKey(String privateKey);

  Future<String?> getPrivateKey();

  Future<void> deletePrivateKey();

  Future<String?> getKeys();

  Future<void> saveKeys(String keys);

  Future<void> deleteKeys();
}
