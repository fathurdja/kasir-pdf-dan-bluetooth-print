import 'package:flutter/material.dart';
import 'package:kasir_app/models/product.dart';


class DailyReport extends StatefulWidget {
  const DailyReport({super.key, required this.data});
  final List<Product> data;
  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Harian"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child:widget.data.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Column(),
              ),
      ),
    );
  }
}
