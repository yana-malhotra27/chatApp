//github cli
//git rm --cached lib/firebase_options.dart

// git add .gitignore
// git commit -m "Add firebase_options.dart to .gitignore"

//git push

//------------------------


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
    apiKey: 'AIzaSyCBR5gthShpentscm-Nmbtqtw8JOuH_XbU',
    appId: '1:156084123351:web:a86cf0d1524ec0e352e292',
    messagingSenderId: '156084123351',
    projectId: 'chatapp-f64ae',
    authDomain: 'chatapp-f64ae.firebaseapp.com',
    storageBucket: 'chatapp-f64ae.firebasestorage.app',
    measurementId: 'G-L9XQCQNE3J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxoPombsC_ezczHMRUdF7qO1EoQX90VK0',
    appId: '1:156084123351:android:73370472fb7573e052e292',
    messagingSenderId: '156084123351',
    projectId: 'chatapp-f64ae',
    storageBucket: 'chatapp-f64ae.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCC1SyPyP2PwKG8hClV-XQsGRuZmrnOfj8',
    appId: '1:156084123351:ios:92da59a120008ea652e292',
    messagingSenderId: '156084123351',
    projectId: 'chatapp-f64ae',
    storageBucket: 'chatapp-f64ae.firebasestorage.app',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCC1SyPyP2PwKG8hClV-XQsGRuZmrnOfj8',
    appId: '1:156084123351:ios:92da59a120008ea652e292',
    messagingSenderId: '156084123351',
    projectId: 'chatapp-f64ae',
    storageBucket: 'chatapp-f64ae.firebasestorage.app',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCBR5gthShpentscm-Nmbtqtw8JOuH_XbU',
    appId: '1:156084123351:web:df3b45822ba6e11b52e292',
    messagingSenderId: '156084123351',
    projectId: 'chatapp-f64ae',
    authDomain: 'chatapp-f64ae.firebaseapp.com',
    storageBucket: 'chatapp-f64ae.firebasestorage.app',
    measurementId: 'G-HSMNMWGW85',
  );
}
