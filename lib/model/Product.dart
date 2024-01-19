class ProductM {
  final String namaproduk;
  final double hargaproduk;
  final String createdat;
  final String updatedat;

  ProductM({
    required this.namaproduk,
    required this.hargaproduk,
    required this.createdat,
    required this.updatedat,
    String? id,
  });

  String? get id => null;

  Map<String, dynamic> toMap() {
    return {
      'namaproduk': namaproduk,
      'hargaproduk': hargaproduk,
      'createdat': createdat,
      'updatedat': updatedat,
    };
  }
}
