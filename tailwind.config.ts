// tailwind.config.js
module.exports = {
  darkMode: 'media', // Enables automatic dark mode detection
  content: ['./app/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'Arial', 'sans-serif'],
      },
      colors: {
        teal: {
          400: '#76c7c0',
          500: '#63aea8',
          600: '#51948f',
        },
      },
    },
  },
  plugins: [],
};
