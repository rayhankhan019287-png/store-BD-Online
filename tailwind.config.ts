import type { Config } from "tailwindcss";
const config: Config = { content: ["./src/**/*.{js,ts,jsx,tsx,mdx}"], theme: { extend: { colors: { brand: { red: "#ed1c24", ink: "#101014", gold: "#ffc928" } }, boxShadow: { soft: "0 18px 55px rgba(20,20,30,.08)" } } }, plugins: [] };
export default config;
