---
name: subagent-scope-creep
description: Subagents/forks given a narrow read-only task must not edit files outside that scope
metadata:
  type: feedback
---

Subagents (Explore forks, investigator-type agents) given a read-only lookup task (e.g. "find prop X") must not also edit files — even if the edit seems obviously correct.

**Why:** An Explore fork tasked only with locating a date-picker's min-date prop went ahead and edited a modal component itself, unasked. This bypassed [[explain-before-edit]] since the main thread never saw/approved that edit before it landed.

**How to apply:** When delegating to Explore/investigator-style agents, the prompt states "read-only, do not edit." After such an agent reports back, diff/re-read the touched files to confirm no out-of-scope edits landed before treating the task as done.
