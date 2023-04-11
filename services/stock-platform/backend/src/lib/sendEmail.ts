import { InvokeCommand, LambdaClient } from "@aws-sdk/client-lambda";

const client = new LambdaClient({ region: process.env.AWS_REGION });

const invoke = async (name: string, payload?: string) => {
  const command = new InvokeCommand({
    FunctionName: name,
    Payload: payload as any, // FIXME: no idea about this typing. String works.
  });

  const { Payload } = await client.send(command);
  if (!Payload) return;

  const result = JSON.parse(Buffer.from(Payload).toString());

  return result;
};

const sendSingleEmail = async (event: {
  email: string;
  subject: string;
  html?: string;
  text?: string;
}) => {
  const result = await invoke("sendSingleEmail", JSON.stringify(event));
  return result;
};

export { sendSingleEmail };
