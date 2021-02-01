const { override, addBabelPlugins, addBabelPreset } = require("customize-cra");

module.exports = override(
  addBabelPreset("@babel/preset-typescript"),
  addBabelPlugins(
    "@babel/plugin-proposal-nullish-coalescing-operator",
    "@babel/plugin-syntax-optional-chaining",
    "@babel/plugin-proposal-optional-chaining"
  )
);
