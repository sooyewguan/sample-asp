# Day 2 Session 4: Code Review and Security of e-Cuti

Nov 11, 2026 · @Soo Yew Guan

Same `ecuti` project folder and environment as Day 1. This session reviews all the code you added over the two days, the e-Cuti migration from Day 1 and the new module from sessions 1 to 3. It records what it finds as issues and as coding standards, and fixes one finding.

The legacy code holds deliberate defects and security weaknesses. A migration can carry them into `server/` and `client/`.

## Before you start

- [ ] The Day 2 Session 3 final check passes
- [ ] Docker Desktop shows sql-workshop running, and `http://localhost:8080` shows e-Cuti

Start a new session from your saved environment.

## Part A: review both days

`code-review` already ran at the end of `/implement-spec` on both days. Now review both days at once, from the commit before `server/` existed.

1. Type:

   ```text
   /code-review since the parent of the commit "Add server project". The specs are the migration spec issue and the new module's spec issue.
   ```
2. Read both parts of the report: Standards and Spec. Your project has no `CODING_STANDARDS.md` yet; you write it in Part B.

Check: the report has a Standards part and a Spec part, and every finding names a file in `server/` or `client/`.

## Part B: write the coding standards

`code-review` reads `CODING_STANDARDS.md` when it reviews your changes. A rule written there applies to the fix in Part E and to every ticket you implement after the workshop.

1. Same session. Send:

   ```text
   Write CODING_STANDARDS.md at the root of this folder with one short rule for each kind of finding from Part A. Then commit it with the message: Add coding standards, and push it to my repository.
   ```
2. Ask Claude "Show me CODING\_STANDARDS.md." Remove any rule you don't agree with, in VS Code or by telling Claude.

Check: `CODING_STANDARDS.md` has one rule per kind of finding, and the latest commit is `Add coding standards`.

## Part C: review for security

`code-review` checks standards and the spec, not security. An AI review can miss weaknesses too, so treat this part as one check among several, not proof that the code is safe.

1. Same session. Send:

   ```text
   Review server/ and client/ for these weaknesses. For each migrated page, also check whether a weakness in the legacy page it replaces was carried over.
   - SQL built from strings, or raw SQL in EF Core with values pasted in
   - Input checked only in React and not in the API
   - An endpoint with no check of who may call it
   - Passwords or connection strings in code, in appsettings files or in git
   - Passwords stored or compared as plain text
   - Personal data or raw input written to logs
   - Error messages that show the schema or a stack trace to the user
   List each finding with its file, its line, and the legacy page it came from, if any. Don't change any code yet.
   ```
2. Read each finding. Open the file in VS Code at the line Claude names and check that the finding is real.

Check: every finding has a file and a line, and you have checked each one in VS Code.

## Part D: record the findings as issues

1. Same session. Send:

   ```text
   Publish each finding from Parts A and C that I confirmed as a GitHub issue in my repository, with the ready-for-agent label. In each issue, name the file, the line, and the legacy page it came from, if any.
   ```
2. Ask Claude "List the issues you just created."

Check: one issue per confirmed finding in your repository, each with the `ready-for-agent` label.

## Part E: fix one finding

The fix gets its own session.

1. Pick one finding issue from Part D.
2. Start a new session from your saved environment with **+ New**.
3. Type, with the issue's number:

   ```text
   /implement #<number>
   ```
4. When Claude says it has committed, click **Changes** and read the diff.
5. Ask Claude "Start the API and the React app and open the app in the browser." Use the page the finding is on and check that it still works.
6. Ask Claude "Close issue #\<number> on GitHub."

The other finding issues stay open. Fix them later the same way.

Check: the issue is closed in your repository, its commit is pushed, and the page still works.

## Final check and troubleshooting

- [ ] You read a `/code-review` report with a Standards part and a Spec part
- [ ] Every security finding you confirmed is an issue in your repository
- [ ] `CODING_STANDARDS.md` is committed and pushed
- [ ] One finding issue is closed, and its page still works

| Symptom | Fix |
| --- | --- |
| `/code-review` can't find the commit "Add server project" | Ask Claude "Show me the commits since I copied sample-asp", then run `/code-review` since the parent of the first commit that is yours |
| `/code-review` reviews nothing | It skips uncommitted changes. Ask Claude to commit, then run it again |
| Claude starts fixing code in Part C | Stop it and say "List the findings only. Don't change any code yet." |
| A finding names a file in `legacy/` | The legacy code stays as it is. Ask Claude whether the same weakness is in `server/` or `client/`, and record only those |

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills): `SKILL.md` for code-review (Standards and Spec since a fixed point, `CODING_STANDARDS.md`), implement
- [OWASP Top 10:2025](https://top10.owasp.org/2025/): the categories behind the Part C list
- [EF Core SQL queries](https://learn.microsoft.com/en-us/ef/core/querying/sql-queries): `FromSqlRaw` with values pasted in
- [Claude Code: security guidance](https://code.claude.com/docs/en/security-guidance): an AI review can miss issues
- [sooyewguan/sample-asp](https://github.com/sooyewguan/sample-asp): `README.md` (deliberate defects and weaknesses)
