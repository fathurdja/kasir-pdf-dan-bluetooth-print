import 'package:flutter/material.dart';
import 'package:kasir_app/models/mysql.dart';
import 'models/dataTable.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Stockpage extends StatefulWidget {
  const Stockpage({Key? key}) : super(key: key);

  @override
  State<Stockpage> createState() => _StockpageState();
}

class _StockpageState extends State<Stockpage> {
  var db = Mysql();
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _getdb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Stock"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: _data.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: buildDataTable(_data),
              ),
      ),
    );
  }

  // Fungsi untuk mengubah data menjadi format CSV
  String convertToCSV(List<Map<String, dynamic>> data) {
    // Header CSV
    String csv = 'NOBUKTI,tglpu,tyunit,barcode,jml,harga,cmodule,userup\n';

    // Data CSV
    for (var row in data) {
      csv +=
          '${row['NOBUKTI']},${row['tglpu']},${row['tyunit']},${row['barcode']},${row['jml']},${row['harga']},${row['cmodule']},${row['userup']}\n';
    }

    return csv;
  }

// Fungsi untuk menyimpan data CSV ke dalam file lokal
  Future<void> saveCSV(String csv) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.csv');
      await file.writeAsString(csv);
      print('File CSV berhasil disimpan di: ${file.path}');
    } catch (error) {
      print('Error saving CSV file: $error');
    }
  }
// fungsi membaca file csv
  Future<List<Map<String, dynamic>>> _readCSV() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/data.csv');
      String csvData = await file.readAsString();

      // Membaca data CSV dan mengonversinya ke dalam List<Map<String, dynamic>>
      List<Map<String, dynamic>> dataList = [];
      List<String> lines = csvData.split('\n');
      List<String> headers = lines[0].split(',');
      for (int i = 1; i < lines.length; i++) {
        List<String> values = lines[i].split(',');
        Map<String, dynamic> dataMap = {};
        for (int j = 0; j < headers.length; j++) {
          dataMap[headers[j]] = values[j];
        }
        dataList.add(dataMap);
      }

      return dataList;
    } catch (error) {
      print('Error reading CSV file: $error');
      return [];
    }
  }
// fungsi mengkoneksikan ke database
  void _getdb() async {
    try {
      List<List<dynamic>> results = await db.getConnection().then((conn) async {
        String sql = 'select * from unitpudtl;';
        var queryResults = await conn.query(sql);
        List<List<dynamic>> resultList = queryResults.toList();
        conn.close();
        String csv = convertToCSV(_processData(resultList));

        // Menyimpan data CSV ke dalam file lokal
        await saveCSV(csv);

        return resultList;
      });
      setState(() {
        _data = _processData(results);
      });
      List<Map<String, dynamic>> csvData = await _readCSV();
      setState(() {
        _data = csvData;
      });
    } catch (error) {
      print(error); // Log the error for debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching data: $error'),
        ),
      );
    }
  }
// fungsi memasukkan data ke dalam list datatable
  List<Map<String, dynamic>> _processData(List<List<dynamic>> results) {
    List<Map<String, dynamic>> data = [];
    for (var row in results) {
      data.add({
        'NOBUKTI': row[0],
        'tglpu': row[1],
        'tyunit': row[2],
        'barcode': row[3],
        'jml': row[4],
        'harga': row[5],
        'cmodule': row[6],
        'userup': row[7],
      });
    }
    return data;
  }
}
