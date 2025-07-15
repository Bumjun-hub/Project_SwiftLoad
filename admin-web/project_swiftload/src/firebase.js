
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";            // ← 이 줄 꼭 필요!
import { getAuth, GoogleAuthProvider } from "firebase/auth";

const firebaseConfig = {
    apiKey: "AIzaSyBuiJcziUnIHxt5nsXLN4aBIc7HyYIjC8w",
    authDomain: "project3-9c3d4.firebaseapp.com",
    projectId: "project3-9c3d4",
    storageBucket: "project3-9c3d4.firebasestorage.app",
    messagingSenderId: "1080171621537",
    appId: "1:1080171621537:web:f80f4ca00927c1047f54e0"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);                       // DB 객체 export
export const auth = getAuth(app);                          // Auth 객체 export
export const googleProvider = new GoogleAuthProvider();    // 구글 로그인 Provider export