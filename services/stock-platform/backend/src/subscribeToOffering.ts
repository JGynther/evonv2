import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import { randomUUID } from "crypto";
import { sendSingleEmail } from "./lib/sendEmail";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const ddb = DynamoDBDocument.from(client);

type SubscribeEvent = {
  id: string;
  email: string;
  count: number;
  subscriber: Record<string, any>;
  isTest?: boolean;
};

const createError = (code: number = 200, message?: string) => {
  return {
    statusCode: code,
    body: JSON.stringify({ message }),
  };
};

const ddbGetItem = async (
  Key: Record<string, any>,
  TableName: string,
  client: DynamoDBDocument,
) => {
  const result = await client.get({ TableName, Key });
  return result.Item;
};

const ddbPutItemNoReplace = async (
  Item: Record<string, any>,
  TableName: string,
  client: DynamoDBDocument,
) => {
  await client.put({
    Item,
    TableName,
    // Prevents replacement on duplicate entry
    ConditionExpression: "attribute_not_exists(id) AND attribute_not_exists(email)",
  });
};

const createConfirmationEmail = (
  id: string,
  email: string,
  otp: string,
  subscriber: Record<string, any>,
  count: number,
  sum: number,
) => {
  return `
    <html>
      <head>
        <meta name="viewport" content="width=device-width" />
        <meta http-equiv="Content-Type" content="text/html" charset=UTF-8" />
      </head>
      <body> 
        <p>Olemme vastaanottaneet merkintäsi Evon Capital Oy Ab:n osakeannissa. Merkintäsi vaatii vielä vahvistuksen.</p>
        <p>Vahvista merkintäsi oheisen linkin kautta: </p>
        <a href="https://osakeanti.evon.fi/confirm/${id}/${email}::${otp}">Vahvista merkintä</a>
        <br>
        <br>
        <h3>Merkkinnän tiedot</h3>
        <ul>
          <p>${subscriber.firstName} ${subscriber?.middleNames} ${subscriber.lastName}</p>
          <p>${email}</p>
          <p>${subscriber.birthDate}</p>
          <p>${subscriber.address.street}</p>
          <p>${subscriber.address.postalCode}, ${subscriber.address.city}</p>
          <p>Osakkeita ${count} kappaletta</p>
          <p>Maksettavaa yhteensä ${sum} EUR</p>
        </ul>
        <br>
        <h3>Maksuohjeet</h3>
        <h4>Saaja</h4>
        <ul>
          <p>Evon Capital Oy Ab</p>
          <p>Rauhankatu 2F 69, 13100, HÄMEENLINNA, FINLAND</p>
          <p>Y-tunnus: 3094125-8</p>
        </ul>
        <h4>Maksutiedot</h4>
        <ul>
          <p>Pankki: OP</p>
          <p>BIC: OKOYFIHH</p>
          <p>IBAN: FI06 5720 1020 5628 52</p>
          <p>Eräpäivä: 4.8.2023</p>
          <p>Viesti: ${subscriber.firstName} ${subscriber.lastName}</p>
          <p>Maksettava: ${sum} EUR</p>
        </ul>
        <br>
        <p>Ystävällisin terveisin,</p>
        <p> Evon Capitalin tiimi</p>
      </body>
    </html>
  `;
};

const handler = async (event: APIGatewayProxyEventV2) => {
  if (!event.body) return createError(400, "Invalid request.");

  const body = JSON.parse(event.body);
  const { id, email, count, subscriber, isTest } = body as SubscribeEvent;

  if (!id || !email || !count || !subscriber) return createError(400, "Invalid request.");

  const config = await ddbGetItem({ id }, process.env.CONFIG as string, ddb);
  if (!config) return createError(400, "Invalid request.");

  const otp = randomUUID();
  const sum = (config?.price * count).toFixed(2);

  const subscribe = {
    id: config.id,
    timestamp: event.requestContext.timeEpoch,
    state: "pending",
    sum,
    otp,
    email,
    count,
    subscriber,
  };

  try {
    await ddbPutItemNoReplace(subscribe, process.env.TABLE as string, ddb);
  } catch (error) {
    return createError(400, "Error subscribing to offer.");
  }

  if (isTest) return { statusCode: 200, body: JSON.stringify({ message: "Test ok." }) };

  try {
    await sendSingleEmail({
      email: email,
      subject: "Evon Capital Oy Ab - Osakeannin merkintä",
      html: createConfirmationEmail(config.id, email, otp, subscriber, count, sum),
    });
  } catch (error) {
    return createError(400, "Confirmation email send failed.");
  }

  return { statusCode: 200 };
};

export { handler };
