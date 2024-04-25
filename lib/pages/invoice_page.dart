import 'package:flutter/material.dart';

import 'package:kasir_app/models/cart.dart';
import 'package:kasir_app/models/invoice.dart';
import 'package:kasir_app/pages/pdfPreview.dart';

class InvoicePage extends StatelessWidget {
  final List<Cart> items;

  InvoicePage(this.items);

  @override
  Widget build(BuildContext context) {
    // Buat objek Invoice dari daftar item Cart
    List<Invoice> invoices = items.map((cartItem) {
      // Anda dapat menyesuaikan logika ini sesuai dengan struktur Cart dan Invoice Anda
      return Invoice(
        customer: cartItem.customer, // Misalnya, ambil nama pelanggan dari Cart
        items: [
          LineItem(cartItem.qty, cartItem.namaProduk, cartItem.harga)
        ], // Ambil jumlah item dari Cart
        // Hitung total harga dari Cart
      );
    }).toList();

    // Gunakan objek Invoice yang sudah dibuat untuk membuat UI invoice
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          Invoice invoice = invoices[index];
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: invoice.items.length,
                    itemBuilder: (context, itemIndex) {
                      LineItem lineItem = invoice.items[itemIndex];
                      return ListTile(
                        title: Text("${lineItem.namaProduk}"),
                        subtitle: Text("${lineItem.harga}"),
                        trailing: Text("${lineItem.qty}"),
                      );
                    })
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PdfPreviewPage(invoice: invoices)));
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
