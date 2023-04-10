import { build } from "esbuild";

await build({
  entryPoints: ["src/getStockOfferings.ts"],
  external: ["@aws-sdk/*"],
  bundle: true,
  minify: true,
  platform: "node",
  target: "node18",
  outdir: "build",
});
