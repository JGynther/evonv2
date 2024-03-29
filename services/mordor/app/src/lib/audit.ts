import type { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import { PUBLIC_AUDIT_TABLE } from "$env/static/public";
import { dev } from "$app/environment";

type AuditEvent = {
  eventName: string;
  resource?: string | Record<string, unknown>;
};

type AuditInterface = {
  event: (e: AuditEvent) => void;
};

type MordorUser = {
  UserId: string;
  Arn: string;
};

function createAuditer(
  client: DynamoDBDocument,
  user: MordorUser
): AuditInterface {
  return {
    event: (event) => {
      if (dev) return console.log("[DEV] Audit: ", event);
      const { eventName, resource } = event;
      const { UserId, Arn } = user;
      client.put({
        Item: {
          eventId: crypto.randomUUID(),
          timestamp: Date.now(),
          resource: resource || "mordor",
          eventName,
          UserId,
          Arn,
        },
        TableName: PUBLIC_AUDIT_TABLE,
      });
    },
  };
}

export { createAuditer };
