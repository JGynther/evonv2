import {
  SSOOIDCClient,
  RegisterClientCommand,
  StartDeviceAuthorizationCommand,
  CreateTokenCommand,
} from "@aws-sdk/client-sso-oidc";

import type {
  RegisterClientCommandOutput,
  StartDeviceAuthorizationCommandOutput,
} from "@aws-sdk/client-sso-oidc";

const client = new SSOOIDCClient({ region: "eu-north-1" });

async function registerClient(name: string) {
  const command = new RegisterClientCommand({
    clientName: name,
    clientType: "public",
  });

  return await client.send(command);
}

async function authorizeDevice(clientInfo: RegisterClientCommandOutput) {
  const { clientId, clientSecret } = clientInfo;

  const command = new StartDeviceAuthorizationCommand({
    clientId,
    clientSecret,
    startUrl: process.env.URL,
  });

  return await client.send(command);
}

async function createToken(
  clientInfo: RegisterClientCommandOutput,
  authorizationInfo: StartDeviceAuthorizationCommandOutput,
) {
  const { clientId, clientSecret } = clientInfo;
  const { deviceCode } = authorizationInfo;

  const command = new CreateTokenCommand({
    clientId,
    clientSecret,
    deviceCode,
    grantType: "urn:ietf:params:oauth:grant-type:device_code",
  });

  return await client.send(command);
}

export { registerClient, authorizeDevice, createToken };
