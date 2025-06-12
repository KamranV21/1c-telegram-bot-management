import React, { useState } from "react";
import { useLocation, Redirect } from "@docusaurus/router";
import { auth } from "./firebase";

const PROTECTED_PATHS = [
  "/1c-telegram-bot-management/docs/usage-guide/message-form",
];

function isProtectedPath(pathname: string): boolean {
  return PROTECTED_PATHS.some((path) => pathname.startsWith(path));
}

export default function Root({ children }) {
  const location = useLocation();

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
        <Redirect to="/1c-telegram-bot-management/login" />
      ) : (
        <>{children}</>
      )}
    </>
  );
}
