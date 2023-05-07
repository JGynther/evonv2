import { build } from "esbuild";

await build({
  entryPoints: [
    "src/authorizeDevice.ts",
    "src/createToken.ts",
    "src/registerClient.ts",
    "src/getRoleCredentials.ts",
  ],
  external: ["@aws-sdk/*"],
  bundle: true,
  minify: true,
  platform: "node",
  target: "node18",
  outdir: "build",
});
