import {
  SSOOIDCClient,
  RegisterClientCommand,
  StartDeviceAuthorizationCommand,
  CreateTokenCommand,
} from "@aws-sdk/client-sso-oidc";
import { SSOClient, GetRoleCredentialsCommand } from "@aws-sdk/client-sso";

import type {
  RegisterClientCommandOutput,
  StartDeviceAuthorizationCommandOutput,
} from "@aws-sdk/client-sso-oidc";

const client = new SSOOIDCClient({ region: process.env.AWS_REGION });
const clientSSO = new SSOClient({ region: process.env.AWS_REGION });

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
    startUrl: process.env.SSOURL,
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

async function getRoleCredentials(accessToken: string) {
  const command = new GetRoleCredentialsCommand({
    roleName: process.env.ROLE,
    accountId: process.env.ACCOUNTID,
    accessToken,
  });

  return await clientSSO.send(command);
}

export { registerClient, authorizeDevice, createToken, getRoleCredentials };
