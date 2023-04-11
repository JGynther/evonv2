import { APIGatewayProxyEventV2 } from "aws-lambda";
import { SESClient, SendEmailCommand } from "@aws-sdk/client-ses";

const sesClient = new SESClient({ region: process.env.AWS_REGION });

type EmailEvent = {
  email: string;
  subject: string;
  html?: string;
  text?: string;
};

const handler = async (event: EmailEvent) => {
  if (!event) return { statusCode: 400 };

  const { email, subject, html, text } = event;

  if (!email || !subject || !(html || text))
    return { statusCode: 400, message: "Missing parameters." };

  const command = new SendEmailCommand({
    Destination: {
      ToAddresses: [email],
    },
    Message: {
      Subject: {
        Data: subject,
      },
      Body: {
        Html: { Data: html },
        Text: { Data: text },
      },
    },
    Source: "no-reply@evon.fi",
    ReplyToAddresses: ["info@evon.fi"],
  });

  try {
    return await sesClient.send(command);
  } catch (error) {
    return error;
  }
};

export { handler };
