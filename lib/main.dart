import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import 'package:kasir_app/Product_page.dart';
import 'package:kasir_app/models/cart.dart';
import 'package:kasir_app/pages/addPage.dart';
import 'package:kasir_app/pages/homePage.dart';
import 'package:kasir_app/pages/invoice_page.dart';
import 'package:kasir_app/pages/wellcome_page.dart';
import 'package:kasir_app/print.dart';

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
        home: Home(),
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
  final List<Cart> _cart = [];
  @override
  Widget build(BuildContext context) {
    void _addNewItem(
        String namaProduk, double harga, int qty, String customer) {
      final newItem = Cart(
          harga: harga, qty: qty, namaProduk: namaProduk, customer: customer);
      setState(() {
        _cart.add(newItem);
      });
    }

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
        backgroundColor: Colors.red,
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
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text("Laporan Stock"),
                trailing: const Icon(Icons.arrow_right_sharp),
                onTap: () {},
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoicePage(_cart))),
                      child: const Text("Download Pdf")),
                  ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Print(carts: _cart))),
                      child: Text("Print Struk")),
                ],
              ),
              homePage,
              productPage,
            ],
          )),
    );
  }
}
