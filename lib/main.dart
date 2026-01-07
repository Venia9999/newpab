import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

import 'pages/login_page.dart';
import 'providers/user_provider.dart';
import 'providers/ticket_provider.dart'; // ✅ WAJIB

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TicketProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bioskop App',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFD4AF37), // gold theme
        ),
        home: const LoginPage(),
      ),
    );
  }
}
