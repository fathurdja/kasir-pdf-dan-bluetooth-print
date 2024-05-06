// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kasir_app/models/cart.dart';


class HomePage extends StatelessWidget {
  final List<Cart> _listcart;
  const HomePage(this._listcart, {super.key});

  int get totalItem {
    return _listcart.fold(0, (sum, item) {
      return sum += item.qty;
    });
  }

  double get totalPrice {
    return _listcart.fold(0, (sum, item) {
      double totalharga = item.qty * item.harga;
      return sum += totalharga;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: [
                const Text(
                  "total orders: ",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  totalItem.toString(),
                  style: const TextStyle(fontSize: 15),
                )
              ],
            ),
            Row(
              children: [
                const Text(
                  "total Price:",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "IDR. " + totalPrice.toStringAsFixed(0),
                  style: const TextStyle(fontSize: 15),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
