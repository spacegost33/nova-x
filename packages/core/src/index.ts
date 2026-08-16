// NOVA-X Core – The Brain
// Decision making + planning engine (Day 5 – first real version)

export const CORE_VERSION = "0.0.2";

export interface ThinkInput {
  message: string;
}

export interface ThinkOutput {
  understanding: string;
  suggestion: string;
  nextAction: string;
  confidence: number;
}

export class NovaCore {
  think(input: ThinkInput): ThinkOutput {
    const message = input.message.toLowerCase().trim();

    // Very basic understanding for now
    if (message.includes("tired") || message.includes("exhausted") || message.includes("sleep")) {
      return {
        understanding: "You seem tired or low on energy.",
        suggestion: "Consider taking a short break or resting soon.",
        nextAction: "Rest or do a light activity for 15-20 minutes.",
        confidence: 0.85,
      };
    }

    if (message.includes("study") || message.includes("exam") || message.includes("learn")) {
      return {
        understanding: "You are focused on studying or learning.",
        suggestion: "Break your study into small focused sessions.",
        nextAction: "Start a 25-minute focused study session (Pomodoro).",
        confidence: 0.8,
      };
    }

    if (message.includes("stress") || message.includes("anxious") || message.includes("worried")) {
      return {
        understanding: "You appear to be feeling stressed or anxious.",
        suggestion: "Try a short breathing exercise or write down what's on your mind.",
        nextAction: "Take 5 deep breaths or journal for 5 minutes.",
        confidence: 0.82,
      };
    }

    if (message.includes("bored") || message.includes("nothing to do")) {
      return {
        understanding: "You seem bored or lacking direction right now.",
        suggestion: "Pick one small meaningful task to regain momentum.",
        nextAction: "Choose one small task and start it for just 10 minutes.",
        confidence: 0.75,
      };
    }

    // Default response
    return {
      understanding: "I received your message and I'm learning about your current state.",
      suggestion: "Tell me more about how you're feeling or what you're working on.",
      nextAction: "Share more context so I can give better guidance.",
      confidence: 0.5,
    };
  }
}

// Helper function
export function createCore() {
  return new NovaCore();
}
