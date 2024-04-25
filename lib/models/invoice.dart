class Invoice {
  final String customer;

  final List<LineItem> items;
  Invoice({required this.customer, required this.items});
  double totalCost() {
    return items.fold(
        0, (previousValue, element) => previousValue + element.harga);
  }
}

class LineItem {
  final int qty;
  final String namaProduk;
  final double harga;
  LineItem(this.qty, this.namaProduk, this.harga);
}
