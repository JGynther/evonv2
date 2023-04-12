import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const ddb = DynamoDBDocument.from(client);

const ddbGetItem = async (
  Key: Record<string, any>,
  TableName: string,
  client: DynamoDBDocument,
) => {
  const result = await client.get({ TableName, Key });
  return result.Item;
};

export { ddb, ddbGetItem };
