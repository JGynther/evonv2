import { expect, test } from "vitest";
import { handler } from "../src/subscribeToOffering";
import { APIGatewayProxyEventV2 } from "aws-lambda";
import { randomUUID } from "crypto";

// Set temporary table names for testing
// These are expected by the function
process.env.TABLE = "stock-subscriptions";
process.env.CONFIG = "stock-offerings";

const randomEmail = () => `${randomUUID()}@evon.fi`;

const baseMockAPIGWProxyEvent = {
  requestContext: {
    timeEpoch: Date.now(),
  },
} as APIGatewayProxyEventV2;

test("Succesful subscribe", async () => {
  const event = {
    ...baseMockAPIGWProxyEvent,
    body: JSON.stringify({
      id: "esimerkki-1",
      email: randomEmail(),
      count: 100,
      subscriber: {},
      isTest: true,
    }),
  };

  expect(await handler(event)).toMatchObject({ statusCode: 200 });
});

test("Failed subscribe, malformed request", async () => {
  const event = {
    ...baseMockAPIGWProxyEvent,
    body: JSON.stringify({
      email: randomEmail(),
      count: 100,
      subscriber: {},
      isTest: true,
    }),
  };

  expect(await handler(baseMockAPIGWProxyEvent)).toMatchObject({ statusCode: 400 });
  expect(await handler(event)).toMatchObject({ statusCode: 400 });
});
