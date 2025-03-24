import 'package:app/fingerprint_auth.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biometric Auth',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const FingerprintAuth(),
    );
  }
}

// // bulig.gradle
// minSdk = 23




// // MainActivity.kt       
// package com.example.app

// import io.flutter.embedding.android.FlutterFragmentActivity

// class MainActivity : FlutterFragmentActivity()




// // AndroidManifest.xml
//     <!-- Permissions for fingerprint/biometric authentication -->
//     <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
//     <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
//     <uses-feature android:name="android.hardware.fingerprint" android:required="true"/>



//Dependency
//  local_auth: ^2.3.0