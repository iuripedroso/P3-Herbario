import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDiClRxdVx8i70NUGXcq18DWdOoJtLqXbY',
    appId: '1:307128876874:web:herbario123456789',
    messagingSenderId: '307128876874',
    projectId: 'herbario-d1ace',
    authDomain: 'herbario-d1ace.firebaseapp.com',
    databaseURL: 'https://herbario-d1ace.firebaseio.com',
    storageBucket: 'herbario-d1ace.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiClRxdVx8i70NUGXcq18DWdOoJtLqXbY',
    appId: '1:307128876874:android:95734bcb946c67ab52cbb3',
    messagingSenderId: '307128876874',
    projectId: 'herbario-d1ace',
    storageBucket: 'herbario-d1ace.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDiClRxdVx8i70NUGXcq18DWdOoJtLqXbY',
    appId: '1:307128876874:ios:herbario123456789',
    messagingSenderId: '307128876874',
    projectId: 'herbario-d1ace',
    storageBucket: 'herbario-d1ace.firebasestorage.app',
    iosBundleId: 'com.example.jogos',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions is not supported for this platform.',
        );
    }
  }
}