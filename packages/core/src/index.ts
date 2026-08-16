// NOVA-X Core – The Brain
// Week 2: Context-aware + Mood + Goals (TypeScript fixed)

export const CORE_VERSION = "0.1.0";

export interface Message {
  role: "user" | "assistant";
  content: string;
  timestamp?: string;
}

export interface ThinkInput {
  message: string;
  history?: Message[];
}

export interface ThinkOutput {
  understanding: string;
  suggestion: string;
  nextAction: string;
  confidence: number;
  detectedMood?: string;
  detectedGoal?: string | null;
  energyLevel?: "low" | "medium" | "high";
}

export class NovaCore {
  think(input: ThinkInput): ThinkOutput {
    const message = input.message.toLowerCase().trim();
    const history = input.history || [];

    const has = (...words: string[]) => words.some((w) => message.includes(w));

    // Detect mood
    let detectedMood = "neutral";
    let energyLevel: "low" | "medium" | "high" = "medium";

    if (has("tired", "exhausted", "drained", "sleepy", "burned out", "burnt out")) {
      detectedMood = "tired";
      energyLevel = "low";
    } else if (has("stress", "stressed", "anxious", "anxiety", "overwhelmed", "worried", "panic")) {
      detectedMood = "stressed";
      energyLevel = "low";
    } else if (has("sad", "depressed", "down", "lonely", "unhappy", "cry")) {
      detectedMood = "low";
      energyLevel = "low";
    } else if (has("bored", "boring", "nothing to do", "empty", "lost")) {
      detectedMood = "bored";
      energyLevel = "medium";
    } else if (has("motivated", "excited", "happy", "great", "awesome", "energized")) {
      detectedMood = "positive";
      energyLevel = "high";
    }

    // Detect goal (TypeScript safe)
    let detectedGoal: string | null = null;
    const goalMatch = input.message.match(
      /(?:i want to|i need to|i have to|my goal is to|i'm trying to)\s+(.+)/i
    );
    if (goalMatch && goalMatch[1]) {
      detectedGoal = goalMatch[1].trim();
    }

    // === RESPONSE LOGIC ===

    if (detectedGoal) {
      return {
        understanding: `You want to: "${detectedGoal}"`,
        suggestion: "Clear goals work best when broken into the next small physical action.",
        nextAction: `Define the very first 10-minute action for: ${detectedGoal}`,
        confidence: 0.87,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (detectedMood === "tired") {
      return {
        understanding: "Your energy is currently low.",
        suggestion: "Continuing to push usually reduces quality. Short recovery creates better output later.",
        nextAction: "Take a real 15–20 minute break away from screens.",
        confidence: 0.89,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (detectedMood === "stressed") {
      return {
        understanding: "You're carrying mental load right now.",
        suggestion: "When overwhelmed, the highest leverage move is reducing open loops, not doing more.",
        nextAction: "Write down the top 3 things on your mind, then choose only one to focus on.",
        confidence: 0.86,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (detectedMood === "low") {
      return {
        understanding: "You're in a low emotional state.",
        suggestion: "You don't need to solve everything. Small safe actions help stabilize first.",
        nextAction: "Do one gentle thing for yourself in the next 20 minutes (water, short walk, or music).",
        confidence: 0.84,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (detectedMood === "bored") {
      return {
        understanding: "You're under-stimulated or lacking direction.",
        suggestion: "Boredom is often a signal that you're ready for something meaningful but small.",
        nextAction: "Pick one small task you've been avoiding and do it for just 10 minutes.",
        confidence: 0.82,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (has("study", "exam", "test", "assignment", "homework", "work", "project", "deadline")) {
      return {
        understanding: "You're in performance or study mode.",
        suggestion: "Focus improves when the next action is clear and time-boxed.",
        nextAction: "Start one 25-minute focused session on the most important task.",
        confidence: 0.85,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (detectedMood === "positive") {
      return {
        understanding: "Your energy and mood are currently good.",
        suggestion: "This is a high-leverage window. Use it on something that matters.",
        nextAction: "Choose the most important task and start it while energy is high.",
        confidence: 0.8,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    if (history.length > 2) {
      return {
        understanding: "I'm tracking our recent conversation.",
        suggestion: "You can go deeper on how you're feeling or what you want to move forward on.",
        nextAction: "Share the main thing currently on your mind or a goal you care about.",
        confidence: 0.65,
        detectedMood,
        detectedGoal,
        energyLevel,
      };
    }

    return {
      understanding: "I'm ready to understand your current state.",
      suggestion: "The clearer you are about how you feel or what you want, the better I can guide you.",
      nextAction: "Tell me how you're feeling or what you're trying to do.",
      confidence: 0.5,
      detectedMood,
      detectedGoal,
      energyLevel,
    };
  }
}

export function createCore() {
  return new NovaCore();
}
