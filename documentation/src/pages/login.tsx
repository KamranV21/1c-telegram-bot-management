import type { ReactNode } from "react";
import { Redirect } from "@docusaurus/router";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import { auth, signInWithGoogle } from "@site/src/theme/Root/firebase";

import Translate from "@docusaurus/Translate";

import styles from "./index.module.css";

async function onGoogleSignIn() {
  await signInWithGoogle();
  window.location.reload();
}

export default function Login(): ReactNode {
  const { siteConfig } = useDocusaurusContext();

  const user = auth.currentUser;
  if (user) return <Redirect to="/1c-telegram-bot-management" />;

  return (
    <Layout
      title={`${siteConfig.title}`}
      description="Расширение 1С для интеграции с чат-ботами Telegram"
    >
      <main>
        <div className="container">
          <button
            className="button button--secondary button-lg"
            onClick={onGoogleSignIn}
          >
            <Translate>Войти через Google</Translate>
          </button>
        </div>
      </main>
    </Layout>
  );
}
