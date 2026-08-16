
#!/bin/bash

echo "🚀 Starting NOVA-X Day 7 – Smarter Core"

cat > packages/core/src/index.ts << 'EOF'
// NOVA-X Core – The Brain
// Day 7: Smarter & more natural responses

export const CORE_VERSION = "0.0.3";

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
    const raw = input.message.trim();
    const message = raw.toLowerCase();

    // Helper to detect multiple signals
    const has = (...words: string[]) => words.some((w) => message.includes(w));

    // 1. Tired / Low energy
    if (has("tired", "exhausted", "sleepy", "no energy", "drained", "burned out", "burnt out")) {
      return {
        understanding: "You're running low on energy right now.",
        suggestion: "Pushing harder usually makes it worse. Your mind and body need a short recovery.",
        nextAction: "Take a 15–20 minute break. Lie down or just sit quietly without your phone.",
        confidence: 0.88,
      };
    }

    // 2. Study / Exam pressure
    if (has("study", "exam", "test", "assignment", "homework", " ent", "learn", "revision")) {
      return {
        understanding: "You're in study or exam mode.",
        suggestion: "Long study sessions without structure usually lead to low retention and stress.",
        nextAction: "Start one focused 25-minute session on the most important topic. Then take a 5-minute break.",
        confidence: 0.86,
      };
    }

    // 3. Stress / Anxiety
    if (has("stress", "stressed", "anxious", "anxiety", "worried", "overwhelmed", "panic", "nervous")) {
      return {
        understanding: "You're carrying mental pressure right now.",
        suggestion: "When the mind is overloaded, the best first step is to reduce the noise, not solve everything at once.",
        nextAction: "Write down the top 3 things on your mind. Then pick only one to focus on for the next hour.",
        confidence: 0.84,
      };
    }

    // 4. Boredom / No direction
    if (has("bored", "boring", "nothing to do", "empty", "lost", "no motivation", "don't know what to do")) {
      return {
        understanding: "You're feeling directionless or under-stimulated.",
        suggestion: "Boredom often means your brain is ready for something meaningful but small.",
        nextAction: "Choose one small task you've been avoiding and do it for just 10 minutes.",
        confidence: 0.81,
      };
    }

    // 5. Sad / Low mood
    if (has("sad", "depressed", "down", "unhappy", "lonely", "cry", "crying", "empty inside")) {
      return {
        understanding: "You're going through a low emotional state.",
        suggestion: "You don't need to fix everything right now. Small gentle actions help more than forcing positivity.",
        nextAction: "Do one kind thing for yourself in the next 30 minutes (walk, music, water, or message someone safe).",
        confidence: 0.83,
      };
    }

    // 6. Motivation / Want to improve
    if (has("motivate", "motivation", "improve", "better", "grow", "discipline", "focus", "productive")) {
      return {
        understanding: "You want to raise your standards and become more consistent.",
        suggestion: "Motivation is unreliable. Systems and small wins create real progress.",
        nextAction: "Pick one important area of your life and define the smallest daily action you can repeat.",
        confidence: 0.8,
      };
    }

    // 7. Greeting / Light messages
    if (has("hi", "hello", "hey", "good morning", "good night", "what's up", "how are you")) {
      return {
        understanding: "You're checking in.",
        suggestion: "I'm here to help you gain clarity on what to do next.",
        nextAction: "Tell me how you're feeling or what you're currently dealing with.",
        confidence: 0.7,
      };
    }

    // Default – when we don't strongly understand
    return {
      understanding: "I'm still learning your current context.",
      suggestion: "The more specific you are about how you feel or what you're facing, the better I can guide you.",
      nextAction: "Try sharing one clear feeling or situation (example: 'I have an exam in 3 days and I'm anxious').",
      confidence: 0.45,
    };
  }
}

export function createCore() {
  return new NovaCore();
}
EOF

# Update API version message
sed -i 's/0.0.2/0.0.3/g' apps/api/src/index.ts

echo ""
echo "✅ Day 7 Core updated to v0.0.3"
echo ""
echo "Now run:"
echo "pnpm install"
echo "git add ."
echo "git commit -m \"Day 7: Smarter and more natural Core responses\""
echo "git push origin main"

