module.exports = {
  purge: {
    content: [
      ".src/**/*.res"
    ],
    options: {
      safelist: ["html", "body"],
    },
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      // colors: {
      //   primary: "#064085", // these are float values, can add them back in once
      //   "light-purple": "#a6accd",
      // },
      // // Doesn't include an opacity gradient, rather use direct css
      // backgroundImage: (theme) => ({
      //   "float-pixels": "url('/backgrounds/2.png')",
      // }),
    },
    /* Most of the time we customize the font-sizes,
     so we added the Tailwind default values here for
     convenience */
    fontSize: {
      xxs: ".6rem",
      xs: ".75rem",
      sm: ".875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem",
      "5xl": "3rem",
      "6xl": "4rem",
      /// Below are custom sizes
      // "600px": "600px",
    },
    fontFamily: {
      sans: [
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      serif: [
        "Georgia",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      mono: [
        "Menlo",
        "Monaco",
        "Consolas",
        "Roboto Mono",
        "SFMono-Regular",
        "Segoe UI",
        "Courier",
        "monospace",
      ],
      default: ["menlo", "sans-serif"],
    },
  },
  variants: {
    width: ["responsive"],
  },
  plugins: [],
}
