import 'package:kasir_app/models/product.dart';
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

  Future<void> clearDatabase() async {
    try {
      var conn = await getConnection();

      // Hapus semua data dari tabel
      await conn.query('DELETE FROM ${Mysql.table}');

      await conn.close();

      print('Database cleared successfully.');
    } catch (error) {
      print('Error clearing database: $error');
    }
  }

  Future<void> createOrder(Product product, int quantity) async {
    try {
      var conn = await getConnection();

      // Ambil data produk dari database
      var productQuery = await conn
          .query('SELECT * FROM $table WHERE tyunit = ?', [product.tyunit]);
      var productList = productQuery.toList();

      if (productList.isNotEmpty) {
        var storedProduct = productList[0];
        int currentQuantity = storedProduct['jml'];

        if (currentQuantity >= quantity) {
          // Kurangi jumlah produk yang dipesan dari jumlah yang ada di database
          int remainingQuantity = currentQuantity - quantity;
          await conn.query('UPDATE $table SET jml = ? WHERE tyunit = ?',
              [remainingQuantity, product.tyunit]);

          // Tambahkan informasi pesanan baru ke dalam tabel pesanan

          // Commit transaksi
        } else {
          print('Error: Stok produk tidak mencukupi');
        }
      } else {
        print('Error: Produk tidak ditemukan');
      }

      await conn.close();
    } catch (error) {
      print('Error creating order: $error');
    }
  }
}
