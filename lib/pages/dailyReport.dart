import 'package:flutter/material.dart';
import 'package:kasir_app/models/product.dart';


class DailyReport extends StatefulWidget {
  DailyReport({super.key, required this.data});
  final List<Product> data;
  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Harian"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child:widget.data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Column(),
              ),
      ),
    );
  }
}
