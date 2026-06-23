import OpenAI from "openai";

const client = new OpenAI({
  apiKey: "your-casedesk-api-key",
  baseURL: "https://your-endpoint.getcasedesk.com/v1",
});

const response = await client.chat.completions.create({
  model: "deepseek-r1:7b",
  messages: [{ role: "user", content: "Explain Kubernetes in one paragraph." }],
});

console.log(response.choices[0].message.content);
