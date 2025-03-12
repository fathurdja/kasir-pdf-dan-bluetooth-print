import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kasir_app/models/ipConfiguration.dart';

import 'package:kasir_app/models/stock.dart';
import 'package:kasir_app/pages/Product_page.dart';
import 'package:kasir_app/models/product.dart';
import 'package:kasir_app/pages/addPage.dart';

import 'package:kasir_app/pages/dailyReport.dart';
import 'package:kasir_app/pages/homePage.dart';
import 'package:kasir_app/pages/invoice_page.dart';
import 'package:kasir_app/pages/stockPages.dart';

import 'package:kasir_app/models/cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({super.key, required this.data});
  List<Stock> data;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String orderNumber = Order.generateOrderNumber();
  final List<Cart> _cart = [];
  late List<Stock> data = [];

  @override
  Widget build(BuildContext context) {
    data = widget.data;
    saveDataToLocal(data);
    print(data);
    // fungsi menambah orderan

    // fungsi mereset orderan jadi ksong
    void _resetCart() {
      setState(() {
        _cart.clear();
      });
    }

    final homePage = HomePage(_cart);
    final productPage = ProductPage(_cart);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: fetchDatandOrder,
        child: const Icon(
          Icons.add_shopping_cart_outlined,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C5B6F),
        title: const Text("ORDER"),
        actions: <Widget>[
          TextButton(
              onPressed: () => _resetCart(),
              child: const Icon(
                Icons.repeat,
                color: Colors.black,
              ))
        ],
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.home_filled),
                title: const Text("SET IP DATABASE"),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Ipconfiguration()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.stacked_bar_chart),
                title: const Text("Laporan Harian"),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UnitKelDtlList()));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: const Text("Laporan Stock"),
                  trailing: const Icon(Icons.arrow_right_sharp),
                  onTap: () async {
                    await fetchDataAndNavigate(context);
                  })
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C5B6F),
                          shape: LinearBorder.start()),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoicePage(_cart))),
                      child: const Text(
                        "Download Pdf",
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C5B6F),
                          shape: LinearBorder.start()),
                      onPressed: () {
                        // generateCSV(data);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Print(carts: _cart)));
                      },
                      child: const Text(
                        "Print Struk",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              homePage,
              productPage,
            ],
          )),
    );
  }

// fungsi membuat file csv dan disimpan dalam downloads

  // Generate CSV

  // Get directory path for saving file

  String getDateOnly(String dateTimeString) {
    // Ubah string ke objek DateTime
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format tanggal ke dalam bentuk "yyyy-MM-dd"
    String formattedDate =
        "${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)}";

    return formattedDate;
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  Future<void> fetchDataAndNavigate(BuildContext context) async {
    List<Stock> stockList =
        await getDataFromLocal(); // Fetch data using getData()
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            semanticsLabel: "loading fetch Data",
          ),
        );
      },
    );
    await Future.delayed(Duration(seconds: 2));
    // Navigate to StockListPage and pass the stockList
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return StockListPage(stockList: stockList);
      }),
    );
    Navigator.of(context).pop();
  }

  Future<void> fetchDatandOrder() async {
    List<Stock> stockList =
        await getDataFromLocal(); // Fetch data using getData()
    void _addNewItem(
        String namaProduk, double harga, int qty, String customer) {
      final newItem = Cart(
          harga: harga,
          qty: qty,
          namaProduk: namaProduk,
          customer: customer,
          userup: "adminbrg",
          tglpu: DateTime.now().toString(),
          tglup: DateTime.now().toString(),
          barcode: '',
          kacabang: 'cabang1',
          nobukti: orderNumber,
          module: 'RM12');

      final newdata = Stock(
          noBukti: orderNumber,
          tglpu: DateTime.now(),
          tyunit: namaProduk,
          barcode: '',
          jml: qty,
          harga: harga,
          cmodule: 'RM12',
          userup: 'adminbrg',
          tglup: DateTime.now().toString(),
          kcabang: 'Cabang 1');
      setState(() {
        _cart.add(newItem);
        data.add(newdata);
      });
    }

    // Navigate to StockListPage and pass the stockList
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return AddProduct(addNew: _addNewItem, stockList: stockList);
      }),
    );
  }

  Future<void> saveDataToLocal(List<Stock> data) async {
    final prefs = await SharedPreferences.getInstance();
    // Konversi List<Stock> menjadi List<Map<String, dynamic>>
    List<String> dataString =
        data.map((stock) => jsonEncode(stock.toJson())).toList();
    await prefs.setStringList('sqlData', dataString);
  }

  Future<List<Stock>> getDataFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? dataStringList = prefs.getStringList('sqlData');

    if (dataStringList != null) {
      // Konversi kembali dari JSON ke List<Stock>
      return dataStringList
          .map((dataString) => Stock.fromJson(jsonDecode(dataString)))
          .toList();
    } else {
      return [];
    }
  }
}
