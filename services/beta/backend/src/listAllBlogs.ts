import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { DynamoDBClient, ScanCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });

const handler = async (event: APIGatewayProxyEventV2) => {
  const params = { TableName: process.env.TABLE };

  const command = new ScanCommand(params);
  const result = await client.send(command);

  return result.Items || [];
};

export { handler };
