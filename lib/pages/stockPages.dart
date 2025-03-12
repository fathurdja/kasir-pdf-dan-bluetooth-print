import 'package:flutter/material.dart';
import 'package:kasir_app/models/stock.dart';


class StockListPage extends StatefulWidget {
  final List<Stock> stockList;

  StockListPage({required this.stockList});

  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock List'),
      ),
      body: widget.stockList.isEmpty
          ? Center(child: Text('No Stock Available'))
          : ListView.builder(
              itemCount: widget.stockList.length,
              itemBuilder: (context, index) {
                final stock = widget.stockList[index];
                return ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(stock.namaUnit ?? "N/A"),
                  subtitle: Text('Jumlah: ${stock.jml ?? 'N/A'}'),
                  trailing: Text("Harga: ${stock.hargaJual ?? 'N/A'}"),
                );
              },
            ),
    );
  }
}
