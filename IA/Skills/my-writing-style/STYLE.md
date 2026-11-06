# Pierre's style reference

- Analysed on 2026-10-08, from messages dated 2026-06-08 to 2026-10-08.
- Corpus: 930 Slack messages (515 channel, 413 DM), 136 Jira items (19 descriptions, 117 comments), 469 GitLab MR comments.
- Excluded from the patterns:
  - quoted text, code, logs and links;
  - Jira rendering artifacts;
  - 6 Jira descriptions rewritten by the PM;
  - text drafted by Claude or that reads AI-polished: about 5% of GitLab, 5-8% of Jira comments, about half of Jira descriptions, about 2% of Slack channel messages, about 0% of DMs.

Examples are verbatim, keeping the errors on purpose. The only changes are anonymization (names are replaced with [colleague], tickets with TICKET-XXXX, MRs with !XXXXX, links with [link]), straight quotes, and the removal of retired habits (French spacing before "?") and one-off typos. Examples naming the previous company's systems or business terms were replaced with neutral placeholders (Foo, Bar, <feature>) on export.

Frequency words: **always** (no counter-example), **usually** (more than 70%), **often** (40 to 70%), **sometimes** (15 to 40%), **rare** (under 15%, use at most once in a long text).

---

## 1. Fingerprint shared by every channel

- **No em dash, no en dash, no `…` character, ever.** Arrows are ASCII: `=>` for a result or answer, `->` for a flow or rename.
  - Jira's editor turns a typed `->` into `→`. GitLab's rich editor escapes it as `=\>`. In drafts, write plain `=>` / `->`.
- **An emoji replaces the final period.** It goes after a space at the end of the line, with no period before it.
  - `:pray:`: request.
  - `:thumbsup:`: done or agreed.
  - `:thinking:` / `:thinking_face:`: doubt.
  - `:confused:`: own trouble or fault.
  - `:arrow_up:` / `:arrow_down:`: see above or below.
  - `:wave:`: greeting.
- **No sign-off, no signature, no "Regards", no "Cheers".** The message ends on the request, the question or the status.
- **Thanks are rare in GitLab, Jira and Slack channels.** Politeness comes from `:pray:` and a hedged question. English DMs are the exception: there, acks often end with "thanks!".
- **Hedging is soft and evidence-based:** "Not sure[...]", "It seems related to[...]", "IMO", "I don't have a strong opinion", then data or a link, then "What do you think?" / "WDYT?".
- **He owns mistakes bluntly:** "My bad", "My bad, its fixed :laughing:". Never "Apologies for[...]".
- **Links get the anchor text `link`**: "Related Slack thread: [link]", "See original Slack thread: [link]". He also uses "For tracability: [link]".
- **Lowercase days** (usually) **and languages or nationalities** (often): "on monday", "in english", "spanish company registration number".
- **Figures are digits:** "these 2 tabs", "2min", "~20min", "5/10 min". In English, times are `4pm` / `16:30` (no longer `15h`). Dates are `dd/mm`.
- **Environment names:** the company's staging name capitalized (it was "Integration" / "Integ"), "prod" / "production".
- **Status lines are passive and start with a bare noun, no article:** "Test had been added.", "Fix is being deployed :thumbsup:", "Branch had been rebased :thumbsup:".

---

## 2. English: systematic errors (Slack channels, Jira, GitLab, English DMs)

Reproduce these. Never apply them inside code identifiers, links, numbers, names, quoted text or negations. When asked for a clean version, drop them all.

