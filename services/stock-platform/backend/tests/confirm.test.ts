import { expect, test } from "vitest";
import { handler } from "../src/confirmSubscribeEvent";
import { APIGatewayProxyEventV2 } from "aws-lambda";

// Set temporary table names for testing
// These are expected by the function
process.env.TABLE = "stock-subscriptions";

const baseMockAPIGWProxyEvent = {} as APIGatewayProxyEventV2;

test("Succesfull confirm event", async () => {
  const event = {
    ...baseMockAPIGWProxyEvent,
    body: JSON.stringify({
      id: "esimerkki-1",
      email: "joona@gynther.xyz",
      otp: "14f00fad-9895-49e9-a953-1fe0cd7fa658",
    }),
  };

  expect(await handler(event)).toMatchObject({ statusCode: 200 });
});
