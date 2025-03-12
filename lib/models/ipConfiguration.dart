import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kasir_app/core.dart';
import 'package:kasir_app/models/mysql.dart';
import 'package:kasir_app/models/stock.dart';

class Ipconfiguration extends StatefulWidget {
  const Ipconfiguration({super.key});

  @override
  State<Ipconfiguration> createState() => _IpconfigurationState();
}

class _IpconfigurationState extends State<Ipconfiguration> {
  TextEditingController ipAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Stock> data;
    Mysql db = Mysql();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Kencana",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Center(
            child: Container(
                height: 300,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "IP DATABASE",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(),
                      child: TextFormField(
                        controller: ipAddress,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          labelText: 'Ip Address',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 249, 249, 250),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Mysql.updateHost(ipAddress.text);
                        data = await db.fetchDataFromDatabase();
                        print([Mysql.db, Mysql.host, Mysql.table]);
                        print(data);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      data: data,
                                    )));
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text("SET IP"),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
