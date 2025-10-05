// functions/index.js

// Import the necessary modules from the Firebase SDK
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

// =================================================================
// Initialize the Admin SDK ONCE for all functions in this file.
admin.initializeApp();
// =================================================================


/**
 * A callable function to subscribe a web client to an FCM topic.
 * This is called from your Flutter web app.
 */
exports.subscribeWebUserToTopic = onCall(async (request) => {
  // In v2 functions, the data sent from the client is in `request.data`
  const data = request.data;
  const fcmToken = data.token;
  const topic = data.topic;

  console.log("Subscription triggered. Payload:", JSON.stringify(data));

  if (!fcmToken || !topic) {
    console.error("Missing token or topic in request.");
    throw new HttpsError(
        "invalid-argument",
        "The function must be called with a 'token' and 'topic'.",
    );
  }

  try {
    await admin.messaging().subscribeToTopic(fcmToken, topic);
    console.log(`Successfully subscribed token ${fcmToken} to topic ${topic}`);
    return {success: true, message: `Subscribed to topic: ${topic}`};
  } catch (error) {
    console.error(`Error subscribing ${fcmToken} to topic ${topic}`, error);
    throw new HttpsError(
        "internal",
        "An error occurred while subscribing to the topic.",
    );
  }
});


/**
 * A Firestore trigger that sends a push notification when a new message
 * is added to the 'chat' collection.
 */
exports.sendChatNotification =
 onDocumentCreated("chat/{messageId}", async (event) => {
   // Get the data from the newly created document
   const snapshot = event.data;
   if (!snapshot) {
     console.log("No data associated with the event");
     return;
   }
   const chatData = snapshot.data();

   // Construct the notification payload
   const payload = {
     notification: {
       title: `New message from ${chatData.username}`,
       body: chatData.text,
     },
     topic: "chat",
   };

   try {
     // Send the message
     await admin.messaging().send(payload);
     console.log("Successfully sent notification for new chat message.");
   } catch (error) {
     console.error("Error sending notification:", error);
   }
 });
