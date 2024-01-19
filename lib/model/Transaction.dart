class TransactionsM {
  final int nomorunik;
  final String namapelanggan;
  final String namaproduk;
  final double hargaproduk;
  final int qty;
  final double uangbayar;
  final double totalbelanja;
  final double uangkembali;
  final String created_at;
  final String updated_at;

  TransactionsM({
    required this.nomorunik,
    required this.namapelanggan,
    required this.namaproduk,
    required this.hargaproduk,
    required this.qty,
    required this.uangbayar,
    required this.totalbelanja,
    required this.uangkembali,
    required this.created_at,
    required this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return {
      'nomorunik': nomorunik,
      'namapelanggan': namapelanggan,
      'namaproduk': namaproduk,
      'hargaproduk': hargaproduk,
      'qty': qty,
      'uangbayar': uangbayar,
      'totalbelanja': totalbelanja,
      'uangkembali': uangkembali,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
