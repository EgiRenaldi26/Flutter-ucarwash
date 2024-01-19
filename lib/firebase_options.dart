// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB5-BLUpu343Yj9pimXMyfT473vc9vtdOs',
    appId: '1:128850358715:web:b991ccf18881e87130549e',
    messagingSenderId: '128850358715',
    projectId: 'cucimobil-app',
    authDomain: 'cucimobil-app.firebaseapp.com',
    storageBucket: 'cucimobil-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFFIpxytz1wDOTVy4Glxqb4z7WF0SwN2M',
    appId: '1:128850358715:android:861576b5f9fff68330549e',
    messagingSenderId: '128850358715',
    projectId: 'cucimobil-app',
    storageBucket: 'cucimobil-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJkdbo0E85n9FsVwFQtbhEZnpJRuKgNj4',
    appId: '1:128850358715:ios:f74a971c5580a64730549e',
    messagingSenderId: '128850358715',
    projectId: 'cucimobil-app',
    storageBucket: 'cucimobil-app.appspot.com',
    iosBundleId: 'com.example.cucimobilApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJkdbo0E85n9FsVwFQtbhEZnpJRuKgNj4',
    appId: '1:128850358715:ios:5795abbc8330454b30549e',
    messagingSenderId: '128850358715',
    projectId: 'cucimobil-app',
    storageBucket: 'cucimobil-app.appspot.com',
    iosBundleId: 'com.example.cucimobilApp.RunnerTests',
  );
}
