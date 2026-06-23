from openai import OpenAI

client = OpenAI(
    api_key="your-casedesk-api-key",
    base_url="https://your-endpoint.getcasedesk.com/v1",
)

stream = client.chat.completions.create(
    model="deepseek-r1:7b",
    messages=[
        {"role": "user", "content": "Write a Python function to parse JSON."}
    ],
    stream=True,
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="", flush=True)