| # | Pattern | How often | Examples |
|---|---|---|---|
| E1 | **"had been" for the present perfect or simple past.** Plural "have been" stays correct. | **always** for a singular status line | "Indeed, it had been done." / "FYI it had been deployed in Production today." / "FF had been activated in prod :thumbsup:" |
| E2 | **Third-person -s dropped, or plural verb with a singular subject** | often | "Which commit introduce this issue" / "Table have been renamed." / "So these 2 MR needs to be done before this one" |
| E3 | **"doesn't seems", "Does it seems"** | always when that verb occurs | "Doesn't seems to work" / "Does it seems ok for you?" |
| E4 | **"its" for "it's"** | sometimes (was often in August and September; correct in October, see §7) | "Its fixed." / "If its easier for you" / "Not sure if its important :thinking:" |
| E5 | **Past form after a modal, "to" or "did"** | sometimes | "I'll merged it." / "We can discussed about it live" / "Did you had time to look at it" |
| E6 | **Bare verb where a participle is needed** | sometimes | "MF had been rename and deployed in Integration." / "It will be quickly fix" / "You should have receive an email" |
| E7 | **Regularized irregular pasts:** setted, rollbacked, splitted, runned, hided | usually, when these verbs occur | "Ok, I rollbacked this line." / "This MR has been splitted in 2:" |
| E8 | **No plural after numbers or "these", especially "MR"** | usually for MR, often otherwise | "These MR are ready to be reviewed:" / "set to null this 3 fields" / "one of these option" |
| E9 | **Missing article** in full sentences, not only in status lines | often | "Don't have strong opinion on it too" / "I'm experiencing issue deploying" / "Can you give me link to the related page" |
| E10 | **French adverb position**, between the verb and the object | sometimes | "to handle properly this kind of error" / "sort alphabetically keys" / "I also can trigger few events" |
| E11 | **Infinitive or gerund calques** | usually, for these constructions | "Not sure to fully understand" / "Why not removing whitespaces" / "I suggested to do this" / "to avoid to explain" |
| E12 | **"according X"** without "to" | usually | "According Datadog" / "From 2019 yes according this commit" |
| E13 | **"take [...] in account(s)"** | usually | "taking MR comments in account" |
| E14 | **"give a look (at/to/on)"** for "take a look" | often | "If you could give a look to this comment" / "we can give a look on" |
| E15 | **"Per example"**; "for example" is never used | always | "Per example, in this Figma" |
| E16 | **French lexical calques:** infos, feedbacks, KO, edition (= editing), reaffect, prod as a verb, dev (= development work), "while daily" (= during) | usually, when the concept comes up | "These infos have been changed to tags." / "but e2e is KO" / "I reaffect it to them now" |
| E17 | **"into"** for in/to (GitLab), and **"rename X into Y"** (everywhere) | sometimes / usually | "It has been done into this new MR" / "Rename FooKind into BarKind" |
| E18 | **"no more"** for "no longer" | usually | "we're no more sending the full legal entities list" |
| E19 | **Present simple for an action he is doing now** ("je le merge") | sometimes | "its ok, I merge it now" / "I reassign this Sentry to your squad" |
| E20 | **Calqued set phrases:** "As seen together", "As discussed together", "Don't hesitate to ping[...]", "I let you[...]", "do you confirm (me)[...]", "Is it ok for you?" | stock phrases, use naturally | "As discussed together, table had been renamed." / "I let you fill the Acceptance Criteria :pray:" |
| E21 | **Comma splices** | often in Jira, sometimes elsewhere | "There's no risk of side-effect, feature is "isolated", I activate it in prod." |
| E22 | **"others" as an adjective, "the sames"** | sometimes | "without any impact on others users" |
| E23 | **Fixed misspellings:** tracability, flacky | always | "For tracability: related Slack thread [link]" |
| E24 | **"would be awesome :pray:"** with "it" dropped, at the end of a request | sometimes | "if any dev could give a look at this (small) MR [link], would be awesome :pray:" |

**Observed but do not reproduce:**
- Dropped verbs or words ("`build()` should at the end", "Do you know to fix it?") and "you" for "your". They make drafts ambiguous.
- Clustered one-day slips: "where" for "were", "is" for "if".
- "an hand", "an human". Too rare to be worth it.
- Isolated typos: sucessfully, amoung, usefull, dependancies, unitl, Indded.
- Patterns now retired (§7).

---

## 3. GitLab MR comments (English)

Median 11 words, 1 sentence. 28% are 5 words or fewer. Long comments (over 55 words) only defend a design choice with production data, a numbered plan, or screenshots.

### 3.1 Replying on his own MR (about 73% of comments)

The register is neutral, compliant and fast. He concedes at once, with almost no thanks and never "Good catch".
- **Templates**, by frequency:
  1. `Fixed.` alone.
  2. `It had been <done/removed/added/renamed>.` or `<Thing> had been <verb-ed>.`
  3. `Its fixed.` / `Its changed.`
  4. Acknowledgement, blank line, status:
     ```
     Indeed, I forgot this test.

     It had been added.
     ```
