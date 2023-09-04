import { derived } from "svelte/store";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocument } from "@aws-sdk/lib-dynamodb";
import { STSClient, GetCallerIdentityCommand } from "@aws-sdk/client-sts";
import { PUBLIC_AWS_REGION } from "$env/static/public";
import { auth } from "./store";
import { createAuditer } from "$lib/audit";

export const client = derived(auth, ($auth) => {
  if (!$auth) return undefined;

  const temp = new DynamoDBClient({
    region: PUBLIC_AWS_REGION,
    credentials: $auth.roleCredentials,
  });

  return DynamoDBDocument.from(temp);
});

export const Audit = derived([auth, client], ([$auth, $client]) => {
  if (!$client || !$auth.User) return undefined;
  return createAuditer($client, $auth.User);
});
