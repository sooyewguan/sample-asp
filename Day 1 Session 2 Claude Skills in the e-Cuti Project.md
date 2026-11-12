# Day 1 Session 2: Claude Skills in the e-Cuti Project

Nov 11, 2026 · @Soo Yew Guan

Everything happens in the Claude desktop app's Code tab, in your project folder from session 1, which is linked to your private e-Cuti repository on GitHub.

## Before you start

You need everything from session 1 done:

- [ ] The final check of session 1 passes.
- [ ] You can start a Code tab session from your saved environment, in the `ecuti` project folder you created in F1.
- [ ] You know the Code tab controls from E4 in session 1.
- [ ] The GitHub CLI (`gh`) is installed and signed in to your GitHub account (session 1).

Start a new session from your saved environment now. The mode is **Auto**, as at the end of session 1: Claude edits files and runs commands without asking, and the check at the end of each part tells you what to look at afterwards.

## Part A: what a skill is

A skill is a folder with a `SKILL.md` file that holds instructions for one kind of task.

- A skill runs in two ways: you type `/` followed by its name, or Claude uses it when your request matches its description.
- Some skills run only when you type them. Their `SKILL.md` sets `disable-model-invocation: true`.
- A project skill lives in the project's `.claude/skills/` folder. Today you install Matt Pocock's skills this way, as files you can edit. Your repository's `.gitignore` from session 1 F2 lists `.claude/`, `.agents/` and `skills-lock.json`, so the skills stay out of git.

Check: type `/` in the prompt box. This is the list where Matt Pocock's skills appear after Part B.

## Part B: install the Matt Pocock skills

Matt Pocock's skills are at [github.com/mattpocock/skills](https://github.com/mattpocock/skills). The Installation section of its README says how to install them.

His README offers two ways: a plugin that updates itself, or skills.sh, which copies editable files into your project that you update by hand. You use skills.sh, because in Part F you edit one of the skills. You install only the 16 skills the workshop needs.

skills.sh copies the skills from the newest commit on the repository's `main` branch at the moment you install, not from a numbered release. There is no way to pick an older commit. Everyone who installs on the same day gets the same files, and `skills-lock.json` records where they came from.

1. In your Code tab session, send this to Claude:

   ```text
   Following https://github.com/mattpocock/skills, install these skills for Claude Code in this project with skills.sh, as editable files: setup-matt-pocock-skills, triage, grill-with-docs, grilling, domain-modeling, to-spec, to-tickets, implement, tdd, codebase-design, code-review, diagnosing-bugs, retro, writing-for-agents, ask-matt, implement-spec
   ```
2. Claude works out the steps and runs them. When it finishes, ask: "List the commands you ran."
3. Start a new session from your saved environment with **+ New**.

The skills are now in your project's `.claude/skills/` folder, one folder per skill, and `skills-lock.json` records where they came from.

Check: type `/` in the prompt box. The list shows `/grill-with-docs`.

## Part C: the skills you use today

You installed 16 skills. The table shows the 12 you work with over the two days. You installed the other four for these reasons. `setup-matt-pocock-skills` checks whether `triage` is installed, and creates the triage labels only if it is. `retro` calls `writing-for-agents`. `tdd` calls `codebase-design` when the shape of an interface is in question. `ask-matt` tells you which skill or flow fits your situation, and the order below comes from it; it runs only when you type `/ask-matt`. Don't run any of them yet.

| Skill | What it does |
| --- | --- |
| `setup-matt-pocock-skills` | Sets up the project for the other skills: issue tracker, triage labels, where docs go. You run it once, in D1 |
| `grill-with-docs` | Runs the next two together: the interview, with agreed terms written to `GLOSSARY.md` as you go |
| `grilling` | Interviews you about your plan, with a recommended answer for each question |
| `domain-modeling` | Writes agreed terms to `GLOSSARY.md` as you settle them. Offers an ADR only for a decision that is hard to reverse, surprising without context, and the result of a real trade-off, so most sessions produce none |
| `to-spec` | Turns the conversation into a spec and publishes it to the issue tracker |
| `to-tickets` | Breaks the spec into small tickets, each a thin slice through every layer |
| `implement` | Builds the work in a spec or ticket, test first where it can, then reviews it and commits |
| `implement-spec` | Builds every ticket of a spec: hands each ticket to its own subagent, runs the ones that can start at the same time, merges them onto one branch, reviews the result and closes the tickets |
| `tdd` | Writes one failing test, then just enough code to pass it |
| `code-review` | Reviews the changes against coding standards and against the spec |
| `diagnosing-bugs` | Finds the cause of a hard bug and fixes it, with a regression test where the code has a seam for one |
| `retro` | Looks back at the session and suggests improvements to the setup |

