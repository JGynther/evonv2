import { test } from "vitest";
import type { CreateTokenCommandOutput } from "@aws-sdk/client-sso-oidc";

import { handler as registerClient } from "../src/registerClient";
import { handler as authorizeDevice } from "../src/authorizeDevice";
import { handler as createToken } from "../src/createToken";
import { handler as getRoleCredentials } from "../src/getRoleCredentials";

const sleep = (ms: number) => new Promise((res) => setTimeout(res, ms));
const wrap = (payload) => {
  return {
    body: JSON.stringify(payload),
  } as any;
};

test("getRoleCredentials full logic", async () => {
  const client = await registerClient();

  const authorizationInfo = await authorizeDevice(wrap({ ...client }));
  console.log(authorizationInfo.verificationUriComplete);

  let token: undefined | CreateTokenCommandOutput;
  while (!token) {
    try {
      const temp = await createToken(wrap({ clientInfo: client, authorizationInfo }));
      if (temp.$metadata.httpStatusCode === 200) token = temp;
    } catch {}

    await sleep(5000);
  }

  const result = await getRoleCredentials(wrap({ token: token.accessToken as string }));
  return result;
}, 40000);
