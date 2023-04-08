import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const ddb = DynamoDBDocument.from(client);

const ddbDoFullScan = async (table: string, client: DynamoDBDocument) => {
  const result = await client.scan({ TableName: table });
  return result.Items || [];
};

const handler = async (event?: APIGatewayProxyEventV2) => {
  return await ddbDoFullScan(process.env.TABLE as string, ddb);
};

export { handler };
