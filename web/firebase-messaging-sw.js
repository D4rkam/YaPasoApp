// Importamos los scripts oficiales de Firebase (versión compat)
importScripts(
  "https://www.gstatic.com/firebasejs/10.8.1/firebase-app-compat.js",
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.8.1/firebase-messaging-compat.js",
);

// 👇 PEGÁ ACÁ LA CONFIGURACIÓN DE TU PROYECTO 👇
// (La encontrás en la consola de Firebase > Configuración del proyecto > General > Tus apps > Web)
const firebaseConfig = {
  apiKey: "AIzaSyAnbZbg7N7Svxh1LYvmZUz_vUzZUrBg_ZA",
  authDomain: "yapaso-api-notifications.firebaseapp.com",
  projectId: "yapaso-api-notifications",
  storageBucket: "yapaso-api-notifications.firebasestorage.app",
  messagingSenderId: "668804665409",
  appId: "1:668804665409:web:ca01261a8de1d4633136c0",
  measurementId: "G-SPZS685C4F",
};

// Inicializamos Firebase en el Service Worker
firebase.initializeApp(firebaseConfig);

// Inicializamos Cloud Messaging de fondo
const messaging = firebase.messaging();

// Opcional: Para manejar los mensajes cuando la pestaña está en segundo plano
messaging.onBackgroundMessage((payload) => {
  console.log(
    "[firebase-messaging-sw.js] Mensaje recibido de fondo: ",
    payload,
  );
  // El navegador mostrará la notificación automáticamente si mandás 'notification'
});
