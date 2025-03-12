import 'package:flutter/material.dart';

import 'package:kasir_app/models/cart.dart';

class ProductPage extends StatelessWidget {
  final List<Cart> carts;
  ProductPage(this.carts);

  @override
  Widget build(BuildContext context) {
    print(carts);
    return Container(
      height: 1000,
      child: carts.isEmpty
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No Orders",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                double totalHarga = carts[index].harga * carts[index].qty;
                return Card(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              carts[index].qty.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "" +
                                    carts[index].namaProduk.substring(0, 20) +
                                    "",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Price : " +
                                    carts[index].harga.toStringAsFixed(0),
                              ),
                              Text(
                                  "Total : IDR" + totalHarga.toStringAsFixed(0))
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
              itemCount: carts.length,
            ),
    );
  }
}
