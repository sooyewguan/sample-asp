# Day 2 Session 1: Context and Design for a New Module

Nov 11, 2026 · @Soo Yew Guan

Everything happens in the Code tab, in one session, in your `ecuti` project folder. Today you add a new module to the migrated e-Cuti, with the same skills and glossary. By the end of this session you have the interview, the glossary terms and a design. Session 2 continues in this session with the spec and the tickets, then writes the code.

## Before you start

- [ ] The Day 1 Session 4 final check passes
- [ ] Docker Desktop shows sql-workshop running
- [ ] `.claude/skills/grilling/SKILL.md` has the one-question sentence from Day 1 Session 2 Part F

Start a new session from your saved environment. Stay in this session, and leave it open at the end.

## Part A: pick your module

Today you build a new module of e-Cuti. You choose what it is. Keep it small enough to build this afternoon.

Describe your module in the prompt box in two or three sentences: who uses it, what it is, what they do with it. Do not send yet.

Check: your text says who, what, and what they do.

## Part B: grill the module

1. Put ` /grill-with-docs  ` in front of your Part A text, then send:

   ```text
   /grill-with-docs <your Part A text>
   ```
2. Answer one question at a time. Claude offers a recommended answer with each; take it or give your own.
3. When Claude asks you to confirm a shared understanding, read its summary against your Part A text, correct it, then confirm.

Check, before you confirm. Send:

```text
Is anything about the new module still open: its terms in GLOSSARY.md, its tables and how they link to the e-Cuti tables, its endpoints, its pages, or who may do what?
```

If Claude names anything, answer it, then confirm.

## Part C: design the pages

The **main session** is this session; it keeps the interview for the spec and the tickets. The **design subsession** is where the design work happens, so its back-and-forth stays out of the main session.

1. **Main session.** Type:

   ```text
   Spin off a subsession to run /design for the pages we agreed in this interview: one artboard per page, with the fields, actions and statuses we agreed, fake data.
   ```
2. Open the design subsession from the sidebar.
3. **Design subsession.** Open the canvas link. Look at each artboard. Change labels and layout on the canvas yourself; your edits save on their own. For bigger changes, tell Claude here what is wrong. Repeat until the design is right.
4. **Design subsession.** Type:

   ```text
   The design is final. Send the canvas link to the main session.
   ```
5. Go back to the main session.

Check: the canvas shows every page you agreed in Part B, and the main session has the canvas link.

## Part D: wrap up

1. Main session. Tell Claude:

   ```text
   Commit everything that changed in this session with a message that says what it is, and push it to my repository.
   ```
2. Leave this session open. Session 2 continues in it.

Check: ask Claude "Show me the latest commit." It holds the changes to `GLOSSARY.md` from this session.

## Final check and troubleshooting

- [ ] `GLOSSARY.md` has the new terms, and the Day 1 terms keep their meaning
- [ ] The design canvas shows every page you agreed, and the main session has its link
- [ ] Everything from this session is committed and pushed
- [ ] This session is still open for session 2

| Symptom | Fix |
| --- | --- |
| Several numbered questions at once | Redo Day 1 Session 2 Part F, new session, Part B again |
| No change to `GLOSSARY.md` after terms are agreed | After the interview, ask Claude which skills it loaded. If `domain-modeling` is not among them, type `/domain-modeling` and ask Claude to add the terms agreed in this conversation to `GLOSSARY.md` |
| Claude proposes changing a file in `legacy/` | "Nothing in legacy/ changes. Put it in server/ or client/." |
| `/design` says it is unavailable | Type: "Spin off a subsession to publish a clickable mockup of the pages agreed in the interview as an artifact, one screen per page, fake data, no backend, and report the link back here" |

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills): `SKILL.md` for grill-with-docs, grilling, domain-modeling; `setup-matt-pocock-skills/issue-tracker-github.md`; `ask-matt` (steps 1 to 3 in one session)
- [Claude Code: desktop app](https://code.claude.com/docs/en/desktop); [artifacts](https://code.claude.com/docs/en/artifacts): `/design`
- [v2 Day 1 Session 4 guide](https://claude.ai/artifact/Fbk7p4pHqKHMarTVTtMif5)
