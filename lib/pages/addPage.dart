// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kasir_app/models/mysql.dart';
import 'package:kasir_app/models/product.dart';
import 'package:kasir_app/models/stock.dart';
import 'package:mysql1/mysql1.dart';

class AddProduct extends StatefulWidget {
  AddProduct({required this.addNew, required this.stockList});
  final Function addNew;
  final List<Stock> stockList;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? namaProdukc; // Initialize as nullable
  final jumlahProdukc = TextEditingController();
  final hargaProdukc = TextEditingController();
  final customerC = TextEditingController();
  List<Map<String, dynamic>> data = [];
  late Map<String, dynamic> produkMap;

  int qty = 0;
  var db = Mysql();
  String noBukti = '';

  Product newProduct = Product(
      noBukti:
          '', // Tidak perlu memasukkan NOBUKTI karena akan di-generate otomatis
      tglpu: DateTime.now().toString(),
      tyunit: '',
      barcode: '',
      jml: 0,
      harga: 100.0,
      cmodule: 'RM12',
      userup: 'adminbrg',
      tglup: '',
      kcabang: '001');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produkMap = {
      for (var stock in widget.stockList)
        stock.namaUnit ?? "No Name": {
          'hargaJual': stock.hargaJual ?? 0.0,
          'kcabang': stock.kcabang,
          'NOBUKTI': stock.noBukti,
          'Barcode': stock.barcode,
          "jml": stock.jml
        }
    };
    print(produkMap);
  }

  @override
  // menghapus semua controller
  void dispose() {
    jumlahProdukc.dispose();
    hargaProdukc.dispose();
    customerC.dispose();
    super.dispose();
  }

//  membuat Order Baru
  void saveNewOrder() {
    final customer = customerC.text;
    if (namaProdukc == null || jumlahProdukc.text.isEmpty || customer.isEmpty) {
      return;
    }
    final int? jumlahProduk = int.tryParse(jumlahProdukc.text);
    final double hargaProduk = double.tryParse(hargaProdukc.text) ?? 0.0;
    if (jumlahProduk == null || jumlahProduk <= 0) {
      return;
    }
    setState(() {
      qty = jumlahProduk;
      newProduct = Product(
          noBukti: '', // NoBukti akan di-generate secara otomatis
          tglpu: DateTime.now().toString(),
          tyunit: namaProdukc!,
          barcode: '',
          jml: jumlahProduk,
          harga: hargaProduk,
          cmodule: 'RM12',
          userup: 'adminbrg',
          tglup: 'adssadsafa',
          kcabang: "001");
    });
    widget.addNew(
        newProduct.tyunit, newProduct.harga, newProduct.jml, customerC.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("New Order"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Nama Customer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  decoration: const InputDecoration(labelText: "Nama Customer"),
                  controller: customerC,
                ),
              ),

              // Pilih Produk Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: screenWidth * 0.9, // 90% dari lebar layar
                  child: DropdownButtonFormField<String>(
                    value: namaProdukc,
                    decoration:
                        const InputDecoration(labelText: "Pilih Produk"),
                    items: produkMap.entries
                        .where((entry) =>
                            (entry.value['jml'] ?? 0) >
                            0) // Filter where 'jml' > 0
                        .map((entry) {
                      String nama = entry.key;
                      String displayName = nama.length > 30
                          ? '${nama.substring(0, 30)}...' // If more than 30 characters, truncate
                          : nama;

                      return DropdownMenuItem<String>(
                        value: nama,
                        child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        namaProdukc = newValue;

                        // Mendapatkan harga dari produkMap dengan menggunakan kunci 'namaProdukc'
                        if (namaProdukc != null) {
                          double harga =
                              produkMap[namaProdukc]?['hargaJual'] ?? 0.0;
                          hargaProdukc.text = harga.toString();
                        }
                      });
                    },
                  ),
                ),
              ),

              // Harga TextField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: screenWidth * 0.9, // 90% dari lebar layar
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Harga"),
                    controller: hargaProdukc,
                  ),
                ),
              ),

              // Qty TextField
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: screenWidth * 0.9, // 90% dari lebar layar
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Qty"),
                    controller: jumlahProdukc,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tombol Add
              Center(
                child: SizedBox(
                  width: screenWidth * 0.5, // 50% dari lebar layar
                  child: ElevatedButton(
                    onPressed: () {
                      saveNewOrder();
                      // db.createOrder(newProduct, qty);
                      handleTransfer();
                      addOrderToDataTable({
                        'NOBUKTI': produkMap['NOBUKTI'],
                        'tglpu': DateTime.now(),
                        'tyunit': namaProdukc,
                        'barcode': produkMap['Barcode'],
                        'jml': jumlahProdukc,
                        'harga': hargaProdukc,
                        'cmodule': 'RM12',
                        'userup': 'adminbrg'
                      });
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> addDataDaily(Stock product) async {
  //   try {
  //     MySqlConnection conn = await db.getConnection(); // Menyimpan koneksi

  //     String sql =
  //         "INSERT INTO unitkeldtl (NOBUKTI, tglpu, tyunit, barcode, jml, harga, cmodule, userup,tglup,kcabang) "
  //         "VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?)"
  //         "SELECT NOBUKTI "; // Menggunakan placeholder
  //     var queryResults = await conn.query(sql, [
  //       product.noBukti,
  //       product.tglpu,
  //       product.tyunit,
  //       product.barcode,
  //       product.jml,
  //       product.harga,
  //       product.cmodule,
  //       product.userup,
  //       product.tglup,
  //       product.kcabang
  //     ]);
  //     List<List<dynamic>> resultList = queryResults.toList();
  //     await conn.close(); // Menutup koneksi
  //     print(resultList);
  //   } catch (error) {
  //     print('Error adding product: $error');
  //     throw error; // Melempar kembali kesalahan untuk penanganan di atas
  //   }
  // }

  void addOrderToDataTable(Map<String, dynamic> order) {
    setState(() {
      data.add(order); // Menambahkan order baru ke dalam data
    });
  }

  Future<void> handleTransfer() async {
    try {
      String itemCode = namaProdukc!; // Nama produk yang dipilih
      String nobukti = produkMap[namaProdukc]?['NOBUKTI'] ??
          "000"; // Ambil NOBUKTI dari produkMap

      int? quantity = int.tryParse(jumlahProdukc.text) ?? 0;

      int transferred = await db.transferStock(itemCode, quantity, nobukti);

      print(['Transferred $transferred items', '$quantity']);
    } catch (e) {
      print('Error during transfer: $e');
    }
  }
}
