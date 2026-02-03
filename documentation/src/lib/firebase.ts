import type { FirebaseOptions } from "firebase/app";
import { getApp, getApps, initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider, type Auth } from "firebase/auth";
import { getFirestore, type Firestore } from "firebase/firestore";

export type FirebaseServices = {
  auth: Auth;
  db: Firestore;
  provider: GoogleAuthProvider;
};

export const initFirebase = (
  firebaseConfig: FirebaseOptions,
): FirebaseServices | null => {
  if (!firebaseConfig?.apiKey) {
    return null;
  }

  const app = getApps().length > 0 ? getApp() : initializeApp(firebaseConfig);

  return {
    auth: getAuth(app),
    db: getFirestore(app),
    provider: new GoogleAuthProvider(),
  };
};
