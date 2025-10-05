# Flutter Neon Chat

A stunning, real-time chat application built with Flutter and Firebase. This project showcases a modern "Neon Glassmorphism" user interface, providing a futuristic and visually appealing chat experience that is responsive on both mobile and desktop platforms.

![Flutter Neon Chat Banner](https://github.com/MuhammadTayyabNasir/tayyab_chat/blob/main/assets/images/chat.png)

##  Screenshots

| Authentication Screen                                   | Chat Screen                                             |
| ------------------------------------------------------- | ------------------------------------------------------- |
|  ![](https://github.com/MuhammadTayyabNasir/tayyab_chat/blob/main/assets/images/chat.png)|![](https://github.com/MuhammadTayyabNasir/tayyab_chat/blob/main/assets/images/chat.png)  |

## ✨ Features

-   **Real-time Messaging:** Instant message delivery powered by Cloud Firestore streams.
-   **User Authentication:** Secure sign-up and login with email & password using Firebase Auth.
-   **Profile Pictures:** Users can upload profile pictures from their device camera, stored in Firebase Storage.
-   **Push Notifications:** Receive notifications for new messages using Firebase Cloud Messaging (FCM). Includes a Cloud Function for handling web subscriptions.
-   **Stunning UI/UX:** A custom-themed "Neon Glassmorphism" design that provides a unique, futuristic feel with blurred, semi-transparent elements and glowing neon accents.
-   **Responsive Design:** The interface is optimized for a great experience on both mobile phones and wider desktop/web screens.
-   **Optimized Message Bubbles:** Message bubbles are grouped by sender for a cleaner and more readable chat history.

## 🚀 Tech Stack & Dependencies

-   **Framework:** Flutter 3.19+
-   **Backend:** Firebase
    -   **Authentication:** Firebase Auth
    -   **Database:** Cloud Firestore
    -   **Storage:** Firebase Cloud Storage
    -   **Notifications:** Firebase Cloud Messaging (FCM)
    -   **Serverless:** Firebase Cloud Functions (for web push notifications)
-   **UI & Design:**
    -   `google_fonts` for custom typography.
    -   `BackdropFilter` for the frosted glass effect.
-   **Core Plugins:**
    -   `firebase_core`
    -   `firebase_auth`
    -   `cloud_firestore`
    -   `firebase_storage`
    -   `firebase_messaging`
    -   `cloud_functions`
    -   `image_picker`

## ⚙️ Setup and Installation

To get this project running on your local machine, follow these steps.

### 1. Prerequisites

-   You must have Flutter installed on your machine.
-   You must have a Firebase account.
-   You need Node.js and the Firebase CLI installed for deploying cloud functions (`npm install -g firebase-tools`).

### 2. Clone the Repository

```bash
git clone https://github.com/MuhammadTayyabNasir/tayyab_chat.git
cd tayyab_chat
