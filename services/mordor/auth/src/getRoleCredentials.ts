import type { APIGatewayProxyEventV2 } from "aws-lambda";
import { getRoleCredentials } from "./lib/sso";

const handler = async (event: APIGatewayProxyEventV2) => {
  if (!event.body) return;

  const { token } = JSON.parse(event.body);

  try {
    return await getRoleCredentials(token);
  } catch (error) {
    return error;
  }
};

export { handler };
