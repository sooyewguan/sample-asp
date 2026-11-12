# Day 1 Session 4: Specification, Tickets and Implementation of the e-Cuti Migration

Nov 11, 2026 · @Soo Yew Guan

Parts A and B run in the Code tab session you left open at the end of session 3, so the spec and the tickets are written with the interview still in context. Parts C to F each start a new session. In Part C, Claude hands every ticket to its own subagent.

## Before you start

- [ ] The session 3 final check passes
- [ ] The session 3 Code tab session is still open
- [ ] `http://localhost:8080` shows e-Cuti

If that session is gone, start a new one, ask Claude to read `GLOSSARY.md` and `docs/adr/`, and go to Part A. The interview itself does not carry over.

## Part A: the spec

1. In the session 3 session. Type:

   ```text
   /to-spec
   ```
2. Claude proposes the seams where tests go. Answer:

   ```text
   One seam: the API in server/. Tests are xUnit, in tests/Server.Tests. For each test, do the scenario on legacy e-Cuti at http://localhost:8080 with a test login from legacy/README.md, and read the data it used and changed through sqlmcp. In the test, mock the data access and the clock with that data and that date, and assert what legacy returned. Tests never connect to a database.
   ```
3. If Claude asks new questions, say "The deciding is done. Write the spec from this conversation."
4. Claude runs `gh issue create`.
5. Ask Claude "Show me the spec issue." Read Implementation Decisions (what you agreed in session 3 Part B, with no file paths and no code), Testing Decisions (your answer in step 2) and Out of Scope (the legacy pages and features that are not migrated today). Tell Claude to fix anything you never said.

Check: one open spec issue in your repository, not in `sooyewguan/sample-asp`, with the `ready-for-agent` label.

## Part B: the tickets

1. Same session. Type:

   ```text
   /to-tickets the spec issue
   ```
2. Claude lists the tickets and asks three questions about them. Reply:

   ```plain
   Send to a subagent using Medium Sonnet 5.5 to check the list against your vertical-slice rules and the spec's Out of Scope. In each ticket's acceptance criteria, list every rule in the legacy pages it migrates, as file:line, so each one gets a test. Publish after verified.
   ```
3. Claude creates one GitHub issue per ticket, as sub-issues of the spec, with the `ready-for-agent` label.

Check: one GitHub issue per ticket in your repository, under the spec issue.

## Part C: implement every ticket

1. Start a new session from your saved environment with **+ New**.
2. Type:

   ```text
   /implement-spec the spec issue in my repository. Work out which tickets can start from what has merged into the integration branch, not from the blocked-by counts on GitHub.
   ```
3. When Claude says it has finished, click **Changes** in the session's title bar and read the diff. Then ask "Show me the integration branch and the tickets of the spec that are still open. For each ticket, show the test that failed before its code was written and its run output now."

Check: every ticket of the spec is closed in your repository, every test in `tests/Server.Tests` passes, and nothing in `legacy/` changed.

## Part D: integration tests

1. Start a new session with + New. Send:

   ```text
   Write integration tests in tests/Server.IntegrationTests, one for each test in tests/Server.Tests. Each one runs the same scenario through the API against LegacyDb instead of the mocks: rerun legacy/ecuti_db.sql as sa with the password in WS_SQL_SA_PASSWORD, load the scenario's data, call the API, then check the same result and the rows changed in LegacyDb, including tblBakiCuti after an approval. Run them one at a time. When they finish, rerun legacy/ecuti_db.sql to restore LegacyDb. Show me the run output with each test's name and result, and for each failed test, why it failed.
   ```
2. For each failed test, type `/diagnosing-bugs` followed by the test's name and what Claude showed you.
3. Ask Claude "Count the rows in each LegacyDb table through sqlmcp."

Check: the run output lists every integration test by name as passed, and the row counts match the Expected row counts table in legacy/README.md.

## Part E: compare with legacy e-Cuti

