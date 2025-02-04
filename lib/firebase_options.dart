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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDW0ZWqO1Wl3Y_hJZE0hL4gjg_P-6_Y7hY',
    appId: '1:1068942039453:web:9424f0de9a29c226da7774',
    messagingSenderId: '1068942039453',
    projectId: 'lesson47',
    authDomain: 'lesson47.firebaseapp.com',
    storageBucket: 'lesson47.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAhn1rfl2QrNetS0zB1M2cC78Quf9-m67c',
    appId: '1:1068942039453:android:dcf15fb32b2bc28dda7774',
    messagingSenderId: '1068942039453',
    projectId: 'lesson47',
    storageBucket: 'lesson47.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3c4GdCKTGFYpJ3Zg_PBw8-bzDnNy460g',
    appId: '1:1068942039453:ios:50466e6acd17ef6dda7774',
    messagingSenderId: '1068942039453',
    projectId: 'lesson47',
    storageBucket: 'lesson47.appspot.com',
    iosBundleId: 'com.example.tadbiro',
  );
}
