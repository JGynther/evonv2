import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });

const handler = async (event: APIGatewayProxyEventV2): Promise<APIGatewayProxyResultV2> => {
  const id = event.rawPath.slice(1); // Remove first '/' from path

  const params = {
    TableName: process.env.TABLE,
    Key: {
      shortid: { S: id },
    },
  };

  const command = new GetItemCommand(params);
  const result = await client.send(command);

  return {
    statusCode: 302,
    headers: {
      location: result.Item?.url.S || (process.env.DEFAULT_URL as string),
    },
  };
};

export { handler };
