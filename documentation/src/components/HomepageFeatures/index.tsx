import type { ReactNode } from "react";
import clsx from "clsx";
import useBaseUrl from "@docusaurus/useBaseUrl";
import Heading from "@theme/Heading";
import styles from "./styles.module.css";

type FeatureItem = {
  title: string;
  image: string;
  description: ReactNode;
};

const FeatureList: FeatureItem[] = [
  {
    title: "Простая установка",
    image: "img/play.png",
    description: (
      <>
        Не нужно вносить изменения в вашу конфигурацию 1С - просто подключите
        готовое расширение и начните пользоваться уже сейчас
      </>
    ),
  },
  {
    title: "Неограниченные возможности",
    image: "img/paper-plane.png",
    description: (
      <>
        Готовые инструменты помогут написать абсолютно любую логику работы
        вашего бота - от простой рассылки отчетов, до сложного поэтапного
        общения с пользователями
      </>
    ),
  },
  {
    title: "Экономия времени",
    image: "img/curious.png",
    description: (
      <>
        Сфокусируйтесь на главном. Всю рутину взаимодействия с Telegram
        расширение возьмет на себя.
      </>
    ),
  },
];

function Feature({ title, image, description }: FeatureItem) {
  return (
    <div className={clsx("col col--4")}>
      <div className="text--center">
        <img src={useBaseUrl(image)} className={styles.featureSvg} />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): ReactNode {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
