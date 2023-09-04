import { get, post } from "$lib/fetch";
import {
  STSClient,
  GetCallerIdentityCommand,
  type STSClientConfig,
} from "@aws-sdk/client-sts";
import { PUBLIC_AWS_REGION } from "$env/static/public";

const sleep = (ms: number) => new Promise((res) => setTimeout(res, ms));

async function getClientInfo() {
  const info = JSON.parse(localStorage.getItem("device") ?? "{}");
  const isExpired = Date.now() > info?.clientSecretExpiresAt * 1000; // clientSecretExpiresAt is in seconds, not milliseconds

  if (info?.clientId && !isExpired) return info;

  const result = await get("/auth/register");
  localStorage.setItem("device", JSON.stringify(result));

  return result;
}

async function authorizeDevice(clientInfo: any) {
  return await post("/auth/device", clientInfo);
}

function checkForLocalCredentials() {
  const localCredentials = JSON.parse(
    localStorage.getItem("credentials") ?? "{}"
  );
  const isExpired = Date.now() > localCredentials?.roleCredentials?.expiration;
  if (isExpired || !localCredentials?.roleCredentials) return false;
  return localCredentials;
}

async function getUserDetails(roleCredentials: any) {
  const sts = new STSClient({
    region: PUBLIC_AWS_REGION,
    credentials: roleCredentials,
  });

  return await sts.send(new GetCallerIdentityCommand({}));
}

async function getCredentials(clientInfo: any, authorizationInfo: any) {
  let token;
  let count = 0;

  while (!token && count < 10) {
    const result = await post("/auth/token", {
      clientInfo,
      authorizationInfo,
    });

    if (result.$metadata.httpStatusCode === 200) token = result;

    ++count;
    await sleep(1000);
  }

  const credentials = await post("/auth/credentials", {
    token: token.accessToken,
  });

  const User = await getUserDetails(credentials.roleCredentials);

  localStorage.setItem("credentials", JSON.stringify({ ...credentials, User }));
  return { ...credentials, User };
}

function logout() {
  localStorage.removeItem("credentials");
}

export {
  getClientInfo,
  authorizeDevice,
  getCredentials,
  checkForLocalCredentials,
  logout,
};
