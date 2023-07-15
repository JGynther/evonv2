import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });

const handler = async (event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> => {
  const id = event.pathParameters?.id; // Remove first '/' from path

  if (id === undefined) return { statusCode: 400 };

  const params = {
    TableName: process.env.TABLE,
    Key: {
      id: { S: id },
    },
  };

  const command = new GetItemCommand(params);
  const result = await client.send(command);

  if (result.Item === undefined) return { statusCode: 404 };

  return result.Item;
};

export { handler };
