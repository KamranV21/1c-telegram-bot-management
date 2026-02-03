import { themes as prismThemes } from "prism-react-renderer";
import type { Config } from "@docusaurus/types";
import type * as Preset from "@docusaurus/preset-classic";

// This runs in Node.js - Don't use client-side code here (browser APIs, JSX...)

const config: Config = {
  title: "Интеграция 1С и Telegram",
  tagline: "Бесплатное расширение с открытым исходным кодом",
  favicon: "img/favicon.ico",

  // Set the production url of your site here
  url: "https://github.com",
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: "/1c-telegram-bot-management",

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: "KamranV21", // Usually your GitHub org/user name.
  projectName: "1c-telegram-bot-management", // Usually your repo name.
  deploymentBranch: "gh-pages",
  trailingSlash: false,

  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: "ru",
    locales: ["ru"],
  },

  presets: [
    [
      "classic",
      {
        docs: {
          sidebarPath: "./sidebars.ts",
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            "https://github.com/facebook/docusaurus/tree/main/packages/create-docusaurus/templates/shared/",
        },
        theme: {
          customCss: "./src/css/custom.css",
        },
      } satisfies Preset.Options,
    ],
  ],
  customFields: {
    firebaseConfig: {
      apiKey: process.env.FIREBASE_API_KEY ?? "",
      authDomain: process.env.FIREBASE_AUTH_DOMAIN ?? "",
      projectId: process.env.FIREBASE_PROJECT_ID ?? "",
      storageBucket: process.env.FIREBASE_STORAGE_BUCKET ?? "",
      messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID ?? "",
      appId: process.env.FIREBASE_APP_ID ?? "",
    },
  },

  themeConfig: {
    // Replace with your project's social card
    image: "img/social-card.png",
    metadata: [
      {
        name: "keywords",
        content:
          "1С, Telegram, бот, интеграция, отправка сообщений, чат, вебхук, расширение 1С",
      },
      {
        name: "description",
        content:
          "Интеграция 1С и Telegram — конструктор чат-ботов, отправка сообщений, быстрое подключение",
      },
      {
        name: "og:title",
        content: "Управление ботами Telegram - расширение для 1С",
      },
      {
        name: "og:description",
        content:
          "Бесплатный конструктор чат-ботов Telegram - отправляйте сообщения и создавайте свои команды прямо из 1С. Подходит для большинства типовых конфигураций.",
      },
      {
        name: "og:image",
        content:
          "https://raw.githubusercontent.com/KamranV21/1c-telegram-bot-management/refs/heads/main/readme-logo.png",
      },
      {
        name: "og:url",
        content: "https://kamranv21.github.io/1c-telegram-bot-management",
      },
    ],
    navbar: {
      title: "Управление ботами Telegram",
      logo: {
        alt: "Управление ботами Telegram",
        src: "img/logo.png",
      },
      items: [
        {
          type: "docSidebar",
          sidebarId: "tutorialSidebar",
          position: "left",
          label: "Документация",
        },
        {
          type: "dropdown",
          label: "Маркетплейс",
          position: "left",
          items: [
            {
              label: "Поиск скриптов",
              to: "/scripts/search",
            },
            {
              label: "Мои скрипты",
              to: "/scripts",
            },
          ],
        },
        {
          href: "https://github.com/KamranV21/1c-telegram-bot-management",
          label: "GitHub",
          position: "right",
        },
        {
          type: "localeDropdown",
          position: "right",
        },
        {
          type: "docsVersionDropdown",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Документация",
          items: [
            {
              label: "Руководство пользователя",
              to: "/docs/intro",
            },
          ],
        },
        {
          title: "Обратная связь",
          items: [
            {
              label: "Infostart",
              href: "https://infostart.ru/profile/671471/",
            },
            {
              label: "Предложить идею",
              href: "https://github.com/KamranV21/1c-telegram-bot-management/issues/new?template=%D0%BF%D1%80%D0%B5%D0%B4%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5.md",
            },
            {
              label: "Сообщить об ошибке",
              href: "https://github.com/KamranV21/1c-telegram-bot-management/issues/new?template=%D0%BE%D1%82%D1%87%D0%B5%D1%82-%D0%BE%D0%B1-%D0%BE%D1%88%D0%B8%D0%B1%D0%BA%D0%B5.md",
            },
          ],
        },
        {
          title: "Еще",
          items: [
            {
              label: "GitHub",
              href: "https://github.com/KamranV21/1c-telegram-bot-management",
            },
          ],
        },
      ],
      copyright: `Сделано с 💓| ${new Date().getFullYear()}`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
      additionalLanguages: ["bsl"],
    },
  } satisfies Preset.ThemeConfig,
};

export default config;
