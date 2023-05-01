import { createToken } from "./lib/sso";

import type {
  RegisterClientCommandOutput,
  StartDeviceAuthorizationCommandOutput,
} from "@aws-sdk/client-sso-oidc";
import type { APIGatewayProxyEventV2 } from "aws-lambda";

const handler = async (event: APIGatewayProxyEventV2) => {
  if (!event.body) return;

  const { clientInfo, authorizationInfo } = JSON.parse(event.body) as {
    clientInfo: RegisterClientCommandOutput;
    authorizationInfo: StartDeviceAuthorizationCommandOutput;
  };

  try {
    const response = await createToken(clientInfo, authorizationInfo);

    if (response.$metadata.httpStatusCode !== 200)
      throw Error("Device authorization start failed.");

    return response;
  } catch (error) {
    return error;
  }
};

export { handler };
