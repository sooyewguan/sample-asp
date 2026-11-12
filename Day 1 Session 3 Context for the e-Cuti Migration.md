# Day 1 Session 3: Context for the e-Cuti Migration

Nov 11, 2026 · @Soo Yew Guan

Everything happens in the Code tab, in one session, in your `ecuti` project folder. By the end you have a glossary and a table of agreed decisions; session 4 writes the spec, cuts the tickets and writes the code.

## Before you start

- [ ] Session 2 final check passes
- [ ] `server/` holds the ASP.NET Core project; `CLAUDE.md` has `## Agent skills`; `docs/agents/` has `issue-tracker.md`, `domain.md`, `triage-labels.md`
- [ ] Your repository has the five triage labels
- [ ] `.claude/skills/grilling/SKILL.md` has the one-question sentence from session 2 Part F
- [ ] `http://localhost:8080` shows e-Cuti (session 1 Part H)

Start a new session from your saved environment. Stay in this session all day: session 4 continues in it.

## Part A: walk through legacy e-Cuti

Today you migrate one application you didn't write. Before the interview, use it as each kind of user, then have Claude read it.

1. In a browser, open `http://localhost:8080`. Log in with each test login below, do one thing that role can do, and log out.

   | No. Staf | Role | Password |
   | --- | --- | --- |
   | S1004 | Staff | latihan123 |
   | S1001 | Supervisor | latihan123 |
   | S1000 | Administrator | admin123 |
2. In your Code tab session, ask Claude:

   ```text
   List the pages in legacy/, what each one does, who can use it, and the tables each one reads or writes. Read the tables through sqlmcp.
   ```

Check: you used e-Cuti as staff, supervisor and administrator, and Claude's list covers all 14 `.asp` pages in `legacy/`.

## Part B: grill the migration

1. Same session. Send:

   ```text
   /grill-with-docs Migrate the e-Cuti module in legacy/ to an ASP.NET Core Web API in server/ and a React app in client/, created later today. LegacyDb keeps its tables and its data, and nothing in legacy/ changes. Look up anything you can find in legacy/ or in LegacyDb through sqlmcp instead of asking me.
   ```
2. Answer one question at a time. Claude offers a recommended answer with each; take it or give your own. If Claude asks for a fact it could read in the code or the database, say "Look it up yourself."
3. When Claude asks you to confirm a shared understanding, read its summary against what you saw in Part A, correct it, then confirm.

Before you confirm, send:

```text
Before I confirm, write docs/migration-decisions.md with a table of what we settled: which legacy pages are migrated today and which are left out, the API endpoint for each migrated page, the page in client/ that replaces each legacy page, any table change with its reason, what happens to sp_LulusCuti, how users log in, what staff, supervisors and administrators may each do, and Vite proxy or CORS. For each row, give the decision and the file:line in legacy/ or the table in LegacyDb it comes from, or mark it as a change from legacy. Don't show me the table here; just tell me when the file is written.
```

Check: open `docs/migration-decisions.md` in VS Code. Every row of the table has a decision, and every decision has a source in `legacy/` or LegacyDb or is marked as a change from legacy.

Leave this session open over lunch. Session 4 starts in it with `/to-spec`.

## Final check and troubleshooting

- [ ] `GLOSSARY.md` at the root
- [ ] The session is still open

| Symptom | Fix |
| --- | --- |
| Several numbered questions at once | Redo session 2 Part F, new session, Part A step 2 and Part B again |
| No `GLOSSARY.md` after terms are agreed | After the interview, ask Claude which skills it loaded. If `domain-modeling` is not among them, type `/domain-modeling` and ask Claude to write `GLOSSARY.md` from the terms agreed in this conversation |
| Claude asks for a fact it could look up | "Look it up yourself in legacy/ or through sqlmcp." |
| Claude proposes changing a file in `legacy/` | "Nothing in legacy/ changes. Put it in server/ or client/." |

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills): `SKILL.md` for grill-with-docs, grilling, domain-modeling, to-spec, to-tickets; `setup-matt-pocock-skills/issue-tracker-github.md`; `.agents/invocation.md`; `ask-matt`
- [sooyewguan/sample-asp](https://github.com/sooyewguan/sample-asp): `README.md` (test logins, pages)
- [Claude Code: desktop app](https://code.claude.com/docs/en/desktop), [permission modes](https://code.claude.com/docs/en/permission-modes)
- [v2 Day 1 Session 2 guide](https://claude.ai/artifact/DD9myrbX6VgnMggPeemxp7)
