import 'package:cucimobil_app/model/Log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cucimobil_app/controller/AuthController.dart';
import 'package:get/get.dart';

class LogController {
  final CollectionReference logsCollection =
      FirebaseFirestore.instance.collection('logs');
  final AuthController _authController = Get.find<AuthController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addLog(String activity) async {
    try {
      String userName = _authController.userName.value;

      await logsCollection.add({
        'activity': activity,
        'created_at': DateTime.now().toString(),
        'userName': userName,
      });
    } catch (e) {
      print('Failed to add log: $e');
      rethrow; // Re-throws the caught exception to maintain the stack trace.
    }
  }

  Stream<List<Log>> getLogsStream() {
    return logsCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Log.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<int> countLog() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('logs').get();
      return querySnapshot.size;
    } catch (e) {
      print('Error counting logs: $e');
      rethrow; // Re-throws the caught exception to maintain the stack trace.
    }
  }
}
