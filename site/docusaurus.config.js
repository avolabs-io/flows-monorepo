module.exports = {
  title: "Flows Finance",
  tagline: "Stream money privately",
  url: "https://dev.flows.finance",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/favicon/favicon.ico",
  organizationName: "avolabs-io",
  projectName: "Flows.finance",
  themeConfig: {
    googleAnalytics: {
      trackingID: "G-1GX3DX6KDG",
      // Optional fields.
      anonymizeIP: true, // Should IPs be anonymized?
    },
    navbar: {
      title: "Flows Finance",
      logo: {
        alt: "Flows Finance logo",
        src: "img/flows_finance_logo.svg",
      },
      items: [
        {
          to: "docs/",
          activeBasePath: "docs",
          label: "Docs",
          position: "left",
        },
        { to: "blog", label: "Blog", position: "left" },
        {
          href: "https://discord.gg/kcJ63expb8",
          label: "Discord",
          position: "right",
        },
        {
          href: "https://twitter.com/financeflows",
          label: "Twitter",
          position: "right",
        },
        {
          href: "https://github.com/avolabs-io/flows-monorepo",
          label: "GitHub",
          position: "right",
        },
      ],
    },
    footer: {
      style: "dark",
      links: [
        {
          title: "Docs",
          items: [
            {
              label: "Intro",
              to: "docs/",
            },
            {
              label: "Raiden Node",
              to: "docs/raiden-node/",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Discord",
              href: "https://discord.gg/kcJ63expb8",
            },
            {
              label: "Twitter",
              href: "https://twitter.com/financeflows",
            },
          ],
        },
        {
          title: "More",
          items: [
            {
              label: "Blog",
              to: "blog",
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Flows.Finance`,
    },
  },
  presets: [
    [
      "@docusaurus/preset-classic",
      {
        docs: {
          sidebarPath: require.resolve("./sidebars.js"),
          editUrl: "https://github.com/avolabs-io/flows-monorepo/",
        },
        blog: {
          showReadingTime: true,
          editUrl: "https://github.com/avolabs-io/flows-monorepo/",
        },
        theme: {
          customCss: require.resolve("./src/css/custom.css"),
        },
      },
    ],
  ],
};
