import 'package:cucimobil_app/model/Product.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool shouldUpdate = false.obs;

  get products => null;

  Future<bool> addProduct(ProductM products) async {
    try {
      await _firestore.collection('products').add(products.toMap());
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error adding products');
      return false;
    }
  }

  Future<bool> deleteProducts(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      shouldUpdate.toggle();
      return true;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }

  Future<bool> updateProducts(String id, String namaProduk, double hargaProduk,
      String updated_at) async {
    try {
      await _firestore.collection('products').doc(id).update({
        'namaproduk': namaProduk,
        'hargaproduk': hargaProduk,
        'updated_at': updated_at,
      });
      return true;
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }

  Future<int> countProducts() async {
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
