const { Tool } = require('openclaw-sdk');

module.exports = class DeepSeekTool extends Tool {
  constructor() {
    super({
      name: 'deepseek',
      description: 'Call DeepSeek API for chat completions',
      parameters: {
        type: 'object',
        properties: {
          prompt: {
            type: 'string',
            description: 'The prompt to send to DeepSeek'
          }
        },
        required: ['prompt']
      }
    });
  }

  async execute({ prompt }, context) {
    try {
      const apiKey = process.env.DEEPSEEK_API_KEY;
      const apiUrl = process.env.DEEPSEEK_API_URL || 'https://api.deepseek.com/v1/chat/completions';

      if (!apiKey) {
        throw new Error('DEEPSEEK_API_KEY not set');
      }

      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
          model: 'deepseek-chat',
          messages: [
            { role: 'user', content: prompt }
          ],
          temperature: 0.7
        })
      });

      const data = await response.json();

      if (data.error) {
        throw new Error(data.error.message);
      }

      const reply = data.choices[0].message.content;

      return {
        success: true,
        message: reply,
        data: { prompt, response: reply }
      };
    } catch (error) {
      return {
        success: false,
        message: `DeepSeek error: ${error.message}`
      };
    }
  }
};
