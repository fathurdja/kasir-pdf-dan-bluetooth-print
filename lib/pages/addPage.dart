import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct(this.addNew);
  final Function addNew;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final List<String> namaProduk = [
    "Boneva Galon (isi)",
    "Boneva Galon + isi",
    "Boneva Gelas 220ml",
    "Boneva 600 ml",
    "Boneva 1,5 ml"
  ];
  String? namaProdukc; // Initialize as nullable
  final jumlahProdukc = TextEditingController();
  final hargaProdukc = TextEditingController();
  final customerC = TextEditingController();

  @override
  void dispose() {
    jumlahProdukc.dispose();
    hargaProdukc.dispose();
    customerC.dispose();
    super.dispose();
  }

  void saveNewOrder() {
    final namaProduk = namaProdukc;
    final jumlahProduk = int.tryParse(jumlahProdukc.text);
    final hargaProduk = hargaProdukc.text;
    final customer = customerC.text;
    if (namaProduk == null ||
        jumlahProduk == null ||
        jumlahProduk <= 0 ||
        hargaProduk.isEmpty ||
        customer.isEmpty) {
      return;
    }
    widget.addNew(
        namaProduk, double.parse(hargaProduk), jumlahProduk, customer);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("New Order"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: "Nama Customer"),
              controller: customerC,
            ),
            DropdownButtonFormField<String>(
              value: namaProdukc, // Set the dropdown value
              items: [
                DropdownMenuItem(
                  value: null, // Set the first item value to null
                  child: Text("Pilih Produk"),
                ),
                ...namaProduk.map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  namaProdukc = newValue; // Update the value
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Harga"),
              controller: hargaProdukc,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Qty"),
              controller: jumlahProdukc,
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: saveNewOrder,
              child: const Text(
                "add",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
