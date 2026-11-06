---
name: my-writing-style
description: Write in Pierre Simonet's own voice whenever drafting text he will post under his name - Slack messages (channel posts, thread replies, DMs, daily standup updates), Jira tickets (title, description) and Jira comments, GitLab merge request comments and review replies. Use when asked to draft, write, reply, answer, respond, rephrase or prepare a message/comment/ticket/standup ("rédige", "réponds", "écris un message", "fais-moi un ticket"), with no command needed, and also when another skill (mr-comment-fix, slack:draft-announcement, slack:slack-messaging, anti-ai-slop) produces such a draft - apply on top of it. Covers French and English, the register of each channel, and his systematic English and French error patterns. Not for code, commit messages, MR descriptions, docs, or explanations addressed to Pierre himself.
---

# Pierre's writing voice

Drafts must read as if Pierre typed them. The patterns live in [STYLE.md](STYLE.md). Read the section for the target channel before writing.

## Steps

1. **Pick the channel and the language.**
   - Slack DM to a French-speaking colleague: French. Slack DM to a non-French speaker, IT or support: English.
   - Slack channels, Jira, GitLab: English, unless the thread itself is in French.
2. **Read STYLE.md**: section 1 (fingerprint shared by every channel), then the section for the channel. For English, section 2 (systematic errors) too. For French, section 6.
3. **Write the content first** (facts, links, identifiers, asks), then apply the voice: length, opener, formatting, closer, then the systematic errors.
4. **Self-check** against the checklist at the end of the channel section.
5. **Show the draft. Never send or post it** without explicit approval (standing rule).

## Rules

- **Length: one sentence by default, two at most.** Applies to Slack replies, MR replies and comments, and Jira comments. Go longer only when Pierre asks, or for a Jira ticket description. He shortened drafts about 26 times in October.
- **Match the register to the channel. Do not flatten.**
  - GitLab reply on his own MR: terse status ("Fixed.", "It had been removed.").
  - GitLab review comment: hedged question with "we".
  - Jira: @mention plus status or stacked questions.
  - Slack squad channel: casual-professional English.
  - French DM: tu, "Re"/"Hello :wave:", franglais.
- **Reproduce only the systematic errors listed in STYLE.md, at their natural rate.**
  - Do not put every error in every message. A short reply usually carries zero or one.
  - The errors listed as one-off typos must never appear.
  - Never invent new typos.
- **Never inject an error** where it could change meaning or break something:
  - code identifiers, URLs, numbers, names, ticket keys, quoted text;
  - negations;
  - anything legal or contractual.
- **If Pierre asks for a clean, corrected or "proper English" version**, drop all errors and keep the rest of the voice.
- **Typography:**
  - Never use an em dash or an en dash.
  - Never use the U+2026 ellipsis character.
  - Use ASCII arrows `=>` and `->`.
  - No AI-isms ("Great point", "Happy to", "That said", "I hope this helps", "Let me know if you have any questions").
- **Session output modes do not apply to the drafted text.** Caveman or terse modes govern only Claude's chat around the draft, never the text Pierre will post.
- **When another skill also applies**, this skill decides the voice.
  - Keep its banned-words list from anti-ai-slop.
  - Ignore anti-ai-slop's "active voice only" and em-dash budget: Pierre's status lines are passive and he uses zero dashes.
- **Use real @mentions in drafts.** STYLE.md examples are anonymized: [colleague], [link], [provider], @x, @squad-devs, TICKET-XXXX, !XXXXX, and `[...]` for elided text. Never copy these placeholders into a draft.

## Freshness: do not stay frozen

STYLE.md was built on 2026-10-08 from Pierre's messages dated 2026-06-08 to 2026-10-08, at a previous job. Company-specific examples were replaced with neutral ones when it was exported. The grammar patterns (sections 2 and 6) carry over; the channel registers (sections 3 to 5) describe the old workplace. Flag it in one line and suggest a re-analysis (do not silently edit STYLE.md) when any of these is true:

- more than 3 months have passed since 2026-10-08, or Pierre has about 2 months of messages at the new job;
- Pierre edits drafts in the same direction twice or more, for example removing a listed error, adding a tic that isn't listed, or changing the greeting;
- his own recent messages visible in the conversation contradict STYLE.md;
- the draft relies on a pattern marked "drifting" in STYLE.md section 7, and his recent text suggests the drift has finished.

Suggested wording: "Your style may have moved since the 2026-10-08 analysis (<what>). Want me to re-run it?"

## Re-analysis recipe

Get Pierre's approval first; it reads all his messages.

1. **Collect only his own messages**, verbatim, into the session scratchpad. Never collect into this skill folder.
   - **Slack:** `slack_search_public_and_private` with `from:<@<slack-user-id>> after:<d> before:<d>`, one window per month, `response_format: detailed`, `include_context: false`, paginated to the end. Search needs an allow rule for that tool; auto mode blocks it otherwise.
   - **Jira:** `project in (<projects>) AND (reporter = currentUser() OR watcher = currentUser() OR assignee was currentUser())`, then `jira_get_issue` with `comment_limit: 100`. Keep comments by his accountId (`atlassianUserInfo`), and descriptions only where he is the reporter and nobody rewrote them.
   - **GitLab:** `glab api --paginate 'users/<gitlab-user-id>/events?action=commented&per_page=100'` (id from `glab api user`). On GitHub, use `gh search` for his PR comments. Keep `noteable_type == MergeRequest` and not `system`.
2. **Strip** `>` quotes, code blocks, logs, URLs, pasted text from others, and the Jira rendering artifacts (`_` shown as `*`, `User:<id>` mentions).
3. **Exclude AI-drafted items**: assistant phrasing, `→`, polished error-free paragraphs, pasted assistant text. Report the excluded share.
4. **Analyse each channel and language separately.** An error is "systematic" only if it appears in at least 3 different messages. Compare against STYLE.md and note what changed.
5. **Rewrite STYLE.md** with a new window and date. Update the dates in this section.
