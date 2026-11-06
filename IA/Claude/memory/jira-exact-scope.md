---
name: jira-exact-scope
description: Jira writes - create/edit only the exact tickets named; ambiguous wording => ask before any Jira write
metadata:
  type: feedback
---

Create or edit only the Jira tickets the user explicitly named. If an instruction about which tickets to create or reuse can be read two ways, ask before writing anything to Jira.

**Why:** an instruction like "only create #1 and #2, reuse the existing ticket and create a new one for the other" was misread, and an extra ticket got created that the user had not asked for and had to close.

**How to apply:** Before any Jira create, edit or transition, restate which ticket keys will change and how. If the user said "only", nothing beyond that list. Related: [[no-remote-writes]].
