import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangu/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Debug provider dulu untuk dev lokal (Android). Ganti ke
  // AndroidPlayIntegrityProvider sebelum rilis produksi (R400.2,
  // ADR-007).
  await FirebaseAppCheck.instance.activate(
    providerAndroid: const AndroidDebugProvider(),
  );
  runApp(const ProviderScope(child: SanguApp()));
}

/// Root widget aplikasi Sangu.
class SanguApp extends StatelessWidget {
  /// Buat instance [SanguApp].
  const SanguApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sangu',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Sangu', style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
