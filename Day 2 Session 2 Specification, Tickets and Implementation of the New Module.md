# Day 2 Session 2: Specification, Tickets and Implementation of the New Module

Nov 11, 2026 · @Soo Yew Guan

Parts A and B run in the Code tab session you left open at the end of session 1, so the spec and the tickets are written with the interview still in context. Part C starts a new session, and Claude hands every ticket of the new module to its own subagent, as in Day 1 Session 4 Part C.

## Before you start

- [ ] The Day 2 Session 1 final check passes
- [ ] The session 1 Code tab session is still open
- [ ] Docker Desktop shows sql-workshop running

If that session is gone, start a new one, ask Claude to read `GLOSSARY.md` and `docs/adr/`, and go to Part A. The interview itself does not carry over.

## Part A: the spec

1. In the session 1 session. Type:

   ```text
   /to-spec Put the design canvas link in the spec.
   ```
2. Claude proposes the seams where tests go. Take its recommendation.
3. If Claude asks new questions, say "The deciding is done. Write the spec from this conversation."
4. Ask Claude "Show me the spec issue." Read Implementation Decisions (what you agreed in session 1 Part B, with no file paths and no code) and Out of Scope (what you deferred). Tell Claude to fix anything you never said.

Check: one open spec issue for the new module in your repository, with the `ready-for-agent` label and the canvas link.

## Part B: the tickets

1. Same session. Type:

   ```text
   /to-tickets the spec issue
   ```
2. Claude lists the tickets and asks three questions about them. Reply:

   ```text
   Check the list against your vertical-slice rules and the spec's Out of Scope, then publish.
   ```
3. Tell Claude:

   ```text
   Commit everything that changed in this session with a message that says what it is, and push it to my repository.
   ```

Check: one GitHub issue per ticket in your repository, under the new spec issue, each with the `ready-for-agent` label.

## Part C: implement every ticket

1. Start a new session from your saved environment with **+ New**.
2. Type:

   ```text
   /implement-spec the new module's spec issue in my repository. Work out which tickets can start from what has merged into the integration branch, not from the blocked-by counts on GitHub.
   ```
3. When Claude says it has finished, click **Changes** in the session's title bar and read the diff. Then ask "Show me the integration branch and the tickets of the spec that are still open. For each ticket, show the test that failed before its code was written and its run output now."

Check: every ticket of the new module's spec is closed in your repository, every test passes, and nothing in `legacy/` changed.

## Final check and troubleshooting

- [ ] One spec issue for the new module, labelled `ready-for-agent`, with the canvas link
- [ ] One GitHub issue per ticket, under the spec issue
- [ ] Every ticket of the new module's spec is closed
- [ ] Every test passes
- [ ] Nothing in `legacy/` changed

| Symptom | Fix |
| --- | --- |
| `/implement-spec` says no ticket can start | Say "Work out which tickets can start from what has merged into the integration branch, not from GitHub." |
| Claude changes a file in `legacy/` | Stop it and say "Nothing in legacy/ changes. Undo that and put it in server/ or client/." |
| Tests fail and Claude keeps changing the test | Say "Fix the code, not the test" |
| A ticket of the spec is still open after the run | Ask Claude to close it on GitHub |
| /to-spec asks questions | "The deciding is done. Write the spec from this conversation." |

## Sources

- [mattpocock/skills](https://github.com/mattpocock/skills): `SKILL.md` for to-spec, to-tickets, implement-spec, tdd, code-review; `docs/engineering/implement-spec.md` (on GitHub, work out the frontier from merges); `ask-matt` (steps 1 to 3 in one session, implement-spec for a whole spec)
- [v2 Day 1 Session 4 guide](https://claude.ai/artifact/Fbk7p4pHqKHMarTVTtMif5): Parts A to C
- [v2 Day 2 Session 1 guide](https://claude.ai/artifact/JZiqMyDaLd4FbHs61FG9TF)
