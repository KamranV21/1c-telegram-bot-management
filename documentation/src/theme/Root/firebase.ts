import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import "firebase/auth";
import {
  GoogleAuthProvider,
  getAuth,
  signInWithPopup,
  signOut,
} from "firebase/auth";
import siteConfig from "@generated/docusaurus.config";

const firebaseConfig = {
  apiKey: siteConfig.customFields.apiKey as string,
  authDomain: siteConfig.customFields.authDomain as string,
  projectId: siteConfig.customFields.projectId as string,
  storageBucket: siteConfig.customFields.storageBucket as string,
  messagingSenderId: siteConfig.customFields.messagingSenderId as string,
  appId: siteConfig.customFields.appId as string,
  measurementId: siteConfig.customFields.measurementId as string,
};

export const app = initializeApp(firebaseConfig);

export const analytics = getAnalytics(app);

export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();

export const logout = (afterAction = () => {}) => {
  signOut(auth).then((r) => afterAction());
};

export const signInWithGoogle = async () => {
  try {
    await signInWithPopup(auth, googleProvider);
  } catch (err) {
    console.error(err);
    alert(err.message);
  }
};
