# Day 2 Session 3: Verification and Merge of the New Module

Nov 11, 2026 · @Soo Yew Guan

Parts A to C each start a new session.

## Before you start

- [ ] The Day 2 Session 2 final check passes
- [ ] Docker Desktop shows sql-workshop running

## Part A: integration tests

1. Start a new session from your saved environment with **+ New**. Send:

   ```text
   Write integration tests in tests/Server.IntegrationTests for the new module, one for each test that /implement-spec added for it. Each one runs the same scenario through the API against LegacyDb instead of the mocks: rerun database/ecuti_db.sql as sa with the password in WS_SQL_SA_PASSWORD, apply the EF Core migrations, load the scenario's data, call the API, then check the same result and the rows changed in LegacyDb. Run them one at a time. When they finish, rerun database/ecuti_db.sql and apply the migrations again. Show me the run output with each test's name and result, and for each failed test, why it failed.
   ```
2. For each failed test, type `/diagnosing-bugs` followed by the test's name and what Claude showed you.

Check: the run output lists every integration test of the new module by name as passed.

## Part B: compare with the design

1. Start a new session from your saved environment with **+ New**. Ask Claude:

   ```text
   Start the API and the React app and open the app in the browser.
   ```
2. Ask Claude:

   ```text
   Also open the design canvas linked in the new module's spec issue. In the app, log in with each test login from the README and do what each ticket of the spec describes. After each step, take a screenshot of the page and save it in docs/evidence/ with the ticket number and the login in the file name. List every difference between the new pages and the canvas, each with its screenshot.
   ```
3. For each difference the spec doesn't ask for, type `/diagnosing-bugs` followed by it.

Check: ask Claude "Show me the screenshots in docs/evidence/ for each ticket." Every ticket has a screenshot for each step, and every difference from the canvas is one the spec asks for.

## Part C: merge

1. Ask Claude:

   ```text
   Commit what changed, merge the integration branch into main, and push main to my repository.
   ```

Check: ask Claude "Show me the latest commit on main in my repository." It holds the new module and the changes you accepted, and nothing in `legacy/` changed.

## Final check and troubleshooting

- [ ] Every integration test of the new module passes, and every difference from the canvas is one the spec asks for
- [ ] `/retro` ran on the Session 2 Part C session, and its accepted changes are committed
- [ ] The integration branch is merged into main and pushed to your repository
- [ ] Nothing in `legacy/` changed

| Symptom | Fix |
| --- | --- |
| The Browser pane does not open | Click **Open** on the server's card in the chat, or press Ctrl+Shift+B |
| The React page cannot reach the API | Tell Claude; the proxy or CORS setup from Day 1 was changed |
| Claude changes a file in `legacy/` | Stop it and say "Nothing in legacy/ changes. Undo that and put it in server/ or client/." |
| An integration test fails but the same scenario passes with the mocks | Type /diagnosing-bugs followed by both test names and the failure |

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills): `SKILL.md` for diagnosing-bugs, retro; `ask-matt` (retro pointed at a session's log)
- [Claude Code: desktop app](https://code.claude.com/docs/en/desktop): the Browser pane, dev servers
- [v2 Day 1 Session 4 guide](https://claude.ai/artifact/Fbk7p4pHqKHMarTVTtMif5): Parts D, E and F
- [v2 Day 2 Session 2 guide](https://claude.ai/artifact/SSWXFPpXT9rPQB8B3m5de9)
