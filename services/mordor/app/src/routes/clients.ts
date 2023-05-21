import { derived } from "svelte/store";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import { PUBLIC_AWS_REGION } from "$env/static/public";
import { auth } from "./store";

export const client = derived(auth, ($auth) => {
  if (!$auth) return undefined;

  const temp = new DynamoDBClient({
    region: PUBLIC_AWS_REGION,
    credentials: $auth.roleCredentials,
  });

  return DynamoDBDocument.from(temp);
});
