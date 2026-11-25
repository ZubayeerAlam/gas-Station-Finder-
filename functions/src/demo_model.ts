/**
 * Offline demo model for the Firebase emulator, used ONLY when no
 * ANTHROPIC_API_KEY is configured. It is a tiny scripted stand-in that speaks
 * the same tool-use protocol so the app's chat flow can be exercised end to
 * end without Claude. Every reply is labelled as a demo; it is not Claude and
 * never pretends to be.
 */
import type Anthropic from '@anthropic-ai/sdk';
import type { ModelClient } from './assistant';

let counter = 0;
const id = () => `toolu_demo_${Date.now().toString(36)}${(counter++).toString(36)}`;

function message(content: Anthropic.ContentBlock[], stop: Anthropic.StopReason): Anthropic.Message {
  return {
    id: `msg_demo_${id()}`,
    type: 'message',
    role: 'assistant',
    model: 'offline-demo',
    content,
    stop_reason: stop,
    stop_sequence: null,
    usage: { input_tokens: 0, output_tokens: 0 },
  } as unknown as Anthropic.Message;
}

// Every response carries `demo: true`; the app labels it "Offline demo — not Claude".
const text = (t: string): Anthropic.ContentBlock => ({ type: 'text', text: t, citations: null } as Anthropic.ContentBlock);
const toolUse = (name: string, input: unknown): Anthropic.ContentBlock =>
  ({ type: 'tool_use', id: id(), name, input } as Anthropic.ContentBlock);

/** "to Potsdam", "nach Potsdam", "towards X" → destination. */
export function demoDestination(s: string): string | null {
  const m = /\b(?:to|towards|nach)\s+(.+?)[?.!]*$/i.exec(s.trim());
  return m ? m[1].trim() : null;
}

function toolResults(m: Anthropic.MessageParam | undefined): Anthropic.ToolResultBlockParam[] {
  if (!m || m.role !== 'user' || typeof m.content === 'string') return [];
  return m.content.filter((b): b is Anthropic.ToolResultBlockParam => b.type === 'tool_result');
}

function toolName(messages: Anthropic.MessageParam[], toolUseId: string): string | undefined {
  for (const m of messages) {
    if (m.role !== 'assistant' || typeof m.content === 'string') continue;
    for (const b of m.content) if (b.type === 'tool_use' && b.id === toolUseId) return b.name;
  }
  return undefined;
}

interface PlanStation { id: string; name?: string; total_cost?: string; detour?: string }

export const demoModel: ModelClient = {
  demo: true,
  async create(params) {
    const messages = params.messages;
    const last = messages[messages.length - 1];
    if (last.role === 'user' && typeof last.content === 'string') {
      const dest = demoDestination(last.content);
      if (!dest) {
        return message([text('Ask me something like "Where should I fill up on my way to Potsdam?" ' +
          'and I will rank stops along the route with the app\'s cost engine.')], 'end_turn');
      }
      return message([text(`Planning stops on the way to ${dest}…`),
        toolUse('plan_route_stops', { destination: dest, strategy: 'cheapest_total' })], 'tool_use');
    }
    const results = toolResults(last);
    const first = results[0];
    const name = first ? toolName(messages, first.tool_use_id) : undefined;
    if (name === 'plan_route_stops') {
      if (first.is_error) return message([text('I could not plan that route in the app.')], 'end_turn');
      const out = JSON.parse(String(first.content)) as { stations?: PlanStation[] };
      const top = (out.stations ?? []).slice(0, 3);
      if (!top.length) return message([text('No stations with a known price were found along that route.')], 'end_turn');
      return message([toolUse('show_station_cards', { station_ids: top.map((s) => s.id) })], 'tool_use');
    }
    if (name === 'show_station_cards') {
      // Find the plan result to summarise the best stop.
      for (let i = messages.length - 1; i >= 0; i--) {
        for (const r of toolResults(messages[i])) {
          if (toolName(messages, r.tool_use_id) !== 'plan_route_stops') continue;
          const best = (JSON.parse(String(r.content)) as { stations?: PlanStation[] }).stations?.[0];
          if (best) {
            return message([text(`Cheapest total cost on that route: ${best.name ?? best.id}` +
              (best.total_cost ? ` (${best.total_cost}` + (best.detour ? `, detour ${best.detour})` : ')') : '') +
              '. The cards below are ranked by the app.')], 'end_turn');
          }
        }
      }
    }
    return message([text('Done.')], 'end_turn');
  },
};
