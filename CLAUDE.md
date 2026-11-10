# e-Cuti migration

The classic ASP application in `legacy/` is being migrated to an ASP.NET Core API in `server/` and a React app in `client/`. Nothing in `legacy/` changes. The database is `LegacyDb` and it keeps its tables and its data.

Before you save anything to auto memory or change CLAUDE.md, tell me what you want to save and ask me first.

## Agent skills

### Issue tracker

Issues, specs and tickets are GitHub issues in this project's own repository. See `docs/agents/issue-tracker.md`.

### Triage labels

The five default triage labels, each label string equal to its role name. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
