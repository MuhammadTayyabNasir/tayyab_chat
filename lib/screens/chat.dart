
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tayyab_chat/screens/auth.dart'; // Re-use the background
import 'package:tayyab_chat/widgets/chat_messages.dart';
import 'package:tayyab_chat/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ... (Your notification setup methods are fine as they are)
  void setupNotification() async {
    var fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    if (!kIsWeb) { await fcm.subscribeToTopic('chat'); }
    final token = await fcm.getToken(vapidKey: 'YOUR_VAPID_KEY_HERE',);
    if (token != null) { await sendTokenToServer(token); }
  }
  Future<void> sendTokenToServer(String token) async {
    if (kIsWeb) {
      try {
        final callable = FirebaseFunctions.instance.httpsCallable('subscribeWebUserToTopic',);
        await callable.call<Map<String, dynamic>>({'token': token, 'topic': 'chat'});
      } catch (e) {
        if (kDebugMode) {
          print('Failed to call cloud function: $e');
        }
      }
    }
  }


  @override
  void initState() {
    super.initState();
    setupNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows body to go behind transparent app bar
      appBar: AppBar(
        title: const Text('Tayyab Chat'),
        actions: [
          IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: AppBackground( // Re-use the decorative background
        child: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}