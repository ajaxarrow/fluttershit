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
    apiKey: 'AIzaSyAnV_p7UFNVIOtAkHXLlt8-hm1ftbxAqhw',
    appId: '1:698870059918:web:05515a495a9fbe0c854adf',
    messagingSenderId: '698870059918',
    projectId: 'filmfolio-e11b5',
    authDomain: 'filmfolio-e11b5.firebaseapp.com',
    storageBucket: 'filmfolio-e11b5.appspot.com',
    measurementId: 'G-QYVQLB6BDG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFbod76D2zkMSVsmzvXaW-OQ-ldc1ci2o',
    appId: '1:698870059918:android:a1e0055f0bc3d3b5854adf',
    messagingSenderId: '698870059918',
    projectId: 'filmfolio-e11b5',
    storageBucket: 'filmfolio-e11b5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA8eSF7f2Tvd4oyCg6MIYPYtRkb6Y52-oU',
    appId: '1:698870059918:ios:26eddfd08a6bf190854adf',
    messagingSenderId: '698870059918',
    projectId: 'filmfolio-e11b5',
    storageBucket: 'filmfolio-e11b5.appspot.com',
    iosBundleId: 'com.example.filmfoliov2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA8eSF7f2Tvd4oyCg6MIYPYtRkb6Y52-oU',
    appId: '1:698870059918:ios:617eb32bec9f8273854adf',
    messagingSenderId: '698870059918',
    projectId: 'filmfolio-e11b5',
    storageBucket: 'filmfolio-e11b5.appspot.com',
    iosBundleId: 'com.example.filmfoliov2.RunnerTests',
  );
}
