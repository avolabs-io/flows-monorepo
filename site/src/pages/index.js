import React from "react";
import clsx from "clsx";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import useBaseUrl from "@docusaurus/useBaseUrl";
import styles from "./styles.module.css";
import FAQs from "../components/FAQs/faqs";

const features = [
  {
    title: "Continuous payments",
    imageUrl: "img/illustrations/features/square.svg",
    description: (
      <>
        Periodic payments are inefficient, require trust and are ultimately
        random.
      </>
    ),
  },
  {
    title: "Real-time finance",
    imageUrl: "img/illustrations/features/hour-glass.svg",
    description: (
      <>
        The possibilities of value transfer in real time opens a whole new world
        of finance.
      </>
    ),
  },
  {
    title: "Privacy preserving",
    imageUrl: "img/illustrations/features/rect.svg",
    description: (
      <>
        Flows Finance allows for private transfers without the need to trust
        other parties.
      </>
    ),
  },
];

function Feature({ imageUrl, title, description }) {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className={clsx("col col--4 text--center", styles.feature)}>
      {imgUrl && (
        <div className="text--center">
          <img className={styles.featureImage} src={imgUrl} alt={title} />
        </div>
      )}
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
}

function Home() {
  const context = useDocusaurusContext();
  const { siteConfig = {} } = context;
  return (
    <Layout
      title={`Flows Finance | ${siteConfig.title}`}
      description="Privacy Preserving Continuous Payment Streams"
    >
      <header
        className={clsx("hero moving-background-gradient", styles.heroBanner)}
      >
        <div className="container">
          <h1 className="hero__title">{siteConfig.title}</h1>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className={clsx(
                "fade-in",
                "button button--outline  button--lg",
                styles.getStarted
              )}
              to={useBaseUrl("docs/")}
            >
              Read more
            </Link>
          </div>
        </div>
      </header>
      <main>
        {features && features.length > 0 && (
          <section className={styles.features}>
            <div className="container">
              <div className="row">
                {features.map((props, idx) => (
                  <Feature key={idx} {...props} />
                ))}
              </div>
            </div>
          </section>
        )}
        <div
          className="container-fluid hero moving-background-gradient"
          id="raiden-container"
        >
          <div className={clsx("col col--12", styles.raiden)}>
            <div className="text--center fade-in">
              <img
                className={styles.featureImage}
                src="img/illustrations/raiden-network.svg"
                alt="raiden"
              />
              <h3>Powered by the Raiden network</h3>
              <p>
                Flows Finance is built on the{" "}
                <a
                  className={styles.link}
                  href="https://raiden.network"
                  rel="noopenner noreferrer"
                  target="_blank"
                >
                  Raiden Network
                </a>
                , allowing for lightening fast, low cost transactions
              </p>
            </div>
          </div>
        </div>
        <div className="container">
          <div className="row">
            <div className={clsx("col col--12")}>
              <FAQs />
            </div>
          </div>
        </div>
      </main>
    </Layout>
  );
}

export default Home;
