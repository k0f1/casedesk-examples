from openai import OpenAI

client = OpenAI(
    api_key="your-casedesk-api-key",
    base_url="https://your-endpoint.getcasedesk.com/v1",
)

response = client.chat.completions.create(
    model="deepseek-r1:7b",
    messages=[
        {"role": "user", "content": "Explain Kubernetes in one paragraph."}
    ],
)

print(response.choices[0].message.content)