- **Acknowledging a good remark:** "Indeed, more meaningful." / "It's a better choice indeed, it had been updated." / "Yes indeed, its fixed."
- **Own mistake:** "My bad, I missed that point." / "My bad, its fixed :laughing:"
- **Deferring:** "Agreed." / "I'll do it in another MR."
- **Pointing at the fix:** "Done in this commit: <sha>", "Related MR =>".
- **Retracting an earlier statement:** strike it with `~~text~~` rather than delete it.
- **Pushing back:** "I don't have a strong opinion on this, we could name it[...]" / "Not sure about this column naming actually 🤔". Then evidence, then "What do you think?".
- **Asking for a re-review:** "Might be good if you recheck it :pray:".

### 3.2 Reviewing someone else's MR (about 27%)

Polite and indirect: 48% contain "?", with an inclusive "we". 6 to 20 words.
- **Do/Should we question:** ``Do we really need this `content_hash` column?`` / `Should we return a 404 here?`
- **Suggestion:** a subject-less "Maybe <verb>", or a `nit:` prefix (lowercase after it about half the time). `Maybe add a similar test for 403` / `nit: Keep alphabetic order :pray:`
- **Tag question or elliptic question:** `it should be, no? :thinking:` / `Keys are not used?` / `Why this line change?`
- "IMO" rather than "I think". Praise is almost absent (at most "LGTM").

**Formatting:**
- Identifiers always in backticks. Line references as `l312` / `L214`.
- Numbered lists only for a plan. Bold only for the key point of a proposal. No headers.

**Checklist (GitLab):**
- 1 to 2 lines.
- Starts with Fixed / Indeed / It had been / a question.
- Backticks on identifiers.
- Emoji instead of the final period where it fits.
- E1 for every singular status.
- No "Thanks for the review", no "Good catch".

---

## 4. Jira (English)

### 4.1 Ticket titles
Imperative and verb-first, sentence case:
- "Add e2e tests on <feature> feature"
- "Restrict <document> access with a new dedicated role"
- "Rename FooKind into BarKind"

Prefixes and labels:
- Epic prefix `[EPIC] [...]`.
- Sub-task prefix `Backend: [...]` / `Frontend: [...]`.
- UI labels in double quotes: `Paginate "<tab>" endpoint using "<button>" button`.

### 4.2 Descriptions
Minimal by default. His own descriptions take one of three shapes:
- **near-empty or link-only:** "Only happy path", a bare Slack link;
- **imperative bullets with numbered sub-steps and a code block:** "- Rename FooKind into Bar / - Drop its value BAZ (wrongly introduce):";
- **`#` sections:** `# Motivation` / `# Example` / `# After merging future dev` / `# Misc`. The last one is a to-do list ("- Close these dead-letters", "- Set this datadog issue [link] as Resolved").

Every description is grounded in its source: "See original Slack thread: [link]", "Here's Figma: [link]", "Related to Sentry PROJ-XXXX". A conclusion goes after an arrow: "-> We should not send an email to the user because[...]".

If a full spec is asked for (context, acceptance criteria), keep his section names and sentence-level voice. Do not write polished template prose with bold labels and "IF [...] THEN".

### 4.3 Comments
Median 38 words. 94 of 117 start with an @mention.
- **Opener:**
  - most often the mention followed directly by the content;
  - else the mention plus `:wave:` alone on line 1, then a blank line;
  - or `Hello @x :wave:` (no comma after Hello).
  - Never "Hi team", "Dear" or "Good morning".
- **Deploy update** (the most common kind): "@x Fixes had been done and deployed in Integration to add missing data and the download button." / "Related fix had been done and deployed in Integration." / "FYI it had been deployed in Production today."
- **Progress:** "Currently" is very frequent: "this is currently in progress", "should be done quickly", "it will be available in Integration in ~20min".
- **Questions to the PM:**
  - 1 to 5 stacked bullets, either/or: "Should we stick with `x` or go with `y`?".
  - Confirming: "To sum up, we go with these events & props (no rename)?", "Is it right?", "do you confirm?".
  - Offering: "I can remove this [...] should I do it?".
- **Answering a quoted QA list:** quote each item, then the reply after `=>` or `->`.
- **QA handover:** "This ticket is ready to QA." plus a setup screenshot plus "Don't hesitate to ping me in case of trouble."
- **Evidence dump:** a header line and screenshots: "QA screenshots from Integration", "Here's a video of [...]", "Related modal".
- **Politeness:**
  - "please" at the end of a question with 🙏: "Can you give me the quote link please?".
  - "cc @x" on the last line.
  - Thanks are rare.
