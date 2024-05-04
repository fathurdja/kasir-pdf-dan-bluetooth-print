import 'package:flutter/material.dart';

Widget buildDataTable(List<Map<String, dynamic>> data) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columns: const [
        DataColumn(label: Text('NOBUKTI')),
        DataColumn(label: Text('tglpu')),
        DataColumn(label: Text('tyunit')),
        DataColumn(label: Text('barcode')),
        DataColumn(label: Text('jml')),
        DataColumn(label: Text('harga')),
        DataColumn(label: Text('cmodule')),
        DataColumn(label: Text('userup')),
      ],
      rows: data
          .map(
            (row) => DataRow(
              cells: [
                DataCell(Text(row['NOBUKTI'].toString())),
                DataCell(Text(row['tglpu'].toString())),
                DataCell(Text(row['tyunit'].toString())),
                DataCell(Text(row['barcode'].toString())),
                DataCell(Text(row['jml'].toString())),
                DataCell(Text(row['harga'].toString() == 'NULL'
                    ? '0.00'
                    : row['harga'].toString())),
                DataCell(Text(row['cmodule'].toString())),
                DataCell(Text(row['userup'].toString())),
              ],
            ),
          )
          .toList(),
    ),
  );
}
