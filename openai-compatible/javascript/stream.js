import OpenAI from "openai";

const client = new OpenAI({
  apiKey: "your-casedesk-api-key",
  baseURL: "https://your-endpoint.getcasedesk.com/v1",
});

const stream = await client.chat.completions.create({
  model: "deepseek-r1:7b",
  messages: [{ role: "user", content: "Write a JavaScript function to parse JSON." }],
  stream: true,
});

for await (const chunk of stream) {
  process.stdout.write(chunk.choices[0]?.delta?.content ?? "");
}