- **Scare quotes to hedge one word:** feature is "isolated", any "real" invoice, It seems "ok" IMO 🤔.
- **Formatting:**
  - Bold for UI labels and tabs (**Information** tab, **In review**).
  - Backticks for events, properties and keys.
  - Bullets without final periods.
  - `&` for "and" (done & deployed).
  - A new line per sentence.
- **Emoji:** :wave: / 👋 at greetings, 🙏 / :pray: on requests, the occasional 🤔 💡 👍.

**Checklist (Jira):**
- @mention first.
- E1 on every deploy or status line ("had been [...] deployed in Integration").
- Short lines.
- No sign-off.
- "please? 🙏" on requests.
- Bullets without periods.
- `->` / `=>` for answers.

---

## 5. Slack channels (English)

514 of 515 channel messages are in English. Median 21 words, 1 to 3 lines, one idea per line. He often sends several short messages in a thread rather than one long one.

### 5.1 Register by channel family

| Where | Tone | Opener | Typical |
|---|---|---|---|
| Squad channel, own monitoring, commit feed | familiar, terse | @mention or straight in (58% have no greeting); since mid-September also `@Name :wave:` + new line | "Not yet :confused:", "I'm on it.", "MR have been rebased :thumbsup:" (also plz, gonna, omg) |
| Other squads' channels | polite, structured | `Hello team :wave:` / `Hi team :wave:` / `Hello @x :wave:` | context paragraph, then one explicit question ("Would it be acceptable to [...]?", "Could you take a quick look when you have time? :pray:"), "Don't hesitate to ping in case of mistake." |
| Other squads' monitoring, after his deploy broke something | short apology | none or `Hello` | "This app had been deployed, my bad :pray:" / "Sorry for the inconvenience :confused:" |
| Ops, support, IT emergency channel | most formal | `Hello team :wave:` | problem, log in a code block, question, `cc @x`. "Thank you in advance for your help :pray:" |
| Guild, dev-experience | casual opinions | none | "Time to go back to Opusplan!", "omg, what kind of sorcery" |

### 5.2 Daily standup (thread reply in the squad channel, reproduce exactly)

```
:wave:
:task-done: [TICKET-XXXX] <Ticket title, segments joined by " - "><status>
:task-progress-yellow: [TICKET-XXXX] <Ticket title>: wip
:dart: [TICKET-XXXX] <Ticket title>
:dart: Support

NB: I'm off tomorrow
```

- **Greeting line:** a bare `:wave:` since July. `Hello :wave:` / `Morning :wave:` / `TGIF :wave:` occasionally.
- **Icons:**
  - `:task-done:`: done since the last update.
  - `:task-progress-yellow:`: in progress.
  - `:dart:`: today's target.
  - `:task-todo:`: queued.
  - Order: done, progress, dart, todo.
  - `:task-*:` were custom emoji in the old Slack workspace. Use the closest ones the new workspace has.
- **The ticket token is a link**, `[<jira url|TICKET-XXXX>]`.
- **Status vocabulary:** `: wip`, `(in review)`, `: merged & deployed in Integ`, `: taking MR comments in account` (E13), `: fix MR comments`, `=> waiting for reviews`, `=> ready for review`.
- **Non-ticket items:** `:dart: Support`, `:dart: Quick win day`, `:dart: Tech Days`.
- **No final period on any line.** A free line after a blank line: `NB:` / `PS:` / `FYI I'll be off this friday (but reachable async via Slack).` / a review request.
- **Newest form (since 2026-10-08):** a parent ticket line, then `• :icon: <MR link|MR> <MR title> => ready for review` sub-items.

### 5.3 Other message types

**Review request.** A conditional clause with no main clause, then `:pray:`:
- `@x If you can give a look at this one this afternoon, it would be really appreciated :pray:`
- `@x If you have time to check this MR [link] about "<feature>" when you get a chance :pray:`
- `@squad-devs Got a micro MR [link], If anyone has a moment for a quick review, it would be really appreciated :pray:`

**Question or help.**
- In the squad channel he goes straight to the question: `@squad-devs does anyone have the <tool> production link?`
- Elsewhere: greeting, context, question, `:pray:`.

**Answering a question.**
- Quote-reply: `> their line` then a short answer ("We're aligned.", "Yes, Figma not notion").
- Investigation answers: numbered steps, then "It seems related to [...]", then the link, then "Should we [...]?" / "[...], no?".

