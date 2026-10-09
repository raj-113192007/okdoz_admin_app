import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/admin_layout.dart';
import 'services/crash_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CrashService.initialize(appRole: 'admin');

  if (!kIsWeb) {
    try {
      // ignore: deprecated_member_use
      await FirebaseAppCheck.instance.activate(
        // ignore: deprecated_member_use
        androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
        // ignore: deprecated_member_use
        appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
      );
    } catch (e) {
      debugPrint('Firebase AppCheck initialization skipped: $e');
    }
  }
  runApp(
    const ProviderScope(
      child: AdminApp(),
    ),
  );
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OK Doz Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6D00)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const AdminLayout(),
    );
  }
}