The order they run in:

1. `/setup-matt-pocock-skills`, once per project, before anything else. You run it in D1.
2. `/grill-with-docs` on the work. It loads `grilling` for the interview and `domain-modeling`, which writes terms to `GLOSSARY.md` as you agree them. If `GLOSSARY.md` has not appeared after a few answers, ask Claude which skills it loaded and type `/domain-modeling`: Matt Pocock's docs say models sometimes skip a skill that another skill calls.
3. `/to-spec`, then `/to-tickets`. Keep steps 2 and 3 in one session: don't start a new session until the tickets exist.
4. `/implement-spec` on the spec. One Claude hands each ticket to its own subagent, and the subagents build the tickets at the same time. On Day 2 you use `/implement` instead, one ticket per session.
5. `/retro`, in the same session as the work it looks back on, before you start a new session.

Today you run steps 2 to 5 on the migration of e-Cuti. Tomorrow you run them again on a new module, in the same folder.

## Part D: the project

### D1. Set up the skills and read the project setup

Type:

```text
/setup-matt-pocock-skills
```

When it asks, choose GitHub as the issue tracker and create the default triage labels. When it asks whether to write `CLAUDE.md` or `AGENTS.md`, answer `CLAUDE.md`. Read each draft before you confirm it.

When it finishes, send:

```text
At the top of CLAUDE.md, above the Agent skills section, add a short section that says what this project is: legacy/ holds the classic ASP e-Cuti and database/ holds its database script; it is migrated to an ASP.NET Core API in server/ and a React app in client/; LegacyDb keeps its tables and its data.
```

Then ask Claude:

```text
Show me CLAUDE.md and list the files in docs/agents.
```

Claude Code reads `CLAUDE.md` at the start of every session, so it goes into the context of every agent that works in this project. Matt Pocock's `retro` skill says it should be used "incredibly sparingly, usually only for navigation pointers to other files." Your repository's `CLAUDE.md` now holds two things:

- What the project is, from the prompt above.
- The `## Agent skills` section that `setup-matt-pocock-skills` writes. It points to the files in `docs/agents/`: the tracker is GitHub issues in your own repository, the five default triage labels, and one `GLOSSARY.md` with a `docs/adr/` folder for the whole project.

Coding standards don't go in `CLAUDE.md`. They go in `CODING_STANDARDS.md`, which `code-review` reads when it reviews your changes. You write it on Day 2.

Check: `CLAUDE.md` starts with what the project is and has a `## Agent skills` section, and `docs/agents/` holds `issue-tracker.md`, `domain.md` and `triage-labels.md`.

Then ask Claude "List the labels in my repository." They include `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human` and `wontfix`.

### D2. Create the ASP.NET Core project

Ask Claude:

```text
Create one ASP.NET Core project in a folder named server inside this folder, with the ASP.NET Core Empty template. Then add the .NET gitignore from dotnet new gitignore to the .gitignore at the root of this folder, keeping every line already in it.
```

The project goes in `server` so that the React app can go in a `client` folder beside it this afternoon, with neither folder inside the other and both beside `legacy`. The .NET gitignore keeps build output, NuGet packages, test results and Visual Studio settings out of git; the lines already in your repository's `.gitignore` keep the workshop's local files out.

Check: ask Claude "Which files would git commit now?" The list should be only `.gitignore` at the root and these, inside `server`: `Program.cs`, `Properties/launchSettings.json`, `appsettings.json`, `appsettings.Development.json` and the `.csproj` file. Then ask "Does .gitignore still list .mcp.json, .claude/ and skills-lock.json?" The answer is yes.

### D3. Commit and push

Ask Claude:

```text
Commit server/ and .gitignore with the message: Add server project. Then push it to my repository.
```

Check: ask Claude "Show me the latest commit and the repository it was pushed to." Its message is `Add server project`, and the repository is your private one.

## Part E: add two rules to CLAUDE.md

Besides `CLAUDE.md`, Claude keeps its own notes, called auto memory, in `~/.claude/projects/<project>/memory/`. Auto memory is on by default, and Claude decides by itself what to save there. The Claude Code memory docs list "always do X" rules as something that goes in `CLAUDE.md`. Ask Claude:

