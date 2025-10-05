import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:tayyab_chat/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tayyab_chat/screens/chat.dart';
import 'package:tayyab_chat/screens/splash.dart';
import 'firebase_options.dart';

// --- NEON THEME CONSTANTS ---
const kNeonColor = Color(0xFF00BFFF); // Deep Sky Blue - Our primary neon color
const kBackgroundColor = Color(0xFF121212); // A very dark grey, almost black
const kGlassColor = Color.fromARGB(255, 30, 30, 30); // Dark, semi-transparent glass

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the base text theme using Google Fonts for a modern look
    final textTheme = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Colors.white70, displayColor: Colors.white);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterChat',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackgroundColor,
        colorScheme: const ColorScheme.dark(
          primary: kNeonColor,
          secondary: Colors.pinkAccent, // A secondary neon color for accents
          surface: kBackgroundColor,
        ),
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Make AppBar transparent
          elevation: 0,
        ),
        // Style for our glass cards
        cardTheme: CardThemeData(
          color: kGlassColor.withAlpha(128), // Semi-transparent card
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: kGlassColor.withAlpha(204), width: 1.5),
          ),
        ),
        // Style for input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kGlassColor.withAlpha(179),
          floatingLabelStyle: const TextStyle(color: kNeonColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kNeonColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: kGlassColor.withAlpha(204)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        // Style for buttons with a neon glow effect
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
            backgroundColor: WidgetStateProperty.all(kNeonColor),
            foregroundColor: WidgetStateProperty.all(Colors.black),
            // The magic for the neon glow
            overlayColor: WidgetStateProperty.all(kNeonColor.withAlpha(77)),
            shadowColor: WidgetStateProperty.all(kNeonColor),
            elevation: WidgetStateProperty.all(8),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: kNeonColor,
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}