import { test } from "vitest";
import { authorizeDevice, createToken, getRoleCredentials, registerClient } from "../src/lib/sso";
import type { CreateTokenCommandOutput } from "@aws-sdk/client-sso-oidc";

const sleep = (ms: number) => new Promise((res) => setTimeout(res, ms));

test("getRoleCredentials full logic", async () => {
  const client = await registerClient("dgugfuiagduifuiaddgasdgagdgfiuadguifgis");

  const authorizationInfo = await authorizeDevice(client);
  console.log(authorizationInfo.verificationUriComplete);

  let token: undefined | CreateTokenCommandOutput;
  while (!token) {
    try {
      const temp = await createToken(client, authorizationInfo);
      token = temp;
    } catch {}

    await sleep(5000);
  }

  const result = await getRoleCredentials(token.accessToken as string);
  console.log(result);
  return;
}, 40000);
