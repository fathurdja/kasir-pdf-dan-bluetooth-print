import 'package:flutter/material.dart';

Widget buildDataTable(List<List<dynamic>> data) {
  // Asumsikan baris pertama dari data berisi header
  final List headers = data.removeAt(0);

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: DataTable(
      columns:
          headers.map((header) => DataColumn(label: Text(header))).toList(),
      rows: data.map(
        (row) {
          // Pengecekan jumlah elemen dalam baris
          if (row.length != headers.length) {
            throw RangeError(
                'Invalid value: Expected ${headers.length} elements, but got ${row.length} elements in row: $row');
          }

          return DataRow(
            cells: row.asMap().entries.map((entry) {
              int idx = entry.key;
              dynamic value = entry.value;
              // Konversi kolom harga jika diperlukan
              if (headers[idx] == 'harga' && value.toString() == 'NULL') {
                value = '0.00';
              }
              return DataCell(Text(value.toString()));
            }).toList(),
          );
        },
      ).toList(),
    ),
  );
}
