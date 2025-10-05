
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bubbleDecoration = BoxDecoration(
      color: isMe
          ? theme.colorScheme.primary.withAlpha(102)
          : theme.cardTheme.color!.withAlpha(179),
      borderRadius: BorderRadius.only(
        topLeft: !isMe && isFirstInSequence ? Radius.zero : const Radius.circular(12),
        topRight: isMe && isFirstInSequence ? Radius.zero : const Radius.circular(12),
        bottomLeft: const Radius.circular(12),
        bottomRight: const Radius.circular(12),
      ),
      border: Border.all(
        color: isMe
            ? theme.colorScheme.primary.withAlpha(204)
            : Colors.white.withAlpha(62),
        width: 1.5,
      ),
    );

    return Stack(
      children: [
        if (userImage != null)
          Positioned(
            top: (MediaQuery.of(context).size.width>400)?20:14,
            right: isMe ? 0 : null,
            left: isMe ? null : 0,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage!),
              radius: 23,
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 46),
          child: Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              // THE FIX: WRAP THE COLUMN IN A FLEXIBLE WIDGET
              // This allows the column (and the message bubble inside it) to shrink
              // if it runs out of horizontal space, preventing the overflow.
              Flexible(
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (isFirstInSequence) const SizedBox(height: 18),
                    if (username != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 13, right: 13, bottom: 4),
                        child: Text(
                          username!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe ? theme.colorScheme.primary : Colors.white70,
                          ),
                        ),
                      ),
                    Container(
                      decoration: bubbleDecoration,
                      constraints: const BoxConstraints(maxWidth: 240),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                      child: Text(
                        message,
                        style: const TextStyle(height: 1.3, color: Colors.white),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}