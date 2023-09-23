import { APIGatewayProxyEventV2, APIGatewayProxyResultV2 } from "aws-lambda";
import { DynamoDBClient, GetItemCommand } from "@aws-sdk/client-dynamodb";
import { unmarshall } from "@aws-sdk/util-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });

const handler = async (
  event: APIGatewayProxyEventV2
): Promise<APIGatewayProxyResultV2> => {
  const slug = event.pathParameters?.slug;

  if (slug === undefined) return { statusCode: 400 };

  const params = {
    TableName: process.env.TABLE,
    Key: {
      slug: { S: slug },
    },
  };

  const command = new GetItemCommand(params);
  const result = await client.send(command);

  if (result.Item === undefined) return { statusCode: 404 };

  return unmarshall(result.Item);
};

export { handler };
