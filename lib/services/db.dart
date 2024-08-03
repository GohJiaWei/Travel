import 'package:mysql1/mysql1.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DBService {
  Future<MySqlConnection> openConnection() async {
    var settings = ConnectionSettings(
      host: 'rm-zf8e67a77o9ujad37yo.mysql.kualalumpur.rds.aliyuncs.com',
      port: 3306,
      user: 'db_acc',
      password: 'Hack1234',
      db: 'db',
    );

    return await MySqlConnection.connect(settings);
  }

  Future<bool> authenticateUser(String email, String password) async {
    var conn = await openConnection();
    var results =
        await conn.query('SELECT password FROM users WHERE email = ?', [email]);

    await conn.close();

    if (results.isEmpty) {
      return false;
    }

    var hashedPassword = results.first['password'];
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    return digest.toString() == hashedPassword;
  }

  Future<void> registerUser(
      String username, String email, String password) async {
    var conn = await openConnection();

    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);

    await conn.query(
        'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
        [username, email, digest.toString()]);

    await conn.close();
  }

  Future<Results> fetchData() async {
    var conn = await openConnection();
    var results = await conn.query('SELECT * FROM users');
    await conn.close();
    return results;
  }
}
