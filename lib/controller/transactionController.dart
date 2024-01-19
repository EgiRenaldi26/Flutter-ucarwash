import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/model/Transaction.dart';
import 'package:get/get.dart';

class TransaksiController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<TransactionsM> transaksiList = <TransactionsM>[].obs;
  RxBool shouldUpdate = false.obs;

  Future<bool> addTransaksi(TransactionsM transactions) async {
    try {
      await _firestore.collection('transactions').add(transactions.toMap());
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding transaction: $e');
      return false;
    }
  }

  void clearTransaksiList() {
    transaksiList.clear();
  }

  Future<bool> deleteTransaksi(String id) async {
    try {
      await _firestore.collection('transactions').doc(id).delete();
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting transaction: $e');
      return false;
    }
  }

  Future<bool> updateTransaksi(
      String id,
      String namapelanggan,
      String namaproduk,
      double hargaproduk,
      int qty,
      double uangbayar,
      double totalbelanja,
      double uangkembali,
      String updated_at) async {
    try {
      await _firestore.collection('transactions').doc(id).update({
        'namapelanggan': namapelanggan,
        'namaproduk': namaproduk,
        'hargaproduk': hargaproduk,
        'qty': qty,
        'uangbayar': uangbayar,
        'totalbelanja': totalbelanja,
        'uangkembali': uangkembali,
        'updated_at': updated_at,
      });
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error updating transaction: $e');
      return false;
    }
  }

  Future<int> countTransactions() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting books: $e');
      return 0;
    }
  }
}
