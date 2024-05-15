import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kasir_app/models/dataTable.dart';

class UploadCsv extends StatefulWidget {
  const UploadCsv({super.key});

  @override
  State<UploadCsv> createState() => _UploadCsvState();
}

class _UploadCsvState extends State<UploadCsv> {
  List<List<dynamic>> _data = [];
  String? filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laporan Stock"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_data.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildDataTable(_data),
            ),
          if (_data.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Silahkan Upload data CSV"),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _pickFile();
                      },
                      child: Text("upload File CSV"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;
    // we will log the name, size and path of the
    // first picked file (if multiple are selected)
    print(result.files.first.name);
    filePath = result.files.first.path!;

    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(fields);

    setState(() {
      _data = fields;
    });
  }
}
