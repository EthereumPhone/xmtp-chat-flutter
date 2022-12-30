import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

Future<String?> getPrivateKey() async {
  // await storage.deleteAll();
  return await storage.read(key: "private_key");
}

Future setPrivateKey(String key) async {
  await storage.write(key: "private_key", value: key);
}
