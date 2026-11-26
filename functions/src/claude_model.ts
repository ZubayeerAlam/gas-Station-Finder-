/**
 * Optional Claude adapter. Not bound by default (FuelWise prefers the Gemini
 * free tier); kept so the provider can be switched without touching the
 * assistant loop. Needs ANTHROPIC_API_KEY bound on the function.
 */
import Anthropic from '@anthropic-ai/sdk';
import { CLAUDE_MODEL, ModelQuotaError, type ModelClient } from './assistant';

export function claudeModel(apiKey: string): ModelClient {
  const client = new Anthropic({ apiKey, timeout: 60_000, maxRetries: 1 });
  return {
    demo: false,
    modelId: CLAUDE_MODEL,
    async create(params) {
      try {
        return await client.messages.create({ ...params, model: CLAUDE_MODEL });
      } catch (e) {
        if (e instanceof Anthropic.RateLimitError) throw new ModelQuotaError();
        throw e;
      }
    },
  };
}
