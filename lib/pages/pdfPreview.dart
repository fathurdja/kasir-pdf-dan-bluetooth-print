import 'package:flutter/material.dart';
import 'package:kasir_app/models/invoice.dart';
import 'package:kasir_app/models/pdfexport.dart';


import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final List<Invoice> invoice;
  const PdfPreviewPage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(invoice),
      ),
    );
  }
}
