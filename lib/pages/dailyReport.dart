import 'package:flutter/material.dart';
import 'package:kasir_app/models/mysql.dart';

class UnitKelDtlList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Penjualan'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: Mysql().getDataFromUnitKelDtl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          }

          // Data yang berhasil diambil
          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                title: Text(item['TYUNIT'] ?? 'No Barcode'),
                subtitle: Text('Jumlah: ${item['jml'] ?? 'N/A'}'),
                trailing: Text('Tanggal: ${item['tglup'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}
