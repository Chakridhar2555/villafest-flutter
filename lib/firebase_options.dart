import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCG2BQGrVtCdsTsJKbliP4J9Qxwl9szVT0',
    appId: '1:123456789012:web:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'villafest-app',
    authDomain: 'villafest-app.firebaseapp.com',
    storageBucket: 'villafest-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCG2BQGrVtCdsTsJKbliP4J9Qxwl9szVT0',
    appId: '1:123456789012:android:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'villafest-app',
    storageBucket: 'villafest-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCG2BQGrVtCdsTsJKbliP4J9Qxwl9szVT0',
    appId: '1:123456789012:ios:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'villafest-app',
    storageBucket: 'villafest-app.appspot.com',
    iosClientId: 'com.googleusercontent.apps.123456789012-abcdefghijklmnopqrstuvwxyz',
    iosBundleId: 'com.example.villafest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCG2BQGrVtCdsTsJKbliP4J9Qxwl9szVT0',
    appId: '1:123456789012:macos:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'villafest-app',
    storageBucket: 'villafest-app.appspot.com',
    iosClientId: 'com.googleusercontent.apps.123456789012-abcdefghijklmnopqrstuvwxyz',
    iosBundleId: 'com.example.villafest',
  );
} 