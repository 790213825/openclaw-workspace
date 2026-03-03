#!/bin/bash
# DeepSeek API 调用脚本
# 使用方法: ./deepseek-api.sh "你的问题"

DEEPSEEK_API_KEY="sk-5a66284565bf4df1ac31c25f34255e24"
DEEPSEEK_API_URL="https://api.deepseek.com/v1/chat/completions"

if [ -z "$1" ]; then
  echo "使用方法: $0 \"你的问题\""
  exit 1
fi

curl -s "${DEEPSEEK_API_URL}" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${DEEPSEEK_API_KEY}" \
  -d "{
    \"model\": \"deepseek-chat\",
    \"messages\": [
      {\"role\": \"user\", \"content\": \"$1\"}
    ],
    \"temperature\": 0.7
  }" | jq -r '.choices[0].message.content'
