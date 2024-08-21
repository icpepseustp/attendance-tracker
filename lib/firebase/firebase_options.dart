// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyCdUZg-MVaxrROm3r1M1DCYsmEjOQ82e0o',
    appId: '1:426353485042:web:20ec158401b4f7f5f45c6b',
    messagingSenderId: '426353485042',
    projectId: 'attendance-tracker-icpep',
    authDomain: 'attendance-tracker-icpep.firebaseapp.com',
    databaseURL: 'https://attendance-tracker-icpep-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'attendance-tracker-icpep.appspot.com',
    measurementId: 'G-866T3HYEEM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDItTIXDqXQ-RBy_Ol4fg3MStLPyHn87C4',
    appId: '1:426353485042:android:3a45909c5045bc67f45c6b',
    messagingSenderId: '426353485042',
    projectId: 'attendance-tracker-icpep',
    databaseURL: 'https://attendance-tracker-icpep-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'attendance-tracker-icpep.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDTHmFHjnGT9Qhwn2ZGvQCbmOKtSoHLbzM',
    appId: '1:426353485042:ios:270588eb99f5134ff45c6b',
    messagingSenderId: '426353485042',
    projectId: 'attendance-tracker-icpep',
    databaseURL: 'https://attendance-tracker-icpep-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'attendance-tracker-icpep.appspot.com',
    iosBundleId: 'com.example.attendanceTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDTHmFHjnGT9Qhwn2ZGvQCbmOKtSoHLbzM',
    appId: '1:426353485042:ios:270588eb99f5134ff45c6b',
    messagingSenderId: '426353485042',
    projectId: 'attendance-tracker-icpep',
    storageBucket: 'attendance-tracker-icpep.appspot.com',
    iosBundleId: 'com.example.attendanceTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCdUZg-MVaxrROm3r1M1DCYsmEjOQ82e0o',
    appId: '1:426353485042:web:cdd53598971161baf45c6b',
    messagingSenderId: '426353485042',
    projectId: 'attendance-tracker-icpep',
    authDomain: 'attendance-tracker-icpep.firebaseapp.com',
    storageBucket: 'attendance-tracker-icpep.appspot.com',
    measurementId: 'G-RLJEDDQZL2',
  );
}
