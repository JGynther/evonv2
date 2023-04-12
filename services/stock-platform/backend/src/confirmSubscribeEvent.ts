import { APIGatewayProxyEventV2 } from "aws-lambda";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import { sendSingleEmail } from "./lib/sendEmail";
import { ddb, ddbGetItem } from "./lib/ddb";

type ConfirmationEvent = {
  id: string;
  email: string;
  otp: string;
};

const createError = (code: number = 200, message?: string) => {
  return {
    statusCode: code,
    body: JSON.stringify({ message }),
  };
};

const ddbUpdateItem = async (
  Key: Record<string, any>,
  TableName: string,
  client: DynamoDBDocument,
) => {
  await client.update({
    Key,
    TableName,
    UpdateExpression: "set #s = :confirmed, confirmedAt = :confirmedAt",
    ExpressionAttributeValues: { ":confirmed": "confirmed", ":confirmedAt": Date.now() },
    ExpressionAttributeNames: { "#s": "state" },
  });
};

const handler = async (event: APIGatewayProxyEventV2) => {
  if (!event.body) return createError(400, "Invalid request.");

  const body = JSON.parse(event.body);
  const { id, email, otp } = body as ConfirmationEvent;

  const subscribe = await ddbGetItem({ id, email }, process.env.TABLE as string, ddb);
  if (!subscribe) return createError(400, "Invalid request.");

  if (subscribe.otp !== otp) return createError(400, "Email confirmation failed.");
  // FIXME: update function to fail on already confirmed entry
  const result = await ddbUpdateItem({ id, email }, process.env.TABLE as string, ddb);

  try {
    await sendSingleEmail({
      email,
      subject: "Evon Capital Oy Ab - merkinnän vahvistus",
      text: `Olet onnistuneesti vahvistanut osakeannin merkintäsi.\nVahvistustunnus: ${otp}`,
    });
  } catch (error) {
    return createError(400, "Confirmation email send failed.");
  }

  return { statusCode: 200 };
};

export { handler };
