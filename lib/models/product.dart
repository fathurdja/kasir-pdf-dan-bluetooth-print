class Product {
  final String noBukti;
  final String tglpu;
  final String? tyunit;
  final String barcode;
  final int jml;
  final double harga;
  final String cmodule;
  final String userup;

  Product({
    required this.noBukti,
    required this.tglpu,
    required this.tyunit,
    required this.barcode,
    required this.jml,
    required this.harga,
    required this.cmodule,
    required this.userup,
  });
}

class Order {
  static int _lastOrderNumber = 0;

  static String generateOrderNumber() {
    _lastOrderNumber++;
    return 'PU${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-0000$_lastOrderNumber';
  }
}