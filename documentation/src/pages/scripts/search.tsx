import React, { useEffect, useMemo, useState } from "react";
import Layout from "@theme/Layout";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import { signInWithPopup, signOut, type User } from "firebase/auth";
import {
  arrayRemove,
  arrayUnion,
  collection,
  doc,
  getDocs,
  updateDoc,
} from "firebase/firestore";
import type { FirebaseOptions } from "firebase/app";
import { initFirebase } from "../../lib/firebase";
import {
  CONFIGURATION_OPTIONS,
  normalizeSearchText,
  type ScriptRecord,
} from "../../lib/scripts";
import styles from "./marketplace.module.css";

const PAGE_SIZE = 6;

const SearchScriptsPage = (): JSX.Element => {
  const { siteConfig } = useDocusaurusContext();
  const firebaseConfig = siteConfig.customFields
    ?.firebaseConfig as FirebaseOptions;

  const services = useMemo(() => {
    if (typeof window === "undefined") {
      return null;
    }
    return initFirebase(firebaseConfig);
  }, [firebaseConfig]);

  const [user, setUser] = useState<User | null>(null);
  const [scripts, setScripts] = useState<ScriptRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedConfigs, setSelectedConfigs] = useState<string[]>([]);
  const [page, setPage] = useState(1);
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    if (!services) {
      return;
    }
    const unsubscribe = services.auth.onAuthStateChanged((nextUser) => {
      setUser(nextUser);
    });
    return () => unsubscribe();
  }, [services]);

  const loadScripts = async () => {
    if (!services) {
      setLoading(false);
      return;
    }
    setLoading(true);
    try {
      const snapshot = await getDocs(collection(services.db, "scripts"));
      const data = snapshot.docs.map((item) => ({
        id: item.id,
        ...(item.data() as ScriptRecord),
      }));
      setScripts(data);
    } catch (error) {
      setErrorMessage(
        "Не удалось загрузить скрипты. Проверьте доступ к Firebase.",
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void loadScripts();
  }, [services]);

  const handleAuth = async () => {
    if (!services) {
      setErrorMessage("Firebase не настроен. Авторизация недоступна.");
      return;
    }
    setErrorMessage("");
    try {
      await signInWithPopup(services.auth, services.provider);
    } catch (error) {
      setErrorMessage("Не удалось авторизоваться через Google.");
    }
  };

  const handleSignOut = async () => {
    if (!services) {
      return;
    }
    await signOut(services.auth);
  };

  const handleToggleConfig = (configName: string) => {
    setSelectedConfigs((prev) => {
      if (prev.includes(configName)) {
        return prev.filter((item) => item !== configName);
      }
      return [...prev, configName];
    });
  };

  const filteredScripts = useMemo(() => {
    const queryText = normalizeSearchText(searchQuery);
    return scripts.filter((scriptItem) => {
      const configMatches =
        selectedConfigs.length === 0 ||
        scriptItem.configs?.some((config) =>
          selectedConfigs.includes(config),
        );
      if (!configMatches) {
        return false;
      }
      if (!queryText) {
        return true;
      }
      const searchTarget = normalizeSearchText(
        [
          scriptItem.title,
          scriptItem.description,
          scriptItem.script,
          ...(scriptItem.configs ?? []),
        ].join(" "),
      );
      return searchTarget.includes(queryText);
    });
  }, [scripts, searchQuery, selectedConfigs]);

  const totalPages = Math.max(1, Math.ceil(filteredScripts.length / PAGE_SIZE));
  const safePage = Math.min(page, totalPages);
  const paginatedScripts = filteredScripts.slice(
    (safePage - 1) * PAGE_SIZE,
    safePage * PAGE_SIZE,
  );

  const handleLike = async (scriptItem: ScriptRecord) => {
    if (!services || !user) {
      setErrorMessage("Войдите, чтобы ставить лайки.");
      return;
    }
    const ref = doc(services.db, "scripts", scriptItem.id);
    const hasLike = scriptItem.likes?.includes(user.uid);
    try {
      await updateDoc(ref, {
        likes: hasLike ? arrayRemove(user.uid) : arrayUnion(user.uid),
      });
      await loadScripts();
    } catch (error) {
      setErrorMessage("Не удалось обновить лайк.");
    }
  };

  useEffect(() => {
    setPage(1);
  }, [searchQuery, selectedConfigs]);

  return (
    <Layout
      title="Поиск скриптов"
      description="Маркетплейс скриптов для Telegram"
    >
      <div className={styles.page}>
        <div className={styles.container}>
          <div className={styles.header}>
            <div>
              <h1 className={styles.title}>Поиск скриптов</h1>
              <p className={styles.infoText}>
                Ищите сценарии по названию, описанию, конфигурации или коду.
              </p>
            </div>
            <div className={styles.authCard}>
              {user ? (
                <>
                  <span>{user.displayName ?? user.email}</span>
                  <button
                    className={`button button--secondary ${styles.authButton}`}
                    type="button"
                    onClick={handleSignOut}
                  >
                    Выйти
                  </button>
                </>
              ) : (
                <button
                  className={`button button--primary ${styles.authButton}`}
                  type="button"
                  onClick={handleAuth}
                >
                  Войти через Google
                </button>
              )}
            </div>
          </div>

          {!firebaseConfig?.apiKey && (
            <div className={styles.emptyState}>
              Firebase не настроен. Без конфигурации скрипты не загрузятся.
            </div>
          )}

          {errorMessage && (
            <div className={styles.emptyState}>{errorMessage}</div>
          )}

          <div className={styles.form}>
            <div className={styles.formRow}>
              <label htmlFor="search">Поиск</label>
              <input
                id="search"
                type="search"
                value={searchQuery}
                onChange={(event) => setSearchQuery(event.target.value)}
                placeholder="Введите ключевые слова"
              />
            </div>
            <div className={styles.formRow}>
              <span>Конфигурации</span>
              <div className={styles.checkboxGrid}>
                {CONFIGURATION_OPTIONS.map((option) => (
                  <label key={option} className={styles.checkboxItem}>
                    <input
                      type="checkbox"
                      checked={selectedConfigs.includes(option)}
                      onChange={() => handleToggleConfig(option)}
                    />
                    {option}
                  </label>
                ))}
              </div>
            </div>
          </div>

          {loading ? (
            <div className={styles.emptyState}>Загрузка...</div>
          ) : paginatedScripts.length === 0 ? (
            <div className={styles.emptyState}>
              Скрипты не найдены. Попробуйте изменить запрос.
            </div>
          ) : (
            <div className={styles.grid}>
              {paginatedScripts.map((scriptItem) => (
                <div key={scriptItem.id} className={styles.card}>
                  <div>
                    <h3 className={styles.cardTitle}>{scriptItem.title}</h3>
                    <p className={styles.meta}>{scriptItem.description}</p>
                    <p className={styles.meta}>
                      Автор: {scriptItem.authorName}
                    </p>
                  </div>
                  <div className={styles.tagList}>
                    {scriptItem.configs?.map((config) => (
                      <span key={config} className={styles.tag}>
                        {config}
                      </span>
                    ))}
                  </div>
                  <pre className={styles.meta}>{scriptItem.script}</pre>
                  <div className={styles.actions}>
                    <button
                      className="button button--secondary"
                      type="button"
                      onClick={() => void handleLike(scriptItem)}
                    >
                      👍 {scriptItem.likes?.length ?? 0}
                    </button>
                  </div>
                </div>
              ))}
            </div>
          )}

          <div className={styles.pagination}>
            <button
              className="button button--secondary"
              type="button"
              disabled={safePage <= 1}
              onClick={() => setPage((prev) => Math.max(1, prev - 1))}
            >
              Назад
            </button>
            <span>
              Страница {safePage} из {totalPages}
            </span>
            <button
              className="button button--secondary"
              type="button"
              disabled={safePage >= totalPages}
              onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
            >
              Вперёд
            </button>
          </div>
        </div>
      </div>
    </Layout>
  );
};

export default SearchScriptsPage;
