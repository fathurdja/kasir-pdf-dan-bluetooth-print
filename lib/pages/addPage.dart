import 'package:flutter/material.dart';
import 'package:kasir_app/models/mysql.dart';
import 'package:kasir_app/models/product.dart';
import 'package:mysql1/mysql1.dart';

class AddProduct extends StatefulWidget {
  const AddProduct(this.addNew);
  final Function addNew;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<Map<String, dynamic>> data = [];
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
  int qty = 0;
  var db = Mysql();
  final List<String> namaProduk = [
    "Boneva Galon (isi)",
    "Boneva Galon + isi",
    "Boneva Gelas 220ml",
    "Boneva 600 ml",
    "Boneva 1.5 ml"
  ];
  String? namaProdukc; // Initialize as nullable
  final jumlahProdukc = TextEditingController();
  final hargaProdukc = TextEditingController();
  final customerC = TextEditingController();
  

  @override
  void dispose() {
    jumlahProdukc.dispose();
    hargaProdukc.dispose();
    customerC.dispose();
    super.dispose();
  }

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("New Order"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: "Nama Customer"),
              controller: customerC,
            ),
            DropdownButtonFormField<String>(
              value: namaProdukc, // Set the dropdown value
              items: [
                DropdownMenuItem(
                  value: null, // Set the first item value to null
                  child: Text("Pilih Produk"),
                ),
                ...namaProduk.map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  namaProdukc = newValue; // Update the value
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Harga"),
              controller: hargaProdukc,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Qty"),
              controller: jumlahProdukc,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                saveNewOrder();
                db.createOrder(newProduct, qty);
                addOrderToDataTable({
                  'NOBUKTI': noBukti,
                  'tglpu': DateTime.now(),
                  'tyunit': '$namaProduk',
                  'barcode': '',
                  'jml': jumlahProdukc,
                  'harga': hargaProdukc,
                  'cmodule': 'RM12',
                  'userup': 'adminbrg'
                });
              },
              child: const Text(
                "add",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addDataDaily(Product product) async {
    try {
      MySqlConnection conn = await db.getConnection(); // Menyimpan koneksi
      String orderNumber = Order.generateOrderNumber();
      String sql =
          "INSERT INTO unitpudtl (NOBUKTI, tglpu, tyunit, barcode, jml, harga, cmodule, userup,tglup,kcabang) "
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?)"; // Menggunakan placeholder
      var queryResults = await conn.query(sql, [
        orderNumber,
        product.tglpu,
        product.tyunit,
        product.barcode,
        product.jml,
        product.harga,
        product.cmodule,
        product.userup,
        product.tglup,
        product.kcabang
      ]);
      List<List<dynamic>> resultList = queryResults.toList();
      await conn.close(); // Menutup koneksi
      print(resultList);
      setState(() {
        noBukti = orderNumber;
      });
    } catch (error) {
      print('Error adding product: $error');
      throw error; // Melempar kembali kesalahan untuk penanganan di atas
    }
  }

  void addOrderToDataTable(Map<String, dynamic> order) {
    setState(() {
      data.add(order); // Menambahkan order baru ke dalam data
    });
  }
}
