import 'package:kasir_app/models/product.dart';
import 'package:kasir_app/models/stock.dart';
import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.0.107',
      user = 'admin',
      password = 'Abn913689',
      db = 'morotaimart',
      table = 'unitpudtl';
  static int port = 3306;
  static void updateHost(String newHost) {
    host = newHost;
  }

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    print(settings);
    print("SERVER CONNECTED");
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

  Future<List<Stock>> getData() async {
    var conn = await getConnection();
    List<Stock> stockList = [];

    var results = await conn.query(
      '''
    SELECT unitpudtl.NOBUKTI, unitpudtl.tglpu, unitpudtl.tyunit, unitpudtl.barcode, unitpudtl.jml, 
           unitpudtl.harga, unitpudtl.cmodule, unitpudtl.kcabang, unitpudtl.tglup, unitpudtl.userup,
           munit.NTYUNIT, munit.hjual
    FROM unitpudtl
    JOIN munit ON unitpudtl.tyunit = munit.TYUNIT;
  ''',
    ); // Modify query and parameters as per your need

    for (var row in results) {
      stockList.add(Stock(
        noBukti: row['NOBUKTI'],
        tglpu: row['tglpu'],
        tyunit: row['tyunit'],
        barcode: row['barcode'],
        jml: row['jml'],
        harga: row['harga'],
        cmodule: row['cmodule'],
        kcabang: row['kcabang'],
        tglup: row['tglup'],
        userup: row['userup'],
        namaUnit: row['NTYUNIT'], // From munit
        hargaJual: row['hjual'],
      ));
    }

    return stockList; // Return the list of Stock
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

  Future<List<Stock>> fetchDataFromDatabase() async {
    // Buat koneksi ke database
    var conn = await getConnection();
    List<Stock> stockList = [];

    // Query untuk mengambil data produk dari tabel 'munit'
    var results = await conn.query('''
    SELECT unitpudtl.NOBUKTI, unitpudtl.tglpu, unitpudtl.tyunit, unitpudtl.barcode, unitpudtl.jml, 
           unitpudtl.harga, unitpudtl.cmodule, unitpudtl.kcabang, unitpudtl.tglup, unitpudtl.userup,
           munit.NTYUNIT, munit.hjual
    FROM unitpudtl
    JOIN munit ON unitpudtl.tyunit = munit.TYUNIT;
  ''');

    // Kosongkan stockList sebelum memasukkan data baru
    stockList.clear();

    // Masukkan hasil query ke dalam stockList
    for (var row in results) {
      stockList.add(Stock(
        noBukti: row['NOBUKTI'],
        tglpu: row['tglpu'],
        tyunit: row['tyunit'],
        barcode: row['barcode'],
        jml: row['jml'],
        harga: row['harga'],
        cmodule: row['cmodule'],
        kcabang: row['kcabang'],
        tglup: row['tglup'],
        userup: row['userup'],
        namaUnit: row['NTYUNIT'], // From munit
        hargaJual: row['hjual'],
      ));
    }

    // Tutup koneksi
    return stockList;

    // Update UI setelah data diambil
  }

  Future<int> transferStock(
      String itemCode, int quantity, String nobukti) async {
    final conn = await getConnection();
    int transferredRows = 0;
    int remainingQuantity = quantity;

    await conn.transaction((ctx) async {
      // Get the rows for the given item code (order by some unique ID to ensure consistency)
      var stockResults = await ctx.query('''
        SELECT s.*, m.NTYUNIT, k.KLOKASI2, m.hjual 
      FROM unitpudtl s
      JOIN munit m ON s.tyunit = m.TYUNIT
      JOIN unitpuhd k ON s.NOBUKTI = k.NOBUKTI 
      WHERE m.NTYUNIT = ? AND s.NOBUKTI = ?
      LIMIT ?
    ''', [itemCode, nobukti, remainingQuantity]);

      // Loop through the rows and transfer to the order table
      for (var row in stockResults) {
        if (remainingQuantity <= 0) break; // Stop when quantity is fulfilled

        print('Processing row with stock data: ${row.fields}');

        // Insert into order table (for each stock row)
        try {
          await ctx.query('''
        INSERT INTO `unitkeldtl` (KLOKASI, TGLKEL, NOBUKTI, barcode, TYUNIT, jml, hpp, hjual, nethjual, cmodule, userup, tglup) 
        VALUES (?, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
      ''', [
            row['KLOKASI2'] ?? '',
            row['NOBUKTI'] ?? '',
            row['barcode'] ?? '',
            row['NTYUNIT'] ?? '',
            1, // Since each row has 1 item (per the image)
            row['hpp'] ?? 0.0,
            row['hjual'] ?? 0.0,
            row['nethjual'] ?? 0.0,
            row['cmodule'] ?? '',
            row['userup'] ?? '',
          ]);
        } catch (e) {
          print('Error saat melakukan INSERT: $e');
        }

        // Remove the stock row from `unitpudtl`
        try {
          await ctx
              .query('DELETE FROM unitpudtl WHERE tyunit = ?', [row['tyunit']]);
        } catch (e) {
          print('Error saat DELETE: $e');
        }

        remainingQuantity--; // Decrease the remaining quantity to transfer
        transferredRows++; // Increase transferred rows count
      }
    });

    return transferredRows;
  }

  Future<List<Map<String, dynamic>>> getDataFromUnitKelDtl() async {
    final conn = await getConnection();

    var results = await conn.query('''
      SELECT * FROM unitkeldtl 
      WHERE DATE(tglup) = CURDATE() 
      ORDER BY tglup DESC
  ''');

    // Mengonversi hasil query menjadi list of maps
    return results.map((row) => row.fields).toList();
  }
}
