class Cart {
  final String customer;
  final String namaProduk;
  final int qty;
  final double harga;
  final String nobukti;
  final String userup;
  final String tglup;
  final String tglpu;
  final String barcode;
  final String kacabang;
  final String module;

  Cart(
      {required this.harga,
      required this.qty,
      required this.namaProduk,
      required this.customer,
      required this.userup,
      required this.tglpu,
      required this.tglup,
      required this.kacabang,
      required this.barcode,
      required this.nobukti,
      required this.module});
}
