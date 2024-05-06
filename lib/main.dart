import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:kasir_app/Product_page.dart';
import 'package:kasir_app/models/cart.dart';
import 'package:kasir_app/models/product.dart';
import 'package:kasir_app/pages/addPage.dart';
import 'package:kasir_app/pages/dailyReport.dart';
import 'package:kasir_app/pages/homePage.dart';
import 'package:kasir_app/pages/invoice_page.dart';
import 'package:kasir_app/print.dart';
import 'package:kasir_app/stockReport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Kasir",
        home: const Home(),
        // home: WellcomePage(),
        routes: <String, WidgetBuilder>{
          "page1": (BuildContext context) => new Home(),
        },
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String orderNumber = Order.generateOrderNumber();
  final List<Cart> _cart = [];
  final List<Product> data = [];
  @override
  Widget build(BuildContext context) {
    // fungsi menambah orderan
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

      final newdata = Product(
          noBukti: orderNumber,
          tglpu: DateTime.now().toString(),
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

    // fungsi mereset orderan jadi ksong
    void _resetCart() {
      setState(() {
        _cart.clear();
      });
    }

    void openOrder(BuildContext context) {
      showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return AddProduct(_addNewItem);
          });
    }

    final homePage = HomePage(_cart);
    final productPage = ProductPage(_cart);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => openOrder(context),
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
                leading: const Icon(Icons.stacked_bar_chart),
                title: const Text("Laporan Harian"),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DailyReport(data: data)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text("Laporan Stock"),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Stockpage()));
                },
              )
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
                        generateCSV(data);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Print(carts: _cart)));
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
  void generateCSV(List<Product> data) async {
    List<List<dynamic>> rows = [];
    // Add header row
    List<dynamic> header = [
      'NOBUKTI',
      'tglpu',
      'tyunit',
      'barcode',
      'jml',
      'harga',
      'cmodule',
      'userup',
      'kcabang',
    ];
    rows.add(header);

    // Add data rows
    data.forEach((cart) {
      List<dynamic> dataRow = [
        cart.noBukti,
        cart.tglpu,
        cart.tyunit,
        cart.barcode,
        cart.jml,
        cart.harga,
        cart.cmodule,
        cart.userup,
        cart.kcabang
      ];
      rows.add(dataRow);
    });

    // Generate CSV
    String csv = const ListToCsvConverter().convert(rows);

    // Get directory path for saving file
    String downloadsPath = await AndroidPathProvider.downloadsPath;

    // Get current date for file name
    String date = DateTime.now().toString();
    String formattedDate = getDateOnly(date);

    // Create file with formatted date as file name
    File file = File('$downloadsPath/data_$formattedDate.csv');

    // Write CSV data to file
    await file.writeAsString(csv);

    print('CSV file created at: ${file.path}');
  }

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
}
