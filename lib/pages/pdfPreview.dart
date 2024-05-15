import 'package:flutter/material.dart';
import 'package:kasir_app/models/invoice.dart';
import 'package:kasir_app/services/pdfexport.dart';


import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final List<Invoice> invoice;
  const PdfPreviewPage({super.key, required this.invoice});

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