```text
Add two rules to CLAUDE.md: nothing in legacy/ changes, and before you save anything to auto memory or change CLAUDE.md, tell me what you want to save and ask me first.
```

Then test the second rule.

Tell Claude something it can't find in your project yet:

```text
Remember that I run legacy e-Cuti on IIS at http://localhost:8080.
```

Check: Claude tells you what it wants to save and asks first. The memory docs say Claude treats `CLAUDE.md` as "context, not enforced configuration", so if Claude ever saves without asking, tell it to follow the rule in `CLAUDE.md`.

## Part F: edit a skill

Your edit stays until skills.sh replaces the file. That happens when you run the install again, or when you update the skills after Matt Pocock has changed the grilling skill. An update also moves the skill to `.agents/skills/grilling/` and leaves a link to it at `.claude/skills/grilling`. Either way, you make the edit again.

The interview in session 3 runs through `/grill-with-docs`, which calls `grilling`. The `grilling` skill's `SKILL.md` tells Claude to ask every open question it can in one round, so it asks several numbered questions at once. To get one question at a time, replace the two sentences that say so:

1. Open **VS Code**, choose **File**, **Open Folder**, and open your project folder.
2. In the Explorer, open `.claude/skills/grilling/SKILL.md`.
3. Press Ctrl+F and find these two sentences, in the second paragraph:

   ```text
   Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.
   ```
4. Select both sentences and paste this in their place:

   ```text
   Ask one question from the frontier at a time, with your recommended answer, and wait for my answer before the next question.
   ```
5. Save the file.

If Ctrl+F doesn't find the sentences, Matt Pocock has reworded the skill since 11 Nov. Paste your sentence at the end of the file instead, followed by: `This replaces the rounds described above.`

The skills folder is not in git, so this edit is not committed.

Check: ask Claude "Does .claude/skills/grilling/SKILL.md still say to ask the whole frontier in one round?" The answer is no, and Claude shows your sentence.

## Final check and troubleshooting

- [ ] Typing `/` shows `/grill-with-docs`
- [ ] `CLAUDE.md` has a `## Agent skills` section and the memory rule
- [ ] `docs/agents/` holds `issue-tracker.md`, `domain.md` and `triage-labels.md`
- [ ] Your repository has the five triage labels
- [ ] `server/` holds the ASP.NET Core Empty project, committed as `Add server project` and pushed to your repository
- [ ] Claude asked before saving to memory (Part E)
- [ ] `.claude/skills/grilling/SKILL.md` asks one question at a time (Part F)

| Symptom | Fix |
| --- | --- |
| Claude reports that an install command failed | Show the facilitator the error message Claude reports |
| The skills don't appear when you type `/` | Start a new session from your saved environment with **+ New**, then type `/` again |
| Claude reports that `gh` isn't installed or isn't signed in | Finish the GitHub CLI step in session 1 E3. Then quit the Claude desktop app from the system tray icon and open it again. Closing the window is not enough. Start a new session with **+ New** |
| The push is refused | Ask Claude: "Set origin to my private repository and push again." |
| "Which files would git commit now?" lists `legacy/inc/conn.asp` | Ask Claude: "Restore legacy/inc/conn.asp from git." The password belongs only in C:\\inetpub\\ecuti (session 1 H1) |
| `/grill-with-docs` asks several questions at once, or `GLOSSARY.md` doesn't change while you answer | Ask Claude which skills it loaded, and type `/domain-modeling` or `/grilling` again for any it didn't. If `.claude/skills/grilling/SKILL.md` no longer has your Part F edit, a skills update replaced the file: redo Part F |

## Sources

- [Claude Code: skills](https://code.claude.com/docs/en/skills)
- [Claude Code: desktop app](https://code.claude.com/docs/en/desktop)
- [Claude Code: memory](https://code.claude.com/docs/en/memory)
- [mattpocock/skills on GitHub](https://github.com/mattpocock/skills): the Installation section of the README, each skill's `SKILL.md` (for the order of the flow, `ask-matt`; for what goes in `CLAUDE.md`, `retro`), and the docs pages for `grilling` and `domain-modeling`
- [skills CLI (skills.sh) docs](https://github.com/vercel-labs/skills/tree/main/docs): `skills add`, `skills update`, and the Claude Code skills folder
- [sooyewguan/sample-asp](https://github.com/sooyewguan/sample-asp): `README.md`
- [.NET default templates for dotnet new](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-new-sdk-templates): ASP.NET Core Empty is the `web` template
