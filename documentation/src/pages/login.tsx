import type { ReactNode } from "react";
import { Redirect } from "@docusaurus/router";
import Layout from "@theme/Layout";
import Heading from "@theme/Heading";
import { auth, signInWithGoogle } from "@site/src/theme/Root/firebase";

import Translate from "@docusaurus/Translate";

import styles from "./index.module.css";

async function onGoogleSignIn() {
  await signInWithGoogle();
  window.location.reload();
}

export default function Login(): ReactNode {
  const user = auth.currentUser;
  if (user) return <Redirect to="/1c-telegram-bot-management" />;

  return (
    <Layout
      title={"Авторизация"}
      description="Расширение 1С для интеграции с чат-ботами Telegram"
    >
      <main
        style={{
          display: "flex",
          flex: 1,
          minHeight: "100%",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <div className="container text--center">
          <Heading as="h1">
            <Translate>Авторизация</Translate>
          </Heading>
          <button
            className="button button--primary button--lg"
            onClick={onGoogleSignIn}
          >
            <Translate>Войти через Google</Translate>
          </button>
        </div>
      </main>
    </Layout>
  );
}
