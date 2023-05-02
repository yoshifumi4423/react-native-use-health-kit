module.exports = {
  env: {
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:@typescript-eslint/recommended',
    'prettier',
  ],

  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 'latest',
    sourceType: 'module',
  },

  plugins: ['react', '@typescript-eslint'],
  rules: {
    'quotes': [1, 'single', { avoidEscape: true }],
    'eqeqeq': [2, 'always'],
    'react/jsx-filename-extension': [
      2,
      { extensions: ['js', 'jsx', 'jsx', 'tsx'] },
    ],
  },
};
