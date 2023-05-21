import { authorizeDevice } from "./lib/sso";
import type { RegisterClientCommandOutput } from "@aws-sdk/client-sso-oidc";
import type { APIGatewayProxyEventV2 } from "aws-lambda";

const handler = async (event: APIGatewayProxyEventV2) => {
  // TODO: improve error handling
  if (!event.body) return;

  const clientInfo = JSON.parse(event.body) as RegisterClientCommandOutput;

  try {
    const response = await authorizeDevice(clientInfo);

    if (response.$metadata.httpStatusCode !== 200)
      throw Error("Device authorization start failed.");

    return response;
  } catch (error) {
    return error;
  }
};

export { handler };
