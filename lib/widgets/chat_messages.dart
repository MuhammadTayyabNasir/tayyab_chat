
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tayyab_chat/widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages yet. Be the first!'),
          );
        }
        if (chatSnapshot.hasError) {
          return Center(child: Text('Something went wrong: ${chatSnapshot.error}'));
        }
        var loadedMessages = chatSnapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            var message = loadedMessages[index].data();
            var nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            var currentMessageUserId = message['userId'];
            var nextMessageUserId =
            nextMessage != null ? nextMessage['userId'] : null;
            var isNextUserSame = currentMessageUserId == nextMessageUserId;

            final isMe = authenticatedUser.uid == currentMessageUserId;

            if (isNextUserSame) {
              return MessageBubble.next(
                message: message['text'] ?? '',
                // BUG FIX: Was comparing a User object to a String ID.
                isMe: isMe,
              );
            } else {
              return MessageBubble.first(
                userImage: message['userImage'] ?? '',
                username: message['username'] ?? 'Unknown User',
                message: message['text'] ?? '',
                isMe: isMe,
              );
            }
          },
        );
      },
    );
  }
}