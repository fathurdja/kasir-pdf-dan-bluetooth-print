class Stock {
  String? noBukti;
  DateTime? tglpu;
  String? tyunit;
  String? barcode;
  int? jml;
  double? harga;
  String? cmodule;
  String? userup;
  String? tglup;
  String? kcabang;
  String? namaUnit; // From munit
  double? hargaJual; // From munit

  Stock({
    this.noBukti,
    this.tglpu,
    this.tyunit,
    this.barcode,
    this.jml,
    this.harga,
    this.cmodule,
    this.kcabang,
    this.tglup,
    this.userup,
    this.namaUnit, // From munit
    this.hargaJual, // From munit
  });

  // Factory method to create Stock object from a map
  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      noBukti: map['NOBUKTI'],
      tglpu: map['tglpu'] != null ? DateTime.tryParse(map['tglpu']) : null,
      tyunit: map['tyunit'],
      barcode: map['barcode'],
      jml: map['jml'],
      harga: map['harga'],
      cmodule: map['cmodule'],
      kcabang: map['kcabang'],
      tglup: map['tglup'],
      userup: map['userup'],
      namaUnit: map['NTYUNIT'], // From munit
      hargaJual: map['hjual'],
    );
  }

  // Method to convert Stock object into a map (for saving as JSON)
  Map<String, dynamic> toJson() {
    return {
      'NOBUKTI': noBukti,
      'tglpu': tglpu?.toIso8601String(), // Format DateTime ke string
      'tyunit': tyunit,
      'barcode': barcode,
      'jml': jml,
      'harga': harga,
      'cmodule': cmodule,
      'kcabang': kcabang,
      'tglup': tglup,
      'userup': userup,
      'NTYUNIT': namaUnit, // From munit
      'hjual': hargaJual, // From munit
    };
  }

  // Method to get namaUnit and hargaJual as a List<String>
  List<String> getItemDetails() {
    return [namaUnit ?? "No Name", hargaJual?.toString() ?? "No Price"];
  }

  // Factory method to create Stock object from JSON
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      noBukti: json['NOBUKTI'],
      tglpu: json['tglpu'] != null ? DateTime.tryParse(json['tglpu']) : null,
      tyunit: json['tyunit'],
      barcode: json['barcode'],
      jml: json['jml'],
      harga: json['harga'],
      cmodule: json['cmodule'],
      kcabang: json['kcabang'],
      tglup: json['tglup'],
      userup: json['userup'],
      namaUnit: json['NTYUNIT'], // From munit
      hargaJual: json['hjual'],
    );
  }
}
