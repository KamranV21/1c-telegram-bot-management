import type { Timestamp } from "firebase/firestore";

export type ScriptRecord = {
  id: string;
  title: string;
  description: string;
  script: string;
  configs: string[];
  authorId: string;
  authorName: string;
  authorEmail: string;
  createdAt?: Timestamp;
  updatedAt?: Timestamp;
  likes?: string[];
};

export const CONFIGURATION_OPTIONS = [
  "1С:Управление торговлей",
  "1С:Бухгалтерия предприятия",
  "1С:Зарплата и управление персоналом",
  "1С:Комплексная автоматизация",
  "1С:ERP",
  "1С:Розница",
  "1С:УНФ",
  "1С:УХ",
];

export const normalizeSearchText = (value: string): string =>
  value.trim().toLowerCase();
