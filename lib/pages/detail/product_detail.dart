import 'package:cucimobil_app/controller/logController.dart';
import 'package:cucimobil_app/controller/productController.dart';
import 'package:cucimobil_app/pages/theme/coloring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetail extends StatelessWidget {
  final ProductController _productController = Get.put(ProductController());
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final LogController logController = LogController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = Get.arguments;
    final String id = args?['id'] ?? '';
    final String namaproduk = args?['namaproduk'] ?? '';
    final double hargaproduk = args?['hargaproduk'] ?? 0.0;

    productNameController.text = namaproduk;
    productPriceController.text = hargaproduk.toStringAsFixed(0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: warna.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        title: Center(
          child: Text(
            "Form Produk",
            style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: productNameController,
              decoration: InputDecoration(
                hintText: 'Exm. Cuci VIP',
                label: Text(
                  'Nama Produk',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: productPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Exm. Rp.10.000',
                label: Text(
                  'Harga Produk',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String namaproduk = productNameController.text.trim();
                  double hargaproduk =
                      double.tryParse(productPriceController.text.trim()) ??
                          0.0;
                  String updated_at = DateTime.now().toString();
                  if (namaproduk.isNotEmpty && hargaproduk > 0) {
                    await _productController.updateProducts(
                      id,
                      productNameController.text,
                      double.parse(productPriceController.text),
                      updated_at,
                    );

                    _productController.shouldUpdate.value = true;
                    Get.back();

                    Get.snackbar('Success', 'Produk updated successfully!');
                    _addLog("Success update with title: $namaproduk");
                  } else {
                    Get.snackbar('Failed',
                        'Gagal memperbarui Produk, silakan periksa kembali form.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: warna.ungu, // Set background color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    // Set border radius to 25%
                  ),
                  minimumSize:
                      Size(double.infinity, 50.0), // Set the height to 50.0
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white, // Set text color to white
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  bool success = await _productController.deleteProducts(id);
                  if (success) {
                    Get.back();
                    _addLog("Deleted produk with title: $namaproduk");
                    Get.snackbar('Success', 'Produk deleted successfully!');
                  } else {
                    Get.snackbar('Failed', 'Failed to delete Produk');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(
                      255, 255, 255, 255), // Set background color to orange
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(
                      color: warna.ungu, // Set border color
                      width: 2.0, // Set border width
                    ),
                    // Set border radius to 25%
                  ),
                  minimumSize:
                      Size(double.infinity, 50.0), // Set the height to 50.0
                ),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: warna.ungu, // Set text color to white
                  ),
                ),
              ),
            ),
            // Tambahkan tombol aksi di sini
          ],
        ),
      ),
    );
  }

  Future<void> _addLog(String activity) async {
    try {
      await logController.addLog(activity);
      print('Log added successfully!');
    } catch (e) {
      print('Failed to add log: $e');
    }
  }
}
