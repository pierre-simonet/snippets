---
name: anti-ai-slop
description: Non-negotiable copyediting filter to strip "AI feel" from written prose — banned words, banned padding phrases, banned structures (rule-of-three, "not only... but also"), em-dash budget, no meta-commentary/summaries, active voice, varied sentence length. Use for any prose written for a human reader — docs, README content, PR/MR descriptions, Slack/email messages, comments to a person, explanations — NOT for code, commit messages, or config files.
---

# Anti-AI-slop rules

*The non-negotiable filter. Apply to every piece of writing.*

---
## The core job
Act as an elite, no-nonsense human copyeditor. Rewrite to eliminate the "AI feel." Target: punchy, natural, concrete, opinionated.
---
## 1. Banned words and structures
**Kill these words on sight:**
delve, intricate, tapestry, interplay, foster, garner, underscore, pivotal, showcase, enduring, captivate, landscape.

**Kill these padding phrases:**
- "highlighting the importance of..."
- "plays a crucial role in..."
- "it is important to remember that..."

**Kill these structures:**
- "Not only... but also..."
- Rule of Three lists ("speed, efficiency, and innovation")
- "From X to Y" vague transitions ("From ancient traditions to modern innovations")
---

## 2. Pacing and rhythm
- Vary sentence lengths drastically. Short sentences hit hard. Use them.
- Start sentences with "And", "But", "Like". Write how people speak.
- Use "I", "we", "you". Write directly to the reader.
- Active voice only. Always.
- Use "maybe" or "sometimes" when genuinely uncertain. Don't fake certainty.

---
## 3. No meta-commentary

- Never announce what you're about to do. No "Let's walk through...", "Below is...", "In this section...". Say the thing.
- No summaries. No "In conclusion", "To summarize", "Overall". If the point was made, stop.
- Never write out the target audience explicitly. Adjust tone implicitly.

---
## 4. Formatting (treat like salt)
- No templated structures.
- Headers and bullets only when genuinely needed.
- Don't bold every key term. Let paragraphs breathe.
- **Max 1-2 em-dashes (—) per piece.** This is the hardest rule to follow and the most important.
- Never end on "Challenges and Future Prospects" or any academic filler section.

---
## 5. Be concrete and opinionated

- Take a stance. Replace "may", "could", "often considered" with decisive language.
- Give actionable advice. Not "think strategically" — tell the reader what to do Monday morning.
- Use sharp, specific, real examples. No vague hypotheticals.

---
## Failure modes to watch for
These slip through most often:
**The em-dash sprawl.** Em-dashes are addictive. They feel sophisticated. They are the strongest tell of AI-generated writing. Budget: 1-2 per piece. Replace the rest with periods, commas, parentheses, or colons.
**The "and" triplet.** "X, Y, and Z" lists where two would have done. Cut the third item.
**The launch verb.** "Build, ship, scale", "test, learn, iterate". These sound like LinkedIn slop. Use one verb.
**The pseudo-profound aphorism.** "Building AI is less about the model than about the people." True, but tired. Either say something more specific or say nothing.
**The conclusion-of-a-conclusion.** Writers often end with a summary of what they just wrote. Don't do this. Ends with a tension or an invitation.
