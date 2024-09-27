import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:kasir_app/models/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart'; // Import paket intl untuk formatting angka

Future<Uint8List> makePdf(List<Invoice> invoices) async {
  String? _logo;
  final pdf = pw.Document();
  double total = 0;
  _logo = await rootBundle.loadString('assets/images/logo.svg');
  // final double page = 75 * 66 * 12;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.standard,
      build: (
        pw.Context context,
      ) {
        List<pw.Widget> content = [];
        content.add(pw.Column(children: [
          pw.SizedBox(height: 15),
          pw.Center(child: pw.Text("Kencana Cahaya Amanah")),
          pw.Center(child: pw.Text("JL. Kenangan No. 183 Kel.Dulaluwo Timur")),
          pw.Center(
              child: pw.Text(
                  "kec. kota tengah kota Gorontalo telp/WA 081244277777"))
        ]));
        // Tambahkan nama pelanggan
        for (var invoice in invoices) {
          content.add(pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Column(children: [
                pw.SizedBox(height: 20),
                pw.Text(
                  'Pelanggan: ${invoice.customer}',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 10),
                ),
              ])));

          break;
        }

        for (var invoice in invoices) {
          double totalInvoice = 0;
          for (var item in invoice.items) {
            // Menambahkan item-item pembelian
            content.add(
              pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 5, horizontal: 20),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Barang: ${item.namaProduk} ',
                            style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('Jumlah: ${item.qty}',
                            style: const pw.TextStyle(fontSize: 10)),
                        pw.Text(
                            'Harga: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(item.harga)}',
                            style: const pw.TextStyle(
                                fontSize:
                                    10)), // Mengubah format harga menjadi uang rupiah
                        pw.SizedBox(height: 5), // Spasi antara setiap
                      ])),
            );

            // Menambahkan total harga untuk setiap item ke total invoice
            totalInvoice += item.harga * item.qty;
          }
          // Menampilkan total invoice untuk setiap invoice
          content.add(pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10, right: 10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('SubTotal :'),
                  pw.Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(totalInvoice)}', // Mengubah format total invoice menjadi uang rupiah
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              )));

          // Menambahkan total invoice ke total keseluruhan
          total += totalInvoice;
        }
        content.add(pw.Divider());
        // Menampilkan total keseluruhan
        content.add(pw.Padding(
            padding: const pw.EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Total :'),
                pw.SizedBox(width: 50),
                pw.Text(
                    '${NumberFormat.currency(locale: 'id', symbol: 'Rp.').format(total)}', // Mengubah format total keseluruhan menjadi uang rupiah
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            )));
        content.add(pw.Divider());

        content.add(pw.Column(mainAxisSize: pw.MainAxisSize.min, children: [
          pw.SizedBox(height: 10),
          pw.Container(
            alignment: pw.Alignment.topRight,
            padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
            height: 72,
            child: _logo != null ? pw.SvgImage(svg: _logo) : pw.PdfLogo(),
          ),
        ]));
        // Mengembalikan list dari list widget, sesuai dengan struktur yang diperlukan oleh MultiPage
        return content;
      },
    ),
  );

  // Mengembalikan PDF yang sudah dibuat
  return pdf.save();
}
