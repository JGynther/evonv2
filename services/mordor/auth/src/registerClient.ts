import { registerClient } from "./lib/sso";
import { randomUUID } from "crypto";

const handler = async () => {
  const name = randomUUID();

  try {
    const response = await registerClient(name);

    if (response.$metadata.httpStatusCode !== 200) throw Error("Client registration failed.");

    return response;
  } catch (error) {
    return error;
  }
};

export { handler };
