
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:kasir_app/models/cart.dart';

// ignore: must_be_immutable
class Print extends StatefulWidget {
  List<Cart> carts;
  Print({super.key, required this.carts});

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  BluetoothDevice? _selectedDevice;
  String tips = 'no device connect';
  bool _connected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Printer Test"),
        ),
        body: RefreshIndicator(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(tips),
                      )
                    ],
                  ),
                  const Divider(),
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: bluetoothPrint.scanResults,
                    initialData: [],
                    builder: (c, snapshots) => Column(
                      children: snapshots.data!
                          .map((d) => ListTile(
                              title: Text(d.name ?? ''),
                              subtitle: Text(d.address ?? ''),
                              onTap: () async {
                                setState(() {
                                  _selectedDevice = d;
                                });
                              },
                              trailing: _selectedDevice != null &&
                                      _selectedDevice!.address == d.address
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null))
                          .toList(),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlinedButton(
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_selectedDevice != null &&
                                      _selectedDevice!.address != null) {
                                    setState(() {
                                      tips = "connecting...";
                                    });
                                    await bluetoothPrint
                                        .connect(_selectedDevice!);
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                    print('please select device');
                                  }
                                },
                          child: const Text("Connect"))
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = Map();
                              config['width'] = 40; // 标签宽度，单位mm
                              config['height'] = 70; // 标签高度，单位mm
                              config['gap'] = 2; // 标签间隔，单位mm

                              List<LineText> list = [];
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'PT.Kencana Cahaya Amanah',
                                  weight: 3,
                                  align: LineText.ALIGN_CENTER,
                                  fontZoom: 1,
                                  linefeed: 1));
                              list.add(LineText(linefeed: 1));

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      'jl.Kenangan No.183 Kel.Dulaluwo Timur ',
                                  align: LineText.ALIGN_CENTER,
                                  // absolutePos: 0,
                                  // relativePos: 0,
                                  linefeed: 1));

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'Kec Kota Tengah Kota Gorontalo',
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'Telp/WA 081244277777',
                                  align: LineText.ALIGN_CENTER,

                                  // absolutePos: 350,
                                  // relativePos: 0,
                                  linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              for (var cart in widget.carts) {
                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: "Nama Customer : ${cart.customer}",
                                    weight: 1,
                                    align: LineText.ALIGN_LEFT,
                                    linefeed: 1));
                                break;
                              }
                              for (var carts in widget.carts) {
                                double totalHarga = 0;
                                for (var cart in widget.carts) {
                                  list.add(LineText(
                                      type: LineText.TYPE_TEXT,
                                      content:
                                          '${cart.namaProduk} x ${cart.qty}',
                                      align: LineText.ALIGN_LEFT,
                                      // absolutePos: 500,
                                      // relativePos: 0,
                                      linefeed: 1));

                                  list.add(LineText(
                                      weight: 2,
                                      type: LineText.TYPE_TEXT,
                                      content:
                                          'Harga : Rp.${cart.harga.toStringAsFixed(0)}',
                                      align: LineText.ALIGN_LEFT,
                                      // absolutePos: 500,
                                      // relativePos: 0,
                                      linefeed: 1));

                                  totalHarga += cart.harga * cart.qty;
                                  carts = carts;
                                }

                                list.add(LineText(
                                    type: LineText.TYPE_TEXT,
                                    content:
                                        'Total : Rp.${totalHarga.toStringAsFixed(0)}',
                                    align: LineText.ALIGN_RIGHT,
                                    // absolutePos: 500,
                                    // relativePos: 0,
                                    linefeed: 1));

                                total += totalHarga;

                                break;
                              }
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content:
                                      '**********************************************',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));

                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'Total Price : Rp.$total',
                                  align: LineText.ALIGN_LEFT,
                                  weight: 3,

                                  // absolutePos: 0,
                                  // relativePos: 0,
                                  linefeed: 1));

                              list.add(LineText(linefeed: 1));

                              await bluetoothPrint.printReceipt(config, list);
                            }
                          : null,
                      child: const Text("Print Struk"))
                ],
              ),
            ),
            onRefresh: () => bluetoothPrint.startScan()),
        floatingActionButton: StreamBuilder<bool>(
            stream: bluetoothPrint.isScanning,
            initialData: false,
            builder: (c, snapshots) {
              if (snapshots.data == true) {
                return FloatingActionButton(
                  child: const Icon(Icons.stop),
                  onPressed: () => bluetoothPrint.stopScan(),
                  backgroundColor: Colors.red,
                );
              } else {
                return FloatingActionButton(
                    child: const Icon(Icons.search),
                    onPressed: () => bluetoothPrint.startScan(
                        timeout: const Duration(seconds: 4)));
              }
            }),
      ),
    );
  }
}
