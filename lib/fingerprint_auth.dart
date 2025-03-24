
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintAuth extends StatefulWidget {
  const FingerprintAuth({super.key});

  @override
  _FingerprintAuthState createState() => _FingerprintAuthState();
}

class _FingerprintAuthState extends State<FingerprintAuth> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticated = false;

  Future<void> authenticate() async {
    try {
      if (isAuthenticated) {
        log("Logging out...");
        setState(() {
          isAuthenticated = false;
        });
        showCustomSnackBar(context, 'Logged out');
        return;
      }

      log("Checking biometrics...");
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();
      log("canCheckBiometrics: $canCheckBiometrics, isDeviceSupported: $isDeviceSupported");

      if (!canCheckBiometrics || !isDeviceSupported) {
        showCustomSnackBar(context, 'Biometric authentication is not available');

        return;
      }

      log("Starting authentication...");
      bool authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      log("Authentication result: $authenticated");

      setState(() {
        isAuthenticated = authenticated;
      });

      if (authenticated) {
       showCustomSnackBar(context, 'Authentication Successful', isSuccess: true);

      }
    } catch (e) {
      log("Error: $e");
    }
  }
  void showCustomSnackBar(BuildContext context, String message, {bool isSuccess = false}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Text(message, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
    backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: EdgeInsets.all(10),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isAuthenticated
              ? [Colors.greenAccent.shade400, Colors.blueAccent]
              : [Colors.redAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Biometric Auth",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
          backgroundColor: Colors.black.withValues(
           alpha:  0.5),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: GestureDetector(
            onTap: authenticate,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isAuthenticated ? Colors.greenAccent : Colors.blueAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Icon(
                isAuthenticated ? Icons.lock_open_rounded : Icons.fingerprint,
                size: 80,
                color: Colors.white,
              ),
            ).animate().scale(delay: 200.ms, duration: 300.ms),
          ),
        ),
      ),
    );
  }
}