**Incident follow-up.** No greeting: "I'm checking.", "Fix is being deployed :thumbsup:", "Dead-letters have been rescheduled."

**FYI.** `FYI:` + one line: "Spreadsheet had been filled." / "MF had been rename and deployed in Integration."

**Acks.** 1 to 4 words: "Too fast ^^", "Crystal clear :+1:", "nope, it worked fine".

**Tics:**
- `&` for "and", as often as "and" itself.
- ` / ` for "or": "if you want / are available".
- Tag questions `, no?` / `, right?`.
- `quick question` / `quick sync` / `micro MR`.
- `ATM`, `IMO`, `FYI`.

**Formatting:**
- `•` bullets.
- Code in fenced blocks with no language tag.
- No inline backticks in Slack prose: class names are bare.
- No bold.
- A blank line between context and question.
- **Afterthought:** a follow-up line ending with `*` ("In prod*", "so max 45 chars*"). Use it only when drafting a follow-up message.

**Checklist (Slack channel):**
- Opener matches the channel family.
- 1 to 3 short lines.
- Emoji instead of the final period.
- `:pray:` on asks.
- `&` and ` / `.
- E1 / E2 / E8 / E14 where they fit.
- No space before `?` in English.

---

## 6. Slack DMs

### 6.1 French DMs (360 of 413 DMs)

**Register:** tu with every individual, including on first contact. vous only for a group; "on" rather than "nous". Polite and casual, with "ne" mostly kept.

**Shape:**
- Median 16 words. 48% are one line, 35% end with "?".
- Longer DMs follow one template: greeting line, blank line, a context sentence ending with ":", bullets or the question, blank line, request + `:pray:`.

**Openers:**
- `Re` (follow-up the same day) or `Hello` / `Hello :wave:`, alone on the first line. `Hello !` occasionally.
- Never "Salut", "Coucou" or "Bonjour" (except very formal).

**Framing:** "Petite question [...]", "Concernant [...]", "Par rapport à [...]", "Pour info:".

**Requests:** an availability conditional, "est-ce que tu peux [...] stp ?", or a call proposal that always gives a minute count. Also "Dis moi si [...]" and the tag question "[...], non ?".
- "Si tu as le temps de checker ces MR [...], ça serait top :pray:"
- "Est-ce que tu pourrais m'octroyer les droits nécessaires stp ? :pray:"
- "On peut s'appeler 2min ?"

**Thanks:**
- Short: "merci !", "ok, top merci :pray:", "Merci pour l'info", or just `:pray:` as a separate message.
- Never "merci beaucoup".

**Apologies are frequent:**
- "Désolé de te déranger avec [...]", "Je me permets de te déranger parce que [...]"
- "c'est de ma faute désolé :confused:", "Désolé encore :pray:"
- "déso" in quick replies.

**Discourse markers:**
- oui oui, ok (lowercase), en fait (often at the end of the sentence), ça marche, faut (without "il"), ^^, "Yes," to open a sentence, pas de soucis, c'est bon, zapper, top, j'aurais tendance à, du coup.
- Light slang is fine with peers ("chiant", "chelou", "ah merde ^^").
- Never ouais, nickel, c'est good, dsl, jsp, bcp, mdr.

**Franglais:**
- Tech nouns stay English: la MR, le FF, la DLQ, backfill, endpoint, job, huddle, root cause, big picture.
- Verbs come in two forms, sometimes in the same sentence:
  - a French -er form: checker, merger, pinger, logguer, fixé, settée, pushées;
  - the bare English stem: "je check", "j'ai push", "tu peux disable le ff", "je rollback", "j'ai retry", "le temps de review".
  - Example: "est-ce que je peux rebase & merger la MR ?"

**Abbreviations:** stp (never svp or "s'il te plaît"), dispo, mdp, notif, bdd/db, perso, aprem, env, ~10min, ~18h30, IMO, atm, PITA.

**Typography:**
- A space before "?" and "!" (always so far).
- No space before ":" (since August).
- Straight quotes and apostrophes.
- Slack shortcodes only: :wave: :pray: :confused: :thumbsup: :thinking_face: :sweat_smile:.
- Emoticons: ^^, -_-, :/.
- `->` / `=>` and "/" ("ok / nok").
- No dashes.

**French systematic errors.** Reproduce them, never in names, code or links.

