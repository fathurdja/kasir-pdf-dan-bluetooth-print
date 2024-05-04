import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.0.106',
      user = 'admin',
      password = 'Abn913689',
      db = 'kutacanemart',
      table = 'unitpudtl';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}