1. Start a new session with + New. Ask Claude:

   ```text
   Start the API and the React app and open the app in the browser.
   ```

   Claude starts both dev servers and opens the page in the Browser pane. If the pane does not open, click **Open** on the server's card in the chat.
2. Ask Claude:

   ```text
   Also open legacy e-Cuti at http://localhost:8080 in the Browser pane. In both apps, log in with each test login from legacy/README.md and do what each ticket of the spec describes. After each step, take a screenshot of the legacy page and of the new page, and save them in docs/evidence/ with the ticket number, the app and the login in each file name. Then list every difference in what the pages show and what they save in LegacyDb, each with its two screenshots.
   ```
3. For each difference the spec doesn't ask for, type `/diagnosing-bugs` followed by the difference.

Check: ask Claude "Show me the screenshots in docs/evidence/ for each ticket." Every ticket has a legacy and a new screenshot for each step, and every difference from legacy e-Cuti is one the spec asks for.

## Final check and troubleshooting

- [ ] One spec issue in your repository, labelled `ready-for-agent`
- [ ] One GitHub issue per ticket in your repository, under the spec issue
- [ ] Every ticket of the spec is closed
- [ ] Every test in `tests/Server.Tests` and `tests/Server.IntegrationTests` passes
- [ ] The API and the React app start, and the finished pages work
- [ ] Every difference from legacy e-Cuti is one the spec asks for
- [ ] The integration branch is merged into main and pushed to your repository
- [ ] Nothing in `legacy/` changed

| Symptom | Fix |
| --- | --- |
| `/to-spec` asks questions | "The deciding is done. Write the spec from this conversation." |
| `gh` not signed in | Finish the GitHub CLI step in session 1 E3, quit and reopen the Claude app, new session, ask Claude to read `GLOSSARY.md` and run `/to-spec` |
| `/implement-spec` says no ticket can start | Say "Work out which tickets can start from what has merged into the integration branch, not from GitHub." |
| Claude changes a file in `legacy/` | Stop it and say "Nothing in legacy/ changes. Undo that and put it in server/ or client/." |
| Tests fail and Claude keeps changing the test | Say "Fix the code, not the test" |
| An integration test fails but the same scenario passes in `tests/Server.Tests` | Type `/diagnosing-bugs` followed by both test names and the failure |
| A ticket of the spec is still open after the run | Ask Claude to close it on GitHub |
| The Browser pane does not open | Click **Open** on the server's card in the chat, or press Ctrl+Shift+B |
| The React page cannot reach the API | Tell Claude; the proxy or CORS decision from the spec was not applied |
| `http://localhost:8080` doesn't load | Open IIS Manager and check that the `ecuti` site is started. If it shows a database error, check that sql-workshop is running in Docker Desktop |
| The new page and the legacy page show different rows | Type `/diagnosing-bugs` followed by both results and the test login you used |

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills): `SKILL.md` for to-spec (seams, Testing Decisions, Out of Scope), to-tickets (vertical slices, the quiz, sub-issues of the source issue, `ready-for-agent`), implement-spec (a fresh subagent per ticket in its own worktree, the frontier, the integration branch, code-review, resolving the tickets), tdd and its `mocking.md`, code-review, diagnosing-bugs, retro; `docs/engineering/implement-spec.md` (on GitHub, work out the frontier from merges); `setup-matt-pocock-skills/issue-tracker-github.md` (`gh issue create --parent`, `gh issue close`); `ask-matt` (implement-spec for a whole spec, retro in the session it looks back on)
- [Claude Code: desktop app](https://code.claude.com/docs/en/desktop): preview your app, the Browser pane, dev servers; [permission modes](https://code.claude.com/docs/en/permission-modes): Auto
- [sooyewguan/sample-asp](https://github.com/sooyewguan/sample-asp): `README.md` (test logins, expected row counts, `ecuti_db.sql`)
- [v2 Day 1 Session 3 guide](https://claude.ai/artifact/FMNaxLWduAiScnTVFVfZ9T)
