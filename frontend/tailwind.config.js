const plugin = require("tailwindcss/plugin");

/** @type {import('tailwindcss').Config} */
module.exports = {
  mode: "jit",
  theme: {
    extend: {},
  },
  content: [
    "Web/View/**/*.hs",
    "Application/Helper/**/*.hs",
    "frontend/**/*.jsx",
  ],
  safelist: [
    // Add custom class names.
    // https://tailwindcss.com/docs/content-configuration#safelisting-classes
  ],
  plugins: [require("@tailwindcss/forms")],
};
