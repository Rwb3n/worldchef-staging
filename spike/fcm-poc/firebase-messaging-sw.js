// Firebase messaging service worker
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

// Firebase config
const firebaseConfig = {
    apiKey: "AIzaSyBF1j1YSqaRBRO28D74cZe3K54Q4297lL4",
    authDomain: "worldchef-3fd9e.firebaseapp.com",
    projectId: "worldchef-3fd9e",
    storageBucket: "worldchef-3fd9e.firebasestorage.app",
    messagingSenderId: "269410347283",
    appId: "1:269410347283:web:731092e13f20d918ad92e6",
    measurementId: "G-Y7SENR2TZX"
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

// Initialize Firebase Cloud Messaging and get a reference to the service
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png' // Optional: add an icon
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
}); 