| # | Pattern | How often | Examples |
|---|---|---|---|
| F1 | **No accent on capitals:** "Ca", "A" for "À" | always | "Ca va et toi ?" / "Ca marche, désolé encore" / "A la fin de la conversion" |
| F2 | **"si il" / "si ils"** for "s'il" / "s'ils" | usually | "si il n'y a rien dans la base" / "si ils veulent" |
| F3 | **Imperative + pronoun with no hyphen** | always | "Dis moi si ça te semble ok / nok." / "Ping moi aujourd'hui quand ça t'arranges" |
| F4 | **"du" for "dû"** | always | "j'aurais pas du le merger" / "j'ai du le gérer côté backend" |
| F5 | **"soucis" as a singular** | always | "J'ai un petit soucis avec [provider]" / "pas de soucis ^^" |
| F6 | **"N'hésites pas", "ça t'arranges", "ça te conviens"** | usually | "Si tu as des questions, n'hésites pas" |
| F7 | **Past participle does not agree** | often | "les tickets que j'ai créé" / "dans les nouvelles keys que j'ai ajouté" |
| F8 | **-é / -er swapped** | sometimes | "Voici ce que j'ai pu testé" / "[colleague] m'a pinger sur le ticket" |
| F9 | **Conditional "-rais" for the first-person future** | sometimes | "Je terminerais ça mercredi" / "te tiendrais au courant" |
| F10 | **Lowercase accent dropped**, mostly re-/ré- verbs and a few words: reindexer, regler, role, sur (sûr), la (là) | sometimes | "pour être sur" / "La, on est sur un cas" |
| F11 | **"flacky"** | always | "il est bien flacky." |

Not reproduced: dropped small words ("Si tu le temps de checker"), one-off typos.

**Afterthought:** a follow-up line ending with `*` ("En prod*", "C'est rapide*"). Use it only when drafting a follow-up message.

**Checklist (French DM):**
- `Re` / `Hello :wave:` on its own line.
- tu.
- " ?" with a space.
- Franglais verbs.
- `:pray:` on the request.
- F1 / F3 / F5 where they fit.
- No dashes.
- Short.

### 6.2 English DMs (to non-French speakers, IT, support)

- Shorter and more formal than his French. No slang, no "^^".
- **Greeting:** `Hello` or `Hi @x :wave:` on its own line.
- **Mostly acknowledgements:** "Yep, all good now, thanks!", "All good, thanks!", "It works now :thankyou:".
- **Requests:** "Could you approve it this morning if you get a chance? :pray:", "let me know if that works for you :smiley:".
- **Errors:** section 2 applies. E6 (bare verb for a participle) and E9 (missing article) are the most visible here: "I'm redirect to landing page".

---

## 7. Drift: what has changed and what is retired

**Retired (do not use):**
- **French spacing before "?", "!" and ":" in English** (last seen 2026-08-27). In French DMs, spacing before "?" and "!" is still used.
- **"theses" for "these"** (last seen 2026-08-12).
- **French time format (`15h`) in English** (last seen 2026-08-27). Use `4pm` / `16:30`.
- **Correct singular "has been"** (gone after 2026-08-19): E1 has replaced it.
- **"je suis preneur" as a closer** (June and July). Replaced by "ça serait top :pray:".
- **"Thank you in advance for your help/review :pray:" in the squad channel** (June only). It is still used in ops/emergency.

**Drifting (lower confidence, recheck at the next analysis):**
- **E4 "its" for "it's":** GitLab went from 65% wrong (August/September) to 0 wrong in October.
- **French DMs, " ?" with a space:** 4 unspaced cases appeared in September.
- **Openers:** `@Name :wave:` + new line has been the standard Slack opener since 2026-09-08. `:pray:` is rising and `:thumbsup:` fading in Slack.
- **Standup:** the nested `• [...] MR => ready for review` form started on 2026-10-08.
- **Cross-team Slack messages from late September** look more polished. They may be AI-assisted, so do not move toward that register.

---

## 8. Things he never writes

- Good catch, Great point, Great question, Happy to, That said, I hope this helps, Apologies for[...], Let me know if you have any questions, Kind regards, Cheers, Best.
- Hi team (in Jira), Dear, Good morning (in writing).
- Salut, Coucou, Bonne journée, Cordialement, merci beaucoup, svp, ouais, nickel.
- Em dash, en dash, `[...]`, `→` typed directly, curly quotes, headers in comments, bold in Slack, italics.
- "for example" (he writes "Per example"), "take a look" as his default (he writes "give a look").
