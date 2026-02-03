import React, { useEffect, useMemo, useState } from "react";
import Layout from "@theme/Layout";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import { signInWithPopup, signOut, type User } from "firebase/auth";
import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  getDocs,
  serverTimestamp,
  updateDoc,
} from "firebase/firestore";
import type { FirebaseOptions } from "firebase/app";
import { initFirebase } from "../../lib/firebase";
import {
  CONFIGURATION_OPTIONS,
  type ScriptRecord,
} from "../../lib/scripts";
import styles from "./marketplace.module.css";

type ScriptFormState = {
  title: string;
  description: string;
  script: string;
  configs: string[];
};

const emptyForm: ScriptFormState = {
  title: "",
  description: "",
  script: "",
  configs: [],
};

const ScriptsPage = (): JSX.Element => {
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
  const [loading, setLoading] = useState(false);
  const [formState, setFormState] = useState<ScriptFormState>(emptyForm);
  const [editingId, setEditingId] = useState<string | null>(null);
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

  const loadScripts = async (authorId: string) => {
    if (!services) {
      return;
    }
    setLoading(true);
    try {
      const snapshot = await getDocs(collection(services.db, "scripts"));
      const data = snapshot.docs
        .map((item) => ({ id: item.id, ...(item.data() as ScriptRecord) }))
        .filter((item) => item.authorId === authorId)
        .sort((a, b) => {
          const aValue = a.createdAt?.toMillis?.() ?? 0;
          const bValue = b.createdAt?.toMillis?.() ?? 0;
          return bValue - aValue;
        });
      setScripts(data);
    } catch (error) {
      setErrorMessage(
        "Не удалось загрузить ваши скрипты. Проверьте доступ к Firebase.",
      );
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (user) {
      void loadScripts(user.uid);
    } else {
      setScripts([]);
    }
  }, [user]);

  const handleAuth = async () => {
    if (!services) {
      setErrorMessage("Firebase не настроен. Укажите конфигурацию в окружении.");
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

  const handleFormChange = (
    field: keyof ScriptFormState,
    value: string | string[],
  ) => {
    setFormState((prev) => ({
      ...prev,
      [field]: value,
    }));
  };

  const handleToggleConfig = (configName: string) => {
    setFormState((prev) => {
      if (prev.configs.includes(configName)) {
        return {
          ...prev,
          configs: prev.configs.filter((item) => item !== configName),
        };
      }
      return {
        ...prev,
        configs: [...prev.configs, configName],
      };
    });
  };

  const handleSubmit = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!services || !user) {
      return;
    }
    if (!formState.title || !formState.script) {
      setErrorMessage("Заполните заголовок и текст скрипта.");
      return;
    }
    setErrorMessage("");
    setLoading(true);
    try {
      if (editingId) {
        const ref = doc(services.db, "scripts", editingId);
        await updateDoc(ref, {
          title: formState.title,
          description: formState.description,
          script: formState.script,
          configs: formState.configs,
          updatedAt: serverTimestamp(),
        });
      } else {
        await addDoc(collection(services.db, "scripts"), {
          title: formState.title,
          description: formState.description,
          script: formState.script,
          configs: formState.configs,
          authorId: user.uid,
          authorName: user.displayName ?? "Без имени",
          authorEmail: user.email ?? "",
          createdAt: serverTimestamp(),
          updatedAt: serverTimestamp(),
          likes: [],
        });
      }
      setFormState(emptyForm);
      setEditingId(null);
      await loadScripts(user.uid);
    } catch (error) {
      setErrorMessage("Не удалось сохранить скрипт. Проверьте права доступа.");
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = (scriptItem: ScriptRecord) => {
    setFormState({
      title: scriptItem.title,
      description: scriptItem.description,
      script: scriptItem.script,
      configs: scriptItem.configs ?? [],
    });
    setEditingId(scriptItem.id);
  };

  const handleDelete = async (scriptId: string) => {
    if (!services || !user) {
      return;
    }
    if (!window.confirm("Удалить скрипт?")) {
      return;
    }
    setLoading(true);
    try {
      await deleteDoc(doc(services.db, "scripts", scriptId));
      await loadScripts(user.uid);
    } catch (error) {
      setErrorMessage("Не удалось удалить скрипт.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout title="Мои скрипты" description="Управление скриптами для Telegram">
      <div className={styles.page}>
        <div className={styles.container}>
          <div className={styles.header}>
            <div>
              <h1 className={styles.title}>Мои скрипты</h1>
              <p className={styles.infoText}>
                Создавайте и обновляйте скрипты для интеграции с Telegram.
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
              Firebase не настроен. Добавьте параметры в переменные окружения
              сайта, чтобы включить маркетплейс.
            </div>
          )}

          {errorMessage && (
            <div className={styles.emptyState}>{errorMessage}</div>
          )}

          {user ? (
            <>
              <form className={styles.form} onSubmit={handleSubmit}>
                <div className={styles.formRow}>
                  <label htmlFor="title">Заголовок</label>
                  <input
                    id="title"
                    type="text"
                    value={formState.title}
                    onChange={(event) =>
                      handleFormChange("title", event.target.value)
                    }
                    placeholder="Например, отправка отчета в Telegram"
                  />
                </div>
                <div className={styles.formRow}>
                  <label htmlFor="description">Описание</label>
                  <textarea
                    id="description"
                    rows={3}
                    value={formState.description}
                    onChange={(event) =>
                      handleFormChange("description", event.target.value)
                    }
                    placeholder="Кратко опишите сценарий и назначение."
                  />
                </div>
                <div className={styles.formRow}>
                  <label htmlFor="script">Скрипт</label>
                  <textarea
                    id="script"
                    rows={6}
                    value={formState.script}
                    onChange={(event) =>
                      handleFormChange("script", event.target.value)
                    }
                    placeholder="Введите текст скрипта."
                  />
                </div>
                <div className={styles.formRow}>
                  <span>Совместимые конфигурации</span>
                  <div className={styles.checkboxGrid}>
                    {CONFIGURATION_OPTIONS.map((option) => (
                      <label key={option} className={styles.checkboxItem}>
                        <input
                          type="checkbox"
                          checked={formState.configs.includes(option)}
                          onChange={() => handleToggleConfig(option)}
                        />
                        {option}
                      </label>
                    ))}
                  </div>
                </div>
                <div className={styles.actions}>
                  <button
                    className="button button--primary"
                    type="submit"
                    disabled={loading}
                  >
                    {editingId ? "Сохранить изменения" : "Создать скрипт"}
                  </button>
                  {editingId && (
                    <button
                      className="button button--secondary"
                      type="button"
                      onClick={() => {
                        setEditingId(null);
                        setFormState(emptyForm);
                      }}
                    >
                      Отменить редактирование
                    </button>
                  )}
                </div>
              </form>

              {loading && scripts.length === 0 ? (
                <div className={styles.emptyState}>Загрузка...</div>
              ) : scripts.length === 0 ? (
                <div className={styles.emptyState}>
                  У вас пока нет скриптов. Создайте первый!
                </div>
              ) : (
                <div className={styles.grid}>
                  {scripts.map((scriptItem) => (
                    <div key={scriptItem.id} className={styles.card}>
                      <div>
                        <h3 className={styles.cardTitle}>
                          {scriptItem.title}
                        </h3>
                        <p className={styles.meta}>{scriptItem.description}</p>
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
                          onClick={() => handleEdit(scriptItem)}
                        >
                          Редактировать
                        </button>
                        <button
                          className="button button--danger"
                          type="button"
                          onClick={() => handleDelete(scriptItem.id)}
                        >
                          Удалить
                        </button>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </>
          ) : (
            <div className={styles.emptyState}>
              Авторизуйтесь, чтобы создавать и управлять скриптами.
            </div>
          )}
        </div>
      </div>
    </Layout>
  );
};

export default ScriptsPage;
