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
    apiKey: 'AIzaSyDhtDYvkdCgdI2EXRiq9Hsq57Q2hxIhWzM',
    appId: '1:647858978247:web:dbc9e5d99bd02f1b1e6de2',
    messagingSenderId: '647858978247',
    projectId: 'poem-7017-project',
    authDomain: 'poem-7017-project.firebaseapp.com',
    storageBucket: 'poem-7017-project.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkQ7pchDpBR4jKukhJToRIAU48slGKNgo',
    appId: '1:647858978247:android:48066629407da7e51e6de2',
    messagingSenderId: '647858978247',
    projectId: 'poem-7017-project',
    storageBucket: 'poem-7017-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAE2oZn08XR4VA7t_HIq8rMWtPfXx7ARcA',
    appId: '1:647858978247:ios:7295794fa704f6631e6de2',
    messagingSenderId: '647858978247',
    projectId: 'poem-7017-project',
    storageBucket: 'poem-7017-project.firebasestorage.app',
    iosBundleId: 'com.mincholover.app.poet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAE2oZn08XR4VA7t_HIq8rMWtPfXx7ARcA',
    appId: '1:647858978247:ios:7295794fa704f6631e6de2',
    messagingSenderId: '647858978247',
    projectId: 'poem-7017-project',
    storageBucket: 'poem-7017-project.firebasestorage.app',
    iosBundleId: 'com.mincholover.app.poet',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDhtDYvkdCgdI2EXRiq9Hsq57Q2hxIhWzM',
    appId: '1:647858978247:web:6df476e43c902b251e6de2',
    messagingSenderId: '647858978247',
    projectId: 'poem-7017-project',
    authDomain: 'poem-7017-project.firebaseapp.com',
    storageBucket: 'poem-7017-project.firebasestorage.app',
  );

}