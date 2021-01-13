module.exports = {
  title: "Flows Finance",
  tagline: "Stream money privately",
  url: "https://flows.finance",
  baseUrl: "/",
  onBrokenLinks: "throw",
  onBrokenMarkdownLinks: "warn",
  favicon: "img/favicon/favicon.ico",
  organizationName: "avolabs-io",
  projectName: "Flows.finance",
  themeConfig: {
    navbar: {
      title: "Flows Finance",
      logo: {
        alt: "Flows Finance logo",
        src: "img/snake_temp.png",
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
          href: "#",
          label: "Discord",
          position: "right",
        },
        {
          href: "#",
          label: "Twitter",
          position: "right",
        },
        {
          href: "#",
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
              label: "Style Guide",
              to: "docs/",
            },
            {
              label: "Second Doc",
              to: "docs/doc2/",
            },
          ],
        },
        {
          title: "Community",
          items: [
            {
              label: "Discord",
              href: "https://discordapp.com/invite/flows_finance",
            },
            {
              label: "Twitter",
              href: "https://twitter.com/flows_finance",
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
