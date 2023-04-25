import {
  SSOOIDCClient,
  RegisterClientCommand,
  StartDeviceAuthorizationCommand,
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
    startUrl: "https://d-c36711cab6.awsapps.com/start/",
  });

  return await client.send(command);
}

export { registerClient, authorizeDevice };
