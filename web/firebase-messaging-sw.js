importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyC6otGQ3MVcDQyn9Jy5fFVPkQ2XCMVgQDI",
  authDomain: "tayyab-chat.firebaseapp.com",
  projectId: "tayyab-chat",
  storageBucket: "tayyab-chat.firebasestorage.app",
  messagingSenderId: "616540584942",
  appId: "1:616540584942:web:002ea1862d13dc67b16cff",
  measurementId: "G-DWPXT4RCL5"
};


firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();