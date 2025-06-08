import React, { useState } from "react";
import { useLocation } from "@docusaurus/router";
import { signInWithGoogle, auth } from "./firebase";

const PROTECTED_PATHS = [
  "/1c-telegram-bot-management/docs/usage-guide/message-form",
];

function isProtectedPath(pathname: string): boolean {
  return PROTECTED_PATHS.some((path) => pathname.startsWith(path));
}

export default function Root({ children }) {
  const location = useLocation();

  console.log(location);

  const [userAuth, setUserAuth] = useState(null);
  const [authLoading, setAuthLoading] = useState(true);

  auth.onAuthStateChanged(async function (user) {
    if (user !== null) {
      setUserAuth(user);
    }

    setAuthLoading(false);
  });

  const isAuthenticated = () => {
    return userAuth?.email;
  };

  if (authLoading) {
    return (
      <>
        <div>Loading...</div>
        <div style={{ display: "none" }}>{children}</div>
      </>
    );
  }

  return (
    <>
      {isProtectedPath(location.pathname) && !isAuthenticated() ? (
        <div className="login">
          <div className="login__container">
            <button
              className="login__btn login__google"
              onClick={signInWithGoogle}
            >
              Login with Google
            </button>
          </div>
        </div>
      ) : (
        <>{children}</>
      )}
    </>
  );
}